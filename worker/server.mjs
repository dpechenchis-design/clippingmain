import express from "express";
import cors from "cors";
import multer from "multer";
import { spawn } from "node:child_process";
import { mkdtemp, rm, readFile, writeFile, readdir } from "node:fs/promises";
import { createReadStream } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { randomUUID } from "node:crypto";
import { neon } from "@neondatabase/serverless";
import { put } from "@vercel/blob";
import OpenAI from "openai";
import Anthropic from "@anthropic-ai/sdk";

const {
  DATABASE_URL,
  ANTHROPIC_API_KEY,
  OPENAI_API_KEY,
  BLOB_READ_WRITE_TOKEN,
  WORKER_SECRET,
  PORT = 8080,
  // Model used to find viral clip candidates in the transcript.
  CLIP_MODEL = "claude-opus-4-8",
  // Audio chunk length (seconds) for transcription — keeps each Whisper request
  // well under the 25MB API limit regardless of total video length.
  TRANSCRIBE_CHUNK_SECONDS = 600,
} = process.env;

if (!DATABASE_URL) throw new Error("DATABASE_URL is required");
if (!ANTHROPIC_API_KEY) throw new Error("ANTHROPIC_API_KEY is required (clip discovery uses Claude)");
if (!OPENAI_API_KEY) throw new Error("OPENAI_API_KEY is required (Whisper transcription — Anthropic has no speech-to-text API)");
if (!BLOB_READ_WRITE_TOKEN) throw new Error("BLOB_READ_WRITE_TOKEN is required");
if (!WORKER_SECRET) throw new Error("WORKER_SECRET is required");

const sql = neon(DATABASE_URL);
const openai = new OpenAI({ apiKey: OPENAI_API_KEY });
const anthropic = new Anthropic({ apiKey: ANTHROPIC_API_KEY });

// ---------------------------------------------------------------------------
// ffmpeg helpers
// ---------------------------------------------------------------------------

function run(cmd, args) {
  return new Promise((resolve, reject) => {
    const p = spawn(cmd, args, { stdio: ["ignore", "pipe", "pipe"] });
    let stderr = "";
    p.stderr.on("data", (d) => (stderr += d.toString()));
    p.on("error", reject);
    p.on("close", (code) => {
      if (code === 0) resolve();
      else reject(new Error(`${cmd} exited ${code}: ${stderr.slice(-2000)}`));
    });
  });
}

function ffprobeDuration(input) {
  return new Promise((resolve, reject) => {
    const p = spawn("ffprobe", [
      "-v", "error",
      "-show_entries", "format=duration",
      "-of", "default=noprint_wrappers=1:nokey=1",
      input,
    ]);
    let out = "";
    let err = "";
    p.stdout.on("data", (d) => (out += d.toString()));
    p.stderr.on("data", (d) => (err += d.toString()));
    p.on("close", (code) =>
      code === 0 ? resolve(parseFloat(out.trim())) : reject(new Error(err))
    );
  });
}

function tc(seconds) {
  const s = Math.max(0, seconds);
  const h = Math.floor(s / 3600);
  const m = Math.floor((s - h * 3600) / 60);
  const sec = s - h * 3600 - m * 60;
  return `${String(h).padStart(2, "0")}:${String(m).padStart(2, "0")}:${sec
    .toFixed(3)
    .padStart(6, "0")}`;
}

// ---------------------------------------------------------------------------
// Transcription: extract compressed mono audio, split into chunks, Whisper each
// ---------------------------------------------------------------------------

