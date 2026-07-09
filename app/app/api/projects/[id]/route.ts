import { NextResponse } from "next/server";
import { ensureSchema, sql } from "@/lib/db";
import type { Clip, Project } from "@/lib/types";

export async function GET(
  _request: Request,
  { params }: { params: Promise<{ id: string }> }
) {
  await ensureSchema();
  const { id } = await params;

  const projectRows = await sql`SELECT * FROM projects WHERE id = ${id}`;
  if (projectRows.length === 0) {
    return NextResponse.json({ error: "not found" }, { status: 404 });
  }
  const p = projectRows[0] as any;
  const project: Project = {
    id: p.id,
    name: p.name,
    videoUrl: p.video_url,
    videoDuration: p.video_duration ? Number(p.video_duration) : null,
    transcript: p.transcript,
    segments: p.segments,
    status: p.status,
    errorMessage: p.error_message,
    createdAt: p.created_at,
  };

  const clipRows = await sql`
    SELECT * FROM clips WHERE project_id = ${id} ORDER BY created_at ASC
  `;
  const clips: Clip[] = clipRows.map((c: any) => ({
    id: c.id,
    projectId: c.project_id,
    topic: c.topic,
    hookReason: c.hook_reason,
    fragments: c.fragments,
    status: c.status,
    rejectReason: c.reject_reason,
    resultUrl: c.result_url,
    cutError: c.cut_error,
    createdAt: c.created_at,
  }));

  return NextResponse.json({ ...project, clips });
}
