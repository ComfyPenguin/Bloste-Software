// Metadatos de un vídeo
export interface VideoMetadata {
  id: string;
  filesize: number;
  duration: number;
  codec: string;
  fps: number;
  hlsPath?: string;
  thumbnailPath?: string;
  status?: "uploaded" | "processing" | "completed" | "failed";
  error?: string;
}

// Respuesta al subir un vídeo
export interface UploadResponse {
  id: string;
  originalFilename: string;
  size: number;
}

// Tipado para los datos devueltos por FFprobe
export type FFprobeData = {
  codec_type: string;
  r_frame_rate?: string;
  codec_name?: string;
};
