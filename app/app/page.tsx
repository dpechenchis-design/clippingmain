"use client";

import { useRouter } from "next/navigation";
import { useRef, useState } from "react";
import { upload } from "@vercel/blob/client";

function withTimeout<T>(promise: Promise<T>, ms: number, label: string): Promise<T> {
  return new Promise((resolve, reject) => {
    const timer = setTimeout(() => {
      reject(new Error(`${label} timed out after ${Math.round(ms / 1000)}s. This usually means a browser extension, VPN, or network is blocking the upload request. Try disabling extensions or using a different network/browser.`));
    }, ms);
    promise.then(
      (value) => {
        clearTimeout(timer);
        resolve(value);
      },
      (err) => {
        clearTimeout(timer);
        reject(err);
      }
    );
  });
}

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
    setError(null);
    setBusy(true);
    setUploadPercent(0);
    setLog([]);
    addLog(`Starting. File: ${file.name} (${(file.size / 1024 / 1024).toFixed(1)} MB)`);

    try {
      setStatus("Uploading video...");
      addLog("Calling upload()...");
      let lastLoggedPercent = -1;
      const blob = await withTimeout(
        upload(file.name, file, {
          access: "public",
          handleUploadUrl: "/api/upload",
          onUploadProgress: ({ percentage }) => {
            setUploadPercent(percentage);
            const rounded = Math.floor(percentage / 10) * 10;
            if (rounded !== lastLoggedPercent) {
              lastLoggedPercent = rounded;
              addLog(`Upload progress: ${percentage.toFixed(0)}%`);
            }
          },
        }),
        90_000,
        "Upload"
      );
      addLog(`Upload finished. Blob URL: ${blob.url}`);

      setUploadPercent(null);
      setStatus("Creating project...");
      addLog("Creating project record...");
      const projectRes = await withTimeout(
        fetch("/api/projects", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ name: name || file.name, videoUrl: blob.url }),
        }),
        20_000,
        "Create project"
      );
      if (!projectRes.ok) throw new Error((await projectRes.json()).error || "Failed to create project");
      const { id } = await projectRes.json();
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
