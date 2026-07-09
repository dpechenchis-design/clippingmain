import { NextResponse } from "next/server";
import { randomUUID } from "crypto";
import { ensureSchema, sql } from "@/lib/db";

export async function GET() {
  await ensureSchema();
  const rows = await sql`
    SELECT id, name, status, error_message, created_at
    FROM projects
    ORDER BY created_at DESC
    LIMIT 5
  `;
  return NextResponse.json(rows);
}

export async function POST(request: Request) {
  await ensureSchema();
  const { name, videoUrl } = await request.json();
  if (!name || !videoUrl) {
    return NextResponse.json({ error: "name and videoUrl are required" }, { status: 400 });
  }

  const id = randomUUID();
  await sql`
    INSERT INTO projects (id, name, video_url, status)
    VALUES (${id}, ${name}, ${videoUrl}, 'uploaded')
  `;

  return NextResponse.json({ id });
}