async function transcribe(videoUrl, dir) {
  const audioPath = join(dir, "audio.mp3");
  // -vn drops video; ffmpeg streams the http input, downloading it once.
  await run("ffmpeg", [
    "-y", "-i", videoUrl,
    "-vn", "-ac", "1", "-ar", "16000", "-b:a", "48k",
    audioPath,
  ]);

  const duration = await ffprobeDuration(audioPath);
  const chunkLen = Number(TRANSCRIBE_CHUNK_SECONDS);
  const segments = [];
  let fullText = "";

  for (let start = 0; start < duration; start += chunkLen) {
    const chunkPath = join(dir, `chunk_${start}.mp3`);
    await run("ffmpeg", [
      "-y", "-ss", String(start), "-t", String(chunkLen),
      "-i", audioPath, "-c", "copy", chunkPath,
    ]);

    const transcription = await openai.audio.transcriptions.create({
      file: createReadStream(chunkPath),
      model: "whisper-1",
      response_format: "verbose_json",
      timestamp_granularities: ["segment"],
    });

    fullText += (fullText ? " " : "") + (transcription.text || "");
    for (const s of transcription.segments || []) {
      segments.push({
        start: s.start + start,
        end: s.end + start,
        text: String(s.text).trim(),
      });
    }
    await rm(chunkPath, { force: true });
  }

  await rm(audioPath, { force: true });
  return { fullText, segments, duration };
}

// ---------------------------------------------------------------------------
// Clip discovery (GPT), feedback-aware
// ---------------------------------------------------------------------------

async function findViralClips({ segments, rejectedClips, approvedClips, count = 6 }) {
  const transcriptBlock = segments
    .map((s) => `[${s.start.toFixed(1)} -> ${s.end.toFixed(1)}] ${s.text}`)
    .join("\n");

  const rejectedBlock = rejectedClips.length
    ? rejectedClips
        .map(
          (c, i) =>
            `${i + 1}. "${c.topic}" — candidate reason was: ${c.hookReason}. Fragments: ${c.fragments
              .map((f) => `"${f.text}"`)
              .join(" / ")}`
        )
        .join("\n")
    : "(none yet)";

  const usedRanges =
    approvedClips
      .flatMap((c) => c.fragments)
      .map((f) => `${f.start.toFixed(1)}-${f.end.toFixed(1)}`)
      .join(", ") || "(none)";

  const system =
    "You are an expert short-form video producer who finds viral-worthy clip candidates inside long-form video transcripts (podcasts, interviews, talks). You select self-contained, high-hook moments that work as standalone 15-90s clips.";

  const userPrompt = `Here is a timestamped transcript of a long-form video (timecodes in seconds):

${transcriptBlock}

TASK: Propose ${count} NEW clip candidates. Each clip is made of 1-5 non-contiguous fragments (exact start/end seconds copied from the transcript above) concatenated in the order you list them, that together form one compelling short clip with a strong hook in the first fragment.

RULES:
- Only use timecodes that appear in the transcript above.
- Do NOT reuse fragments already used in these approved clips (time ranges): ${usedRanges}
- Do NOT propose clips similar in topic/angle/wording to these REJECTED candidates — the user explicitly did not want these, learn the pattern and avoid it:
${rejectedBlock}
- Each clip needs a short topic title (5-8 words) and a one-sentence "hookReason".
- fragments text is the actual spoken text for that fragment.`;

  const message = await anthropic.messages.create({
    model: CLIP_MODEL,
    max_tokens: 8000,
    system,
    messages: [{ role: "user", content: userPrompt }],
    output_config: {
      format: {
        type: "json_schema",
        schema: {
          type: "object",
          additionalProperties: false,
          properties: {
            clips: {
              type: "array",
              items: {
                type: "object",
                additionalProperties: false,
                properties: {
                  topic: { type: "string" },
                  hookReason: { type: "string" },
                  fragments: {
                    type: "array",
                    items: {
                      type: "object",
                      additionalProperties: false,
                      properties: {
                        start: { type: "number" },
                        end: { type: "number" },
                        text: { type: "string" },
                      },
                      required: ["start", "end", "text"],
                    },
                  },
                },
                required: ["topic", "hookReason", "fragments"],
              },
            },
          },
          required: ["clips"],
        },
      },
    },
  });

  const textBlock = message.content.find((b) => b.type === "text");
  let parsed;
  try {
    parsed = JSON.parse(textBlock?.text || "{}");
  } catch {
    parsed = {};
  }
  const arr = Array.isArray(parsed) ? parsed : parsed.clips || [];
  return arr.filter((c) => c && c.topic && Array.isArray(c.fragments) && c.fragments.length > 0);
}

