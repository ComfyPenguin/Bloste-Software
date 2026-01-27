// Genera un ID único para un video
export function generateVideoId(): string {
  return `video_${crypto.randomUUID().replace(/-/g, "_")}`;
}
