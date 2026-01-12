import env from "./env.config.js";

export interface StorageConfig {
  uploadDir: string; // Carpeta donde se guardan los vídeos subidos
  processingDir: string; // Carpeta temporal para FFmpeg
  publicHlsDir: string; // Carpeta pública para HLS
  hlsBaseUrl: string; // URL base para acceder a HLS
}

const storageConfig: StorageConfig = {
  uploadDir: env.UPLOAD_DIR,
  processingDir: env.PROCESSING_DIR,
  publicHlsDir: env.PUBLIC_HLS_DIR,
  hlsBaseUrl: env.HLS_BASE_URL,
};

export default storageConfig;
