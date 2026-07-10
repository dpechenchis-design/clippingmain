# Clipping — web app

Upload a long-form video, AI finds viral-moment clip candidates from the transcript, you approve
or reject each one. Approved clips are cut and uploaded, then you download them. Rejected clips are
remembered per project — the next "Find more clips" pass is told what you rejected and avoids
similar topics/angles.

The upload, transcription, and cutting all run on a **separate native-ffmpeg worker** (see
[`../worker`](../worker)) so files up to **5GB** work fine — Vercel serverless never touches the
heavy video, and the browser uploads straight to the worker rather than to Vercel Blob's
client-upload flow (which proved unreliable — see the worker README for why). Buffer/cut rules
mirror the local `clipping` Claude Code skill: 5s buffer before the first fragment, 1s after the
last, no buffer on inner fragments, always re-encode, concatenated in the order the AI listed the
fragments.

## Architecture

```
Browser ──upload video (multipart/form-data)──▶ Worker /upload
                                                     │
                                          Vercel Blob ◀┘ (worker's own token)
                                                     │
Browser ──▶ Vercel (Next.js) ──fire job──▶ Worker (native ffmpeg, Docker)
                    │                              │
                    └──────── Postgres ◀───────────┘  (worker writes results,
                                  ▲                     web app polls them)
                    Browser polls project/clip rows for progress
```

- **Vercel (this app)** — UI, project/clip CRUD, and firing analyze/cut jobs at the worker. Thin;
  no heavy compute, so no serverless timeout risk. Never touches the video bytes.
- **Worker** — accepts the video upload directly from the browser, Whisper transcription (audio
  extracted + chunked, so any length works), and cutting (ffmpeg range-seeks the Blob URL,
  downloading only the bytes each fragment needs). Writes everything — the uploaded video URL,
  segments, clip candidates, finished-clip URLs — straight to Postgres.

## Stack

- Next.js 16 (App Router)
- Postgres (Neon via Vercel Marketplace) — shared between app and worker
- Worker: Node + native ffmpeg + Vercel Blob (server-side) + OpenAI Whisper + Claude (see
  `../worker`)

## Local setup

```bash
npm install
cp .env.example .env.local
# fill in DATABASE_URL, WORKER_URL, NEXT_PUBLIC_WORKER_URL, WORKER_SECRET
npm run dev
```

Run the worker too (see [`../worker/README.md`](../worker/README.md)). The DB schema is created
automatically on first request (see `lib/db.ts`).

## Deploy to Vercel

1. Push this folder to a GitHub repo (or `vercel --cwd app` from the parent folder).
2. Import the repo in Vercel.
3. In the Vercel project: **Storage** tab → add a **Postgres** database from the Marketplace
   (Neon) — sets `DATABASE_URL` automatically.
4. Deploy the worker (see `../worker/README.md`, needs its own Vercel Blob store + token), then
   set `WORKER_URL`, `NEXT_PUBLIC_WORKER_URL` (same value), and `WORKER_SECRET` in
   **Settings → Environment Variables**. `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, and
   `BLOB_READ_WRITE_TOKEN` all live on the **worker**, not here.
5. Deploy.

## MVP notes

- Upload cap is 5GB (worker's multer `fileSize` limit). Beyond that, chunk the source first.
- Feedback learning is per-project and prompt-based (rejected clips are listed in the next
  generation prompt) rather than a trained model — simple and effective within a project, doesn't
  yet generalize across projects.
