import env from "./env.config.js";

export interface FFmpegConfig {
  ffmpegPath: string;
  ffprobePath: string;
  defaultResolutions: { width: number; height: number; bitrate: string }[];
  segmentTime: number;
}

const ffmpegConfig: FFmpegConfig = {
  ffmpegPath: env.FFMPEG_PATH,
  ffprobePath: env.FFPROBE_PATH,
  defaultResolutions: [
    { width: 640, height: 480, bitrate: "1000k" },
    { width: 1280, height: 720, bitrate: "2000k" },
    { width: 1920, height: 1080, bitrate: "4000k" },
  ],
  segmentTime: 30, // segundos
};

export default ffmpegConfig;
