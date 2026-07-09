import { neon, type NeonQueryFunction } from "@neondatabase/serverless";

let client: NeonQueryFunction<false, false> | null = null;

function getClient(): NeonQueryFunction<false, false> {
  if (!client) {
    const url = process.env.DATABASE_URL || process.env.POSTGRES_URL;
    if (!url) {
      throw new Error(
        "DATABASE_URL is not set. Add a Postgres database (Vercel Marketplace -> Neon) and set DATABASE_URL in your env."
      );
    }
    client = neon(url);
  }
  return client;
}

// Lazily resolves the real client on first query, so importing this module
// (e.g. during `next build`'s page-data collection) never requires
// DATABASE_URL to be set.
export const sql = ((...args: Parameters<NeonQueryFunction<false, false>>) =>
  getClient()(...args)) as NeonQueryFunction<false, false>;

let schemaReady: Promise<void> | null = null;

export function ensureSchema(): Promise<void> {
  if (!schemaReady) {
    schemaReady = (async () => {
      await sql`
        CREATE TABLE IF NOT EXISTS projects (
          id UUID PRIMARY KEY,
          name TEXT NOT NULL,
          video_url TEXT NOT NULL,
          video_duration NUMERIC,
          transcript TEXT,
          segments JSONB,
          status TEXT NOT NULL DEFAULT 'uploaded',
          error_message TEXT,
          created_at TIMESTAMPTZ NOT NULL DEFAULT now()
        )
      `;
      await sql`
        CREATE TABLE IF NOT EXISTS clips (
          id UUID PRIMARY KEY,
          project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
          topic TEXT NOT NULL,
          hook_reason TEXT NOT NULL DEFAULT '',
          fragments JSONB NOT NULL,
          status TEXT NOT NULL DEFAULT 'pending',
          reject_reason TEXT,
          result_url TEXT,
          cut_error TEXT,
          created_at TIMESTAMPTZ NOT NULL DEFAULT now()
        )
      `;
      // Backfill columns for pre-existing tables.
      await sql`ALTER TABLE clips ADD COLUMN IF NOT EXISTS result_url TEXT`;
      await sql`ALTER TABLE clips ADD COLUMN IF NOT EXISTS cut_error TEXT`;
      await sql`ALTER TABLE projects ADD COLUMN IF NOT EXISTS segments JSONB`;
    })();
  }
  return schemaReady;
}
