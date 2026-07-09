"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import Link from "next/link";
import type { ProjectWithClips } from "@/lib/types";
import ClipCard from "@/components/ClipCard";

export default function ProjectView({ projectId }: { projectId: string }) {
  const [project, setProject] = useState<ProjectWithClips | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [regenerating, setRegenerating] = useState(false);
  const kickedOff = useRef(false);

  const load = useCallback(async () => {
    const res = await fetch(`/api/projects/${projectId}`, { cache: "no-store" });
    if (!res.ok) {
      setError("Project not found.");
      return;
    }
    const data = await res.json();
    setProject(data);
    return data as ProjectWithClips;
  }, [projectId]);

  const analyze = useCallback(async () => {
    const res = await fetch("/api/analyze", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ projectId }),
    });
    if (!res.ok) {
      const body = await res.json().catch(() => ({}));
      setError(body.error || "Analysis failed.");
    }
    await load();
  }, [projectId, load]);

  useEffect(() => {
    if (kickedOff.current) return;
    kickedOff.current = true;
    (async () => {
      const data = await load();
      if (data && data.status === "uploaded") {
        await analyze();
      }
    })();
  }, [load, analyze]);

  // Poll while the worker is doing anything: transcribing/analyzing the project,
  // or cutting an approved clip that has no result/error yet.
  useEffect(() => {
    if (!project) return;
    const projectBusy =
      project.status === "transcribing" || project.status === "analyzing";
    const cutInFlight = project.clips.some(
      (c) => c.status === "approved" && !c.resultUrl && !c.cutError
    );
    if (!projectBusy && !cutInFlight) return;
    const t = setInterval(load, 3000);
    return () => clearInterval(t);
  }, [project, load]);

  async function handleDecision(clipId: string, decision: "approved" | "rejected", reason?: string) {
    await fetch(`/api/clips/${clipId}/decision`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ decision, reason }),
    });
    await load();
  }

  async function handleCut(clipId: string) {
    await fetch("/api/cut", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ clipId }),
    });
    await load();
  }

  async function handleRegenerate() {
    setRegenerating(true);
    await analyze();
    setRegenerating(false);
  }

  if (error) {
    return (
      <main className="flex-1 flex items-center justify-center p-6">
        <p className="text-sm text-red-500">{error}</p>
      </main>
    );
  }

  if (!project) {
    return (
      <main className="flex-1 flex items-center justify-center p-6">
        <p className="text-sm text-neutral-500">Loading...</p>
      </main>
    );
  }

  const pending = project.clips.filter((c) => c.status === "pending");
  const decided = project.clips.filter((c) => c.status !== "pending");

  return (
    <main className="flex-1 max-w-2xl mx-auto w-full px-6 py-10">
      <Link href="/" className="text-xs text-neutral-500 hover:underline">
        &larr; New project
      </Link>
      <h1 className="text-xl font-semibold mt-2 mb-1">{project.name}</h1>

      {(project.status === "transcribing" || project.status === "analyzing") && (
        <p className="text-sm text-neutral-500 mb-6">
          {project.status === "transcribing" ? "Transcribing video..." : "Finding viral moments..."}
        </p>
      )}

      {project.status === "error" && (
        <div className="mb-6 rounded-md border border-red-300 dark:border-red-800 p-3">
          <p className="text-sm text-red-500">{project.errorMessage}</p>
          <button
            onClick={() => analyze()}
            className="mt-2 text-xs underline text-neutral-600 dark:text-neutral-400"
          >
            Retry
          </button>
        </div>
      )}

      {project.status === "ready" && pending.length === 0 && decided.length === 0 && (
        <p className="text-sm text-neutral-500 mb-6">No clip candidates found.</p>
      )}

      <div className="space-y-4">
        {pending.map((clip) => (
          <ClipCard key={clip.id} clip={clip} onDecision={handleDecision} onCut={handleCut} />
        ))}
      </div>

      {project.status === "ready" && (
        <button
          onClick={handleRegenerate}
          disabled={regenerating}
          className="mt-6 w-full rounded-md border border-neutral-300 dark:border-neutral-700 px-4 py-2 text-sm font-medium disabled:opacity-50"
        >
          {regenerating ? "Finding more..." : "Find more clips"}
        </button>
      )}

      {decided.length > 0 && (
        <div className="mt-10">
          <h2 className="text-sm font-medium text-neutral-500 mb-3">Reviewed</h2>
          <div className="space-y-3">
            {decided.map((clip) => (
              <ClipCard key={clip.id} clip={clip} onDecision={handleDecision} onCut={handleCut} />
            ))}
          </div>
        </div>
      )}
    </main>
  );
}
