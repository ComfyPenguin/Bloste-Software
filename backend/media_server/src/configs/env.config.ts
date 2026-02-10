import * as dotenv from "dotenv";
import * as path from "path";
// @ts-ignore
import ffmpegInstaller from "@ffmpeg-installer/ffmpeg";
// @ts-ignore
import ffprobeInstaller from "@ffprobe-installer/ffprobe";

// Cargar variables desde .env
dotenv.config({ path: path.resolve(__dirname, "../../.env") });

interface EnvConfig {
  PORT: number;
  NODE_ENV: "development" | "production";
  UPLOAD_DIR: string;
  METADATA_DIR: string;
  HLS_DIR: string;
  THUMBNAIL_DIR: string;
  FFMPEG_PATH: string;
  FFPROBE_PATH: string;
}

const env: EnvConfig = {
  PORT: Number(process.env.PORT) || 4000,
  NODE_ENV: (process.env.NODE_ENV as "development" | "production") || "development",
  UPLOAD_DIR: process.env.UPLOAD_DIR || "./storage/uploads",
  METADATA_DIR: process.env.METADATA_DIR || "./storage/metadata",
  HLS_DIR: process.env.HLS_DIR || "./storage/public/videos",
  THUMBNAIL_DIR: process.env.THUMBNAIL_DIR || "./storage/public/thumbnails",
  FFMPEG_PATH: ffmpegInstaller.path,
  FFPROBE_PATH: ffprobeInstaller.path,
};

export default env;
