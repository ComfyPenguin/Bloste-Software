import { execFile } from "child_process";
import { promisify } from "util";
import ffmpegConfig from "../config/ffmpeg.config";
import type { VideoMetadata } from "../types/metadata";

const execFileAsync = promisify(execFile);

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
      const videoStream =
        info.streams.find((s: any) => s.codec_type === "video") || info.streams[0];

      return {
        duration: Math.floor(Number(info.format.duration)),
        width: videoStream.width,
        height: videoStream.height,
        fps: Math.round(eval(videoStream.r_frame_rate)),
        codec: videoStream.codec_name,
      };
    } catch (error) {
      console.error("FFprobe error:", error);
      throw new Error("Failed to get video information");
    }
  }
}

export const ffprobeService = new FFprobeService();
