import { execFile } from "child_process";
import { promisify } from "util";
import ffmpegConfig from "../config/ffmpeg.config";
import type { VideoMetadata, FFprobeStream } from "../types";

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
        (info.streams as FFprobeStream[]).find((s: FFprobeStream) => s.codec_type === "video") ||
        info.streams[0];

      return {
        duration: Math.floor(Number(info.format.duration)), // en segundos
        fps: videoStream.r_frame_rate
          ? eval(videoStream.r_frame_rate) // Convierte "30/1" a 30
          : 0,
        codec: videoStream.codec_name,
      };
    } catch (error) {
      console.error("FFprobe error:", error);
      throw new Error("Failed to get video information");
    }
  }
}

export const ffprobeService = new FFprobeService();
