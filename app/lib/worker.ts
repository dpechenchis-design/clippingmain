export async function callWorker(path: string, body: unknown): Promise<void> {
  const base = process.env.WORKER_URL;
  const secret = process.env.WORKER_SECRET;
  if (!base || !secret) {
    throw new Error(
      "WORKER_URL / WORKER_SECRET are not set. Deploy the worker (see worker/README.md) and set both env vars in the Vercel app."
    );
  }
  const res = await fetch(`${base.replace(/\/$/, "")}${path}`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${secret}`,
    },
    body: JSON.stringify(body),
  });
  if (!res.ok && res.status !== 202) {
    const text = await res.text().catch(() => "");
    throw new Error(`Worker ${path} failed (${res.status}): ${text.slice(0, 300)}`);
  }
}
