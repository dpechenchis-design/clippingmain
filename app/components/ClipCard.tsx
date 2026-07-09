"use client";

import { useState } from "react";
import type { Clip } from "@/lib/types";
import { formatShort } from "@/lib/timecode";

export default function ClipCard({
  clip,
  onDecision,
  onCut,
}: {
  clip: Clip;
  onDecision: (clipId: string, decision: "approved" | "rejected", reason?: string) => Promise<void>;
  onCut: (clipId: string) => Promise<void>;
}) {
  const [busy, setBusy] = useState(false);
  const [rejectReason, setRejectReason] = useState("");
  const [showRejectInput, setShowRejectInput] = useState(false);

  const duration = clip.fragments.reduce((sum, f) => sum + (f.end - f.start), 0);
  // Cutting is in-flight when approved but no result and no error yet.
  const cutting = clip.status === "approved" && !clip.resultUrl && !clip.cutError;

  async function handleApprove() {
    setBusy(true);
    await onDecision(clip.id, "approved");
    await onCut(clip.id);
    setBusy(false);
  }

  async function handleReject() {
    setBusy(true);
    await onDecision(clip.id, "rejected", rejectReason || undefined);
    setBusy(false);
  }

  if (clip.status === "rejected") {
    return (
      <div className="rounded-lg border border-neutral-200 dark:border-neutral-800 p-4 opacity-50">
        <p className="text-sm font-medium line-through">{clip.topic}</p>
        <p className="text-xs text-neutral-500">
          Rejected{clip.rejectReason ? `: ${clip.rejectReason}` : ""}
        </p>
      </div>
    );
  }

  return (
    <div className="rounded-lg border border-neutral-200 dark:border-neutral-800 p-4 space-y-3">
      <div className="flex items-start justify-between gap-3">
        <div>
          <h3 className="font-medium">{clip.topic}</h3>
          <p className="text-xs text-neutral-500 mt-0.5">{clip.hookReason}</p>
        </div>
        {clip.status === "approved" && (
          <span className="shrink-0 text-xs rounded-full bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200 px-2 py-0.5">
            approved
          </span>
        )}
      </div>

      <div className="text-xs text-neutral-500">
        ~{Math.round(duration)}s · {clip.fragments.length} fragment
        {clip.fragments.length > 1 ? "s" : ""}
      </div>

      <ul className="space-y-1">
        {clip.fragments.map((f, i) => (
          <li key={i} className="text-sm text-neutral-700 dark:text-neutral-300">
            <span className="text-xs text-neutral-400 font-mono mr-2">
              {formatShort(f.start)}–{formatShort(f.end)}
            </span>
            &ldquo;{f.text}&rdquo;
          </li>
        ))}
      </ul>

      {clip.status === "pending" && (
        <div className="space-y-2 pt-1">
          <div className="flex gap-2">
            <button
              onClick={handleApprove}
              disabled={busy}
              className="flex-1 rounded-md bg-neutral-900 dark:bg-white text-white dark:text-neutral-900 px-3 py-1.5 text-sm font-medium disabled:opacity-50"
            >
              Yes, cut it
            </button>
            <button
              onClick={() => setShowRejectInput((v) => !v)}
              disabled={busy}
              className="flex-1 rounded-md border border-neutral-300 dark:border-neutral-700 px-3 py-1.5 text-sm font-medium disabled:opacity-50"
            >
              No, skip
            </button>
          </div>
          {showRejectInput && (
            <div className="flex gap-2">
              <input
                type="text"
                value={rejectReason}
                onChange={(e) => setRejectReason(e.target.value)}
                placeholder="Why? (optional, helps future suggestions)"
                className="flex-1 rounded-md border border-neutral-300 dark:border-neutral-700 bg-transparent px-2 py-1 text-xs"
              />
              <button
                onClick={handleReject}
                disabled={busy}
                className="rounded-md bg-red-600 text-white px-3 py-1 text-xs font-medium disabled:opacity-50"
              >
                Confirm
              </button>
            </div>
          )}
        </div>
      )}

      {cutting && <p className="text-xs text-neutral-500">Cutting on the worker…</p>}

      {clip.cutError && (
        <div className="text-xs text-red-500">
          Cut failed: {clip.cutError}{" "}
          <button onClick={() => onCut(clip.id)} className="underline">
            retry
          </button>
        </div>
      )}

      {clip.resultUrl && (
        <a
          href={clip.resultUrl}
          download={`${clip.topic.replace(/[^a-zA-Z0-9]+/g, "_").slice(0, 60)}.mp4`}
          className="inline-block rounded-md bg-neutral-900 dark:bg-white text-white dark:text-neutral-900 px-3 py-1.5 text-sm font-medium"
        >
          Download clip
        </a>
      )}
    </div>
  );
}
