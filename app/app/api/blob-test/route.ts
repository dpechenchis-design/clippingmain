import { put } from "@vercel/blob";
import { NextResponse } from "next/server";

export async function GET() {
  const start = Date.now();
  const tokenPrefix = process.env.BLOB_READ_WRITE_TOKEN?.slice(0, 25) ?? "MISSING";
  const storeId = process.env.BLOB_STORE_ID ?? "MISSING";
  try {
    const blob = await put("diagnostic-test.txt", "hello world", {
      access: "public",
      addRandomSuffix: true,
      token: process.env.BLOB_READ_WRITE_TOKEN,
    });
    return NextResponse.json({ ok: true, ms: Date.now() - start, url: blob.url, tokenPrefix, storeId });
  } catch (error) {
    return NextResponse.json(
      { ok: false, ms: Date.now() - start, error: (error as Error).message, tokenPrefix, storeId },
      { status: 500 }
    );
  }
}
