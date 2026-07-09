import { NextResponse } from "next/server";
import { ensureSchema, sql } from "@/lib/db";
import { callWorker } from "@/lib/worker";

export async function POST(request: Request) {
  await ensureSchema();
  const { projectId } = await request.json();
  if (!projectId) {
    return NextResponse.json({ error: "projectId is required" }, { status: 400 });
  }

  const rows = await sql`SELECT id FROM projects WHERE id = ${projectId}`;
  if (rows.length === 0) {
    return NextResponse.json({ error: "project not found" }, { status: 404 });
  }

  // Mark as transcribing up front so the UI shows progress immediately; the
  // worker takes it from here (transcribe -> analyze -> ready) and writes back.
  await sql`UPDATE projects SET status = 'transcribing', error_message = NULL WHERE id = ${projectId}`;

  try {
    await callWorker("/analyze", { projectId });
  } catch (error) {
    const message = (error as Error).message;
    await sql`UPDATE projects SET status = 'error', error_message = ${message} WHERE id = ${projectId}`;
    return NextResponse.json({ error: message }, { status: 502 });
  }

  return NextResponse.json({ accepted: true });
}
