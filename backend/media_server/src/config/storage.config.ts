import env from "./env.config.js";

export interface StorageConfig {
  uploadDir: string;
  metadataDir: string;
  hlsDir: string;
  thumbnailDir: string;
}

const storageConfig: StorageConfig = {
  uploadDir: env.UPLOAD_DIR,
  metadataDir: env.METADATA_DIR,
  hlsDir: env.HLS_DIR,
  thumbnailDir: env.THUMBNAIL_DIR,
};

export default storageConfig;
