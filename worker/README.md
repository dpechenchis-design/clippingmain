# Clipping worker

Native-ffmpeg background worker for the Clipping web app. Handles the two heavy
jobs that don't fit on Vercel serverless / in-browser wasm:

- **Transcription** — extracts compressed mono audio from the source video,
  splits it into ≤10-min chunks, runs each through Whisper, and stitches the
  timecoded segments back together. Works for multi-hour, multi-GB videos (the
  25MB Whisper limit only ever applies to a single small audio chunk).
  Uses OpenAI Whisper because **Anthropic has no speech-to-text API**.
- **Clip discovery** — finds viral-moment candidates in the transcript using
  **Claude** (`claude-opus-4-8` by default, override with `CLIP_MODEL`),
  feedback-aware: rejected clips are passed back so it avoids similar ones.
- **Cutting** — cuts each clip's fragments straight from the Blob video URL.
  Because it uses `ffmpeg -ss` **before** `-i`, ffmpeg range-seeks the HTTP
  source and pulls only the bytes it needs — a 30s clip out of a 5GB file does
  **not** download 5GB. Same buffer rules as the local `clipping` skill: 5s
  before the first fragment, 1s after the last, no inner buffers, re-encode,
  concat in transcript order. Finished clip is uploaded to Vercel Blob.

Both endpoints are fire-and-forget: they return `202` immediately and write
results (segments, clip rows, `result_url`, errors) straight into the shared
Postgres DB. The web app polls those rows for progress — no long-held HTTP
connections, so nothing can time out.

## Endpoints

All except `/health` require `Authorization: Bearer $WORKER_SECRET`.

- `GET  /health` → `{ ok: true }`
- `POST /analyze` `{ projectId }` → transcribe (if needed) + find clip candidates
- `POST /cut` `{ clipId }` → cut + upload, sets `clips.result_url`

## Run locally

```bash
npm install
cp .env.example .env    # fill in the values
# needs ffmpeg on PATH: `brew install ffmpeg`
node --env-file=.env server.mjs
```

## Deploy (Railway / Fly / any container host)

The `Dockerfile` bundles ffmpeg. Point the host at this folder.

**Railway:** New Project → Deploy from repo → set root directory to `worker/` →
add the env vars from `.env.example`. Railway builds the Dockerfile and injects
`PORT` automatically. Copy the public URL.

**Fly.io:** `fly launch` in this folder (detects the Dockerfile) → `fly secrets
set DATABASE_URL=... OPENAI_API_KEY=... BLOB_READ_WRITE_TOKEN=... WORKER_SECRET=...`
→ `fly deploy`.

Then in the **Vercel app** set:

- `WORKER_URL` = the worker's public URL (e.g. `https://clipping-worker.up.railway.app`)
- `WORKER_SECRET` = the same secret you set here
