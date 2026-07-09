export function formatTimecode(totalSeconds: number): string {
  const s = Math.max(0, totalSeconds);
  const h = Math.floor(s / 3600);
  const m = Math.floor((s - h * 3600) / 60);
  const sec = s - h * 3600 - m * 60;
  return `${String(h).padStart(2, "0")}:${String(m).padStart(2, "0")}:${sec
    .toFixed(3)
    .padStart(6, "0")}`;
}

export function formatShort(totalSeconds: number): string {
  const s = Math.max(0, Math.round(totalSeconds));
  const m = Math.floor(s / 60);
  const sec = s % 60;
  return `${String(m).padStart(2, "0")}:${String(sec).padStart(2, "0")}`;
}
