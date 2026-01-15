// Metadatos de un vídeo
export interface VideoMetadata {
  id: string;
  filesize: number;
  duration: number;
  codec: string;
  fps: number;
  hlsPath?: string;
  thumbnailPath?: string;
  uploadedAt?: Date;
  completedAt?: Date;
  status: "uploaded" | "processing" | "completed" | "failed";
  error?: string;
}

// Respuesta al subir un vídeo
export interface UploadResponse {
  id: string;
  originalFilename: string;
  size: number;
  uploadedAt: Date;
}
