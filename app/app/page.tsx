"use client";

import { useRouter } from "next/navigation";
import { useRef, useState } from "react";

const WORKER_URL = process.env.NEXT_PUBLIC_WORKER_URL;

export default function Home() {
  const router = useRouter();
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [name, setName] = useState("");
  const [file, setFile] = useState<File | null>(null);
  const [status, setStatus] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  const [uploadPercent, setUploadPercent] = useState<number | null>(null);
  const [log, setLog] = useState<string[]>([]);

  function addLog(message: string) {
    const time = new Date().toLocaleTimeString();
    setLog((prev) => [...prev, `[${time}] ${message}`]);
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!file) {
      setError("Choose a video file first.");
      return;
    }
    if (!WORKER_URL) {
      setError("Worker URL is not configured (NEXT_PUBLIC_WORKER_URL missing).");
      return;
    }
    setError(null);
    setBusy(true);
    setUploadPercent(0);
    setLog([]);
    addLog(`Starting. File: ${file.name} (${(file.size / 1024 / 1024).toFixed(1)} MB)`);

    try {
      setStatus("Uploading video...");
      const formData = new FormData();
      formData.append("name", name || file.name);
      formData.append("video", file);

      const { id } = await new Promise<{ id: string }>((resolve, reject) => {
        const xhr = new XMLHttpRequest();
        let lastLoggedPercent = -1;

        xhr.upload.addEventListener("progress", (e) => {
          if (!e.lengthComputable) return;
          const percentage = (e.loaded / e.total) * 100;
          setUploadPercent(percentage);
          const rounded = Math.floor(percentage / 10) * 10;
          if (rounded !== lastLoggedPercent) {
            lastLoggedPercent = rounded;
            addLog(`Upload progress: ${percentage.toFixed(0)}%`);
          }
        });

        xhr.addEventListener("load", () => {
          if (xhr.status >= 200 && xhr.status < 300) {
            try {
              resolve(JSON.parse(xhr.responseText));
            } catch {
              reject(new Error("Worker returned an invalid response."));
            }
          } else {
            try {
              reject(new Error(JSON.parse(xhr.responseText).error || `Upload failed (${xhr.status})`));
            } catch {
              reject(new Error(`Upload failed (${xhr.status})`));
            }
          }
        });

        xhr.addEventListener("error", () => reject(new Error("Network error while uploading to the worker.")));
        xhr.addEventListener("abort", () => reject(new Error("Upload was aborted.")));

        xhr.open("POST", `${WORKER_URL.replace(/\/$/, "")}/upload`);
        xhr.send(formData);
      });

      addLog(`Project created: ${id}. Redirecting...`);
      router.push(`/project/${id}`);
    } catch (err) {
      console.error("Upload failed:", err);
      const message =
        err instanceof Error && err.message ? err.message : "Upload failed. Check the browser console for details.";
      addLog(`ERROR: ${message}`);
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

          {log.length > 0 && (
            <pre className="text-xs text-neutral-500 bg-neutral-100 dark:bg-neutral-900 rounded-md p-3 max-h-48 overflow-y-auto whitespace-pre-wrap">
              {log.join("\n")}
            </pre>
          )}
        </form>
      </div>
    </main>
  );
}
