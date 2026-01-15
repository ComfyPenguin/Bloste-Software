import env from "./env.config.js";

export interface StorageConfig {
  uploadDir: string;
  metadataDir: string;
  publicHlsDir: string;
}

const storageConfig: StorageConfig = {
  uploadDir: env.UPLOAD_DIR,
  metadataDir: env.METADATA_DIR,
  publicHlsDir: env.PUBLIC_HLS_DIR,
};

export default storageConfig;
