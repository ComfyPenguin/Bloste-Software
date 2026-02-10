import { execFile } from "child_process";
import { promisify } from "util";
import * as path from "path";
import * as fs from "fs-extra";
import ffmpegConfig from "../configs/ffmpeg.config";
import storageConfig from "../configs/storage.config";

const execFileAsync = promisify(execFile);

// Servicio para generar thumbnails de vídeos
export class ThumbnailService {
  // Generar thumbnail para un vídeo
  async generateThumbnail(videoId: string, inputPath: string): Promise<string> {
    // Crear directorio para thumbnails
    const thumbnailDir = path.join(storageConfig.thumbnailDir);
    await fs.ensureDir(thumbnailDir);

    const thumbnailPath = path.join(thumbnailDir, `${videoId}.png`);

    try {
      // Extraer frame
      await execFileAsync(ffmpegConfig.ffmpegPath, [
        "-i",
        inputPath,
        "-ss",
        "00:00:00", // Tiempo del frame a extraer
        "-vframes",
        "1", // Solo un frame
        "-q:v",
        "2", // Calidad
        thumbnailPath,
      ]);

      return thumbnailPath;
    } catch (error) {
      console.error("Thumbnail generation error:", error);
      throw new Error("Failed to generate thumbnail");
    }
  }
}

export const thumbnailService = new ThumbnailService();
