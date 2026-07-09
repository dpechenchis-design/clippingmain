import { put } from "@vercel/blob";
import { NextResponse } from "next/server";

export async function GET() {
  const start = Date.now();
  try {
    const blob = await put("diagnostic-test.txt", "hello world", {
      access: "public",
      addRandomSuffix: true,
    });
    return NextResponse.json({ ok: true, ms: Date.now() - start, url: blob.url });
  } catch (error) {
    return NextResponse.json(
      { ok: false, ms: Date.now() - start, error: (error as Error).message },
      { status: 500 }
    );
  }
}