// ---------------------------------------------------------------------------
// Cutting: per-fragment range-seek cut straight from the blob URL, then concat
// ---------------------------------------------------------------------------

async function cutClip(videoUrl, fragments, outputName, dir) {
  const fragFiles = [];
  const lastIndex = fragments.length - 1;

  for (let i = 0; i < fragments.length; i++) {
    let start = fragments[i].start;
    let end = fragments[i].end;
    if (i === 0) start = Math.max(0, start - 5); // 5s pre-buffer on first
    if (i === lastIndex) end = end + 1; // 1s post-buffer on last
    const dur = Math.max(0.1, end - start);

    const fragPath = join(dir, `frag_${i}.mp4`);
    // -ss before -i => ffmpeg range-seeks the http input, pulling only the
    // bytes it needs instead of downloading the whole (possibly multi-GB) file.
    await run("ffmpeg", [
      "-y", "-ss", tc(start), "-i", videoUrl, "-t", String(dur),
      "-c:v", "libx264", "-preset", "veryfast", "-crf", "23",
      "-c:a", "aac", "-b:a", "128k", "-ar", "48000",
      fragPath,
    ]);
    fragFiles.push(fragPath);
  }

  const listPath = join(dir, "concat.txt");
  await writeFile(listPath, fragFiles.map((f) => `file '${f}'`).join("\n"));

  const outPath = join(dir, "out.mp4");
  await run("ffmpeg", ["-y", "-f", "concat", "-safe", "0", "-i", listPath, "-c", "copy", outPath]);

  const data = await readFile(outPath);
  const safe = outputName.replace(/[^a-zA-Z0-9]+/g, "_").slice(0, 60) || "clip";
  const blob = await put(`clips/${randomUUID()}_${safe}.mp4`, data, {
    access: "public",
    contentType: "video/mp4",
    token: BLOB_READ_WRITE_TOKEN,
  });
  return blob.url;
}

// ---------------------------------------------------------------------------
// Pipelines writing straight back to the shared DB
// ---------------------------------------------------------------------------

async function runAnalyze(projectId) {
  const rows = await sql`SELECT * FROM projects WHERE id = ${projectId}`;
  if (!rows.length) return;
  const project = rows[0];
  const dir = await mkdtemp(join(tmpdir(), "clip-analyze-"));

  try {
    let segments = project.segments || [];
    if (!segments.length) {
      await sql`UPDATE projects SET status = 'transcribing' WHERE id = ${projectId}`;
      const t = await transcribe(project.video_url, dir);
      segments = t.segments;
      await sql`
        UPDATE projects
        SET transcript = ${t.fullText}, segments = ${JSON.stringify(segments)}, video_duration = ${t.duration}
        WHERE id = ${projectId}
      `;
    }

    await sql`UPDATE projects SET status = 'analyzing' WHERE id = ${projectId}`;

    const existing = await sql`SELECT * FROM clips WHERE project_id = ${projectId}`;
    const rejectedClips = existing
      .filter((c) => c.status === "rejected")
      .map((c) => ({ topic: c.topic, hookReason: c.hook_reason, fragments: c.fragments }));
    const approvedClips = existing
      .filter((c) => c.status === "approved")
      .map((c) => ({ topic: c.topic, fragments: c.fragments }));

    const candidates = await findViralClips({ segments, rejectedClips, approvedClips, count: 6 });
    for (const c of candidates) {
      await sql`
        INSERT INTO clips (id, project_id, topic, hook_reason, fragments, status)
        VALUES (${randomUUID()}, ${projectId}, ${c.topic}, ${c.hookReason}, ${JSON.stringify(c.fragments)}, 'pending')
      `;
    }

    await sql`UPDATE projects SET status = 'ready', error_message = NULL WHERE id = ${projectId}`;
  } catch (err) {
    await sql`UPDATE projects SET status = 'error', error_message = ${String(err.message || err)} WHERE id = ${projectId}`;
  } finally {
    await rm(dir, { recursive: true, force: true });
  }
}

