import { execFile } from "child_process";
import { promisify } from "util";
import ffmpegConfig from "../configs/ffmpeg.config";
import type { VideoMetadata, FFprobeData } from "../types/metadata.type";

const execFileAsync = promisify(execFile);

// Servicio para obtener información de vídeo
export class FFprobeService {
  async getVideoInfo(filePath: string): Promise<Partial<VideoMetadata>> {
    try {
      const { stdout } = await execFileAsync(ffmpegConfig.ffprobePath, [
        "-v",
        "error",
        "-show_entries",
        "format=duration:stream=width,height,r_frame_rate,codec_name",
        "-of",
        "json",
        filePath,
      ]);

      const info = JSON.parse(stdout);
      // Busca el primer video
      const videoStream =
        (info.streams as FFprobeData[]).find((s: FFprobeData) => s.codec_type === "video") ||
        info.streams[0];

      return {
        duration: adjustDuration(Number(info.format.duration)), // en segundos
        fps: adjustFps(videoStream.r_frame_rate),
        codec: videoStream.codec_name,
      };
    } catch (error) {
      console.error("FFprobe error:", error);
      throw new Error("Failed to get video information");
    }
  }
}

// Ajusta los FPS a un número con dos decimales
function adjustFps(fpsString: string | undefined): number | undefined {
  if (!fpsString) return undefined;
  const [numerator, denominator] = fpsString.split("/").map(Number);
  if (!numerator || !denominator || denominator === 0) return undefined;
  const fps = numerator / denominator;
  if (!isFinite(fps) || fps <= 0) return undefined;
  return Number(fps.toFixed(2));
}

// Ajusta la duración a un número entero de segundos
function adjustDuration(duration: number | undefined): number | undefined {
  if (duration === undefined) return undefined;
  return Math.floor(duration);
}

export const ffprobeService = new FFprobeService();
