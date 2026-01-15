import * as dotenv from "dotenv";
import * as path from "path";
import ffmpegInstaller from "@ffmpeg-installer/ffmpeg";
import ffprobeInstaller from "@ffprobe-installer/ffprobe";

// Cargar variables desde .env
dotenv.config({ path: path.resolve(__dirname, "../../.env") });

interface EnvConfig {
  PORT: number;
  NODE_ENV: "development" | "production";
  UPLOAD_DIR: string;
  METADATA_DIR: string;
  PUBLIC_HLS_DIR: string;
  FFMPEG_PATH: string;
  FFPROBE_PATH: string;
}

const env: EnvConfig = {
  PORT: Number(process.env.PORT) || 4000,
  NODE_ENV: (process.env.NODE_ENV as "development" | "production") || "development",
  UPLOAD_DIR: process.env.UPLOAD_DIR || "./storage/uploads",
  METADATA_DIR: process.env.METADATA_DIR || "./storage/metadata",
  PUBLIC_HLS_DIR: process.env.PUBLIC_HLS_DIR || "./storage/public",
  FFMPEG_PATH: ffmpegInstaller.path,
  FFPROBE_PATH: ffprobeInstaller.path,
};

export default env;
