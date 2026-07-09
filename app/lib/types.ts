export type Fragment = {
  start: number; // seconds
  end: number; // seconds
  text: string; // spoken text in this fragment
};

export type ClipStatus = "pending" | "approved" | "rejected";

export type Clip = {
  id: string;
  projectId: string;
  topic: string;
  hookReason: string;
  fragments: Fragment[];
  status: ClipStatus;
  rejectReason: string | null;
  resultUrl: string | null;
  cutError: string | null;
  createdAt: string;
};

export type Project = {
  id: string;
  name: string;
  videoUrl: string;
  videoDuration: number | null;
  transcript: string | null;
  segments: Fragment[] | null;
  status: "uploaded" | "transcribing" | "analyzing" | "ready" | "error";
  errorMessage: string | null;
  createdAt: string;
};

export type ProjectWithClips = Project & { clips: Clip[] };
