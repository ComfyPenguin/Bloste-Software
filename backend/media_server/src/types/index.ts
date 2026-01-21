// Define un "type" para el objeto de "stream" devuelto por FFprobe
export type FFprobeStream = {
  codec_type: string;
  r_frame_rate?: string;
  codec_name?: string;
};

export * from "./metadata";
