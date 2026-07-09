# Clipping — web app

Upload a long-form video, AI finds viral-moment clip candidates from the transcript, you approve
or reject each one. Approved clips are cut and uploaded, then you download them. Rejected clips are
remembered per project — the next "Find more clips" pass is told what you rejected and avoids
similar topics/angles.

The transcription and the actual cutting run on a **separate native-ffmpeg worker** (see
[`../worker`](../worker)) so files up to **5GB** work fine — the browser and Vercel serverless
never touch the heavy video. Buffer/cut rules mirror the local `clipping` Claude Code skill: 5s
buffer before the first fragment, 1s after the last, no buffer on inner fragments, always
re-encode, concatenated in the order the AI listed the fragments.

## Architecture

```
Browser ──upload video──▶ Vercel Blob (up to 5GB, multipart client upload)
Browser ──▶ Vercel (Next.js) ──fire job──▶ Worker (native ffmpeg, Docker)
                    │                              │
                    └──────── Postgres ◀───────────┘  (worker writes results,
                                  ▲                     web app polls them)
                    Browser polls project/clip rows for progress
```

- **Vercel (this app)** — UI, upload, project/clip CRUD, and firing jobs at the worker. Thin; no
  heavy compute, so no serverless timeout risk.
- **Worker** — Whisper transcription (audio extracted + chunked, so any length works) and cutting
  (ffmpeg range-seeks the Blob URL, downloading only the bytes each fragment needs). Writes
  segments, clip candidates, and finished-clip URLs straight to Postgres.

## Stack

- Next.js 16 (App Router)
- Vercel Blob — video storage, client-side multipart upload (up to 5GB)
- Postgres (Neon via Vercel Marketplace) — shared between app and worker
- Worker: Node + native ffmpeg + OpenAI Whisper + GPT-4o-mini (see `../worker`)

## Local setup

```bash
npm install
cp .env.example .env.local
# fill in DATABASE_URL, BLOB_READ_WRITE_TOKEN, WORKER_URL, WORKER_SECRET
npm run dev
```

Run the worker too (see [`../worker/README.md`](../worker/README.md)). The DB schema is created
automatically on first request (see `lib/db.ts`).

## Deploy to Vercel

1. Push this folder to a GitHub repo (or `vercel --cwd app` from the parent folder).
2. Import the repo in Vercel.
3. In the Vercel project: **Storage** tab → add **Blob** (sets `BLOB_READ_WRITE_TOKEN`
   automatically) and add a **Postgres** database from the Marketplace (Neon) — sets
   `DATABASE_URL` automatically.
4. Deploy the worker (see `../worker/README.md`), then set `WORKER_URL` and `WORKER_SECRET` in
   **Settings → Environment Variables**. `OPENAI_API_KEY` lives on the **worker**, not here.
5. Deploy.

## MVP notes

- Upload cap is 5GB (Vercel Blob's client multipart limit). Beyond that, chunk the source first.
- Feedback learning is per-project and prompt-based (rejected clips are listed in the next
  generation prompt) rather than a trained model — simple and effective within a project, doesn't
  yet generalize across projects.
