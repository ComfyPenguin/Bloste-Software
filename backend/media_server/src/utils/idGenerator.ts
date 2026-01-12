import { randomBytes } from "crypto";

// Genera un ID único para un vídeo
export function generateVideoId(): string {
  return `video_${randomBytes(6).toString("hex")}`;
}
