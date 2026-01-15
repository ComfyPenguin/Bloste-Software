import { execFile } from "child_process";
import { promisify } from "util";
import * as path from "path";
import * as fs from "fs-extra";
import ffmpegConfig from "../config/ffmpeg.config";
import storageConfig from "../config/storage.config";

const execFileAsync = promisify(execFile);

// Servicio para procesar vídeos a formato HLS
export class HLSProcessingService {
  // Procesar vídeo a HLS
  async processVideo(videoId: string, inputPath: string): Promise<string> {
    // Inicializar directorios necesarios
    const hlsDir = path.join(storageConfig.publicHlsDir, videoId);
    await fs.ensureDir(hlsDir);

    const playlistPath = path.join(hlsDir, "master.m3u8");
    const variants = ffmpegConfig.defaultResolutions;

    // Procesar el video en cada una de las resoluciones definidas
    try {
      for (const variant of variants) {
        const variantDir = path.join(hlsDir, `${variant.height}`);
        await fs.ensureDir(variantDir);

        const variantPlaylist = path.join(variantDir, "playlist.m3u8");
        const segmentPattern = path.join(variantDir, "segment_%03d.ts");

        await execFileAsync(ffmpegConfig.ffmpegPath, [
          "-i",
          inputPath,
          "-vf",
          `scale=${variant.width}:${variant.height}`,
          "-b:v",
          variant.bitrate,
          "-c:a",
          "aac",
          "-b:a",
          "128k",
          "-f",
          "hls",
          "-hls_time",
          String(ffmpegConfig.segmentTime),
          "-hls_list_size",
          "0",
          "-hls_segment_filename",
          segmentPattern,
          variantPlaylist,
        ]);
      }

      // Crear playlist maestro
      await this.createMasterPlaylist(playlistPath, variants);

      return hlsDir;
    } catch (error) {
      console.error("HLS Processing error:", error);
      throw new Error("Failed to process video to HLS");
    }
  }

  // Crea un master con todas las resoluciones
  private async createMasterPlaylist(
    playlistPath: string,
    variants: Array<{ width: number; height: number; bitrate: string }>
  ): Promise<void> {
    let masterContent = "#EXTM3U\n#EXT-X-VERSION:3\n\n";

    for (const variant of variants) {
      const bandwidth = parseInt(variant.bitrate) * 1000;
      const resolution = `${variant.width}x${variant.height}`;

      masterContent += `#EXT-X-STREAM-INF:BANDWIDTH=${bandwidth},RESOLUTION=${resolution}\n`;
      masterContent += `${variant.width}x${variant.height}/playlist.m3u8\n\n`;
    }

    await fs.writeFile(playlistPath, masterContent);
  }
}

export const hlsProcessingService = new HLSProcessingService();
