// Metadatos de un vídeo
export interface VideoMetadata {
  id: string;
  filename: string;
  originalFilename: string;
  filesize: number;
  duration: number;
  width: number;
  height: number;
  codec: string;
  fps: number;
  uploadedAt: Date;
  processingStartedAt?: Date;
  processingCompletedAt?: Date;
  status: "uploaded" | "processing" | "completed" | "failed";
  hlsPath?: string;
  error?: string;
}

// Respuesta al subir un vídeo
export interface UploadResponse {
  id: string;
  filename: string;
  size: number;
  path: string;
  uploadedAt: Date;
}
