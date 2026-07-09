"use client";

import { useRouter } from "next/navigation";
import { useRef, useState } from "react";
import { upload } from "@vercel/blob/client";

export default function Home() {
  const router = useRouter();
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [name, setName] = useState("");
  const [file, setFile] = useState<File | null>(null);
  const [status, setStatus] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  const [uploadPercent, setUploadPercent] = useState<number | null>(null);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!file) {
      setError("Choose a video file first.");
      return;
    }
    setError(null);
    setBusy(true);
    setUploadPercent(0);

    try {
      setStatus("Uploading video...");
      const blob = await upload(file.name, file, {
        access: "public",
        handleUploadUrl: "/api/upload",
        multipart: true,
        onUploadProgress: ({ percentage }) => setUploadPercent(percentage),
      });

      setUploadPercent(null);
      setStatus("Creating project...");
      const projectRes = await fetch("/api/projects", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ name: name || file.name, videoUrl: blob.url }),
      });
      if (!projectRes.ok) throw new Error((await projectRes.json()).error || "Failed to create project");
      const { id } = await projectRes.json();

      router.push(`/project/${id}`);
    } catch (err) {
      console.error("Upload failed:", err);
      const message =
        err instanceof Error && err.message ? err.message : "Upload failed. Check the browser console for details.";
      setError(message);
      setBusy(false);
      setStatus(null);
      setUploadPercent(null);
    }
  }

  return (
    <main className="flex-1 flex items-center justify-center px-6 py-16">
      <div className="w-full max-w-lg">
        <h1 className="text-2xl font-semibold mb-1">Clipping</h1>
        <p className="text-sm text-neutral-500 mb-8">
          Upload a long-form video. AI finds the viral moments. You approve or reject each one —
          rejections are remembered so it stops suggesting similar clips.
        </p>

        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-sm font-medium mb-1">Project name</label>
            <input
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="Podcast Ep. 42"
              className="w-full rounded-md border border-neutral-300 dark:border-neutral-700 bg-transparent px-3 py-2 text-sm"
            />
          </div>

          <div>
            <label className="block text-sm font-medium mb-1">Video file (mp4/mov/webm, up to 5GB)</label>
            <input
              ref={fileInputRef}
              type="file"
              accept="video/mp4,video/quicktime,video/webm"
              onChange={(e) => setFile(e.target.files?.[0] ?? null)}
              className="w-full text-sm"
            />
          </div>

          {error && <p className="text-sm text-red-500">{error}</p>}
          {status && (
            <p className="text-sm text-neutral-500">
              {status}
              {uploadPercent !== null && ` ${uploadPercent.toFixed(0)}%`}
            </p>
          )}
          {uploadPercent !== null && (
            <div className="h-1.5 w-full rounded-full bg-neutral-200 dark:bg-neutral-800 overflow-hidden">
              <div
                className="h-full bg-neutral-900 dark:bg-white transition-all"
                style={{ width: `${uploadPercent}%` }}
              />
            </div>
          )}

          <button
            type="submit"
            disabled={busy}
            className="w-full rounded-md bg-neutral-900 dark:bg-white text-white dark:text-neutral-900 px-4 py-2 text-sm font-medium disabled:opacity-50"
          >
            {busy ? "Working..." : "Upload & find clips"}
          </button>
        </form>
      </div>
    </main>
  );
}
