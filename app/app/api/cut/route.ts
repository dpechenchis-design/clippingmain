import { NextResponse } from "next/server";
import { ensureSchema, sql } from "@/lib/db";
import { callWorker } from "@/lib/worker";

export async function POST(request: Request) {
  await ensureSchema();
  const { clipId } = await request.json();
  if (!clipId) {
    return NextResponse.json({ error: "clipId is required" }, { status: 400 });
  }

  const rows = await sql`SELECT id FROM clips WHERE id = ${clipId}`;
  if (rows.length === 0) {
    return NextResponse.json({ error: "clip not found" }, { status: 404 });
  }

  // Clear any prior result/error so the UI shows a fresh "cutting" state.
  await sql`UPDATE clips SET result_url = NULL, cut_error = NULL WHERE id = ${clipId}`;

  try {
    await callWorker("/cut", { clipId });
  } catch (error) {
    const message = (error as Error).message;
    await sql`UPDATE clips SET cut_error = ${message} WHERE id = ${clipId}`;
    return NextResponse.json({ error: message }, { status: 502 });
  }

  return NextResponse.json({ accepted: true });
}