async function runCut(clipId) {
  const rows = await sql`
    SELECT c.*, p.video_url AS video_url
    FROM clips c JOIN projects p ON p.id = c.project_id
    WHERE c.id = ${clipId}
  `;
  if (!rows.length) return;
  const clip = rows[0];
  const dir = await mkdtemp(join(tmpdir(), "clip-cut-"));

  try {
    await sql`UPDATE clips SET cut_error = NULL WHERE id = ${clipId}`;
    const url = await cutClip(clip.video_url, clip.fragments, clip.topic, dir);
    await sql`UPDATE clips SET result_url = ${url} WHERE id = ${clipId}`;
  } catch (err) {
    await sql`UPDATE clips SET cut_error = ${String(err.message || err)} WHERE id = ${clipId}`;
  } finally {
    await rm(dir, { recursive: true, force: true });
  }
}

// ---------------------------------------------------------------------------
// HTTP
// ---------------------------------------------------------------------------

const app = express();
app.use(cors());
app.use(express.json({ limit: "2mb" }));

const ALLOWED_VIDEO_TYPES = new Set([
  "video/mp4",
  "video/quicktime",
  "video/x-m4v",
  "video/webm",
]);

// Videos are streamed to a temp file on disk (never buffered in memory) so a
// 5GB upload doesn't blow the worker's RAM.
const upload = multer({
  dest: join(tmpdir(), "clip-uploads"),
  limits: { fileSize: 5 * 1024 * 1024 * 1024 },
  fileFilter: (_req, file, cb) => {
    cb(null, ALLOWED_VIDEO_TYPES.has(file.mimetype));
  },
});

app.use((req, res, next) => {
  // Public, unauthenticated: the browser uploads video bytes directly here
  // (this replaces the Vercel Blob client-upload flow, which kept failing
  // with delegated-token errors on this project's store). /analyze and /cut
  // stay behind WORKER_SECRET since only our own Vercel app calls those.
  if (req.path === "/health" || req.path === "/upload") return next();
  const auth = req.headers.authorization || "";
  if (auth !== `Bearer ${WORKER_SECRET}`) {
    return res.status(401).json({ error: "unauthorized" });
  }
  next();
});

app.get("/health", (_req, res) => res.json({ ok: true }));

// Browser uploads the raw video file here (multipart/form-data: name, video).
// We stream it straight to Vercel Blob using the worker's own read-write
// token (server-to-server -- the one auth path that's actually reliable)
// and create the project row, mirroring what the old client-upload +
// POST /api/projects flow used to do.
app.post("/upload", upload.single("video"), async (req, res) => {
  const file = req.file;
  const name = (req.body?.name || "").trim();
  if (!file) return res.status(400).json({ error: "video file is required" });

  try {
    const safeName = file.originalname.replace(/[^a-zA-Z0-9._-]+/g, "_").slice(-80) || "video.mp4";
    const blob = await put(`videos/${randomUUID()}_${safeName}`, createReadStream(file.path), {
      access: "public",
      contentType: file.mimetype,
      token: BLOB_READ_WRITE_TOKEN,
    });

    const id = randomUUID();
    await sql`
      INSERT INTO projects (id, name, video_url, status)
      VALUES (${id}, ${name || file.originalname}, ${blob.url}, 'uploaded')
    `;

    res.json({ id });
  } catch (err) {
    console.error("upload failed", err);
    res.status(500).json({ error: String(err.message || err) });
  } finally {
    await rm(file.path, { force: true });
  }
});

// Fire-and-forget: accept immediately, process in the background, write results
// to the DB. The web app polls the project/clip rows for progress.
app.post("/analyze", (req, res) => {
  const { projectId } = req.body || {};
  if (!projectId) return res.status(400).json({ error: "projectId required" });
  res.status(202).json({ accepted: true });
  runAnalyze(projectId).catch((e) => console.error("analyze failed", e));
});

app.post("/cut", (req, res) => {
  const { clipId } = req.body || {};
  if (!clipId) return res.status(400).json({ error: "clipId required" });
  res.status(202).json({ accepted: true });
  runCut(clipId).catch((e) => console.error("cut failed", e));
});

app.listen(PORT, () => console.log(`clipping-worker listening on ${PORT}`));
