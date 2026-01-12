import * as fs from "fs-extra";
import type { UploadedFile } from "express-fileupload";
import env from "../config/env.config";
import { generateVideoId } from "../utils/idGenerator";
import { ffprobeService } from "./ffprobeService";
import { hlsProcessingService } from "./hlsProcessingService";
import { metadataService } from "./metadataService";
import type { VideoMetadata, UploadResponse } from "../types";

export class VideoProcessingService {
  private uploadDir = env.UPLOAD_DIR;

  // Inicializar directorios necesarios
  async init(): Promise<void> {
    await fs.ensureDir(this.uploadDir);
    await metadataService.init();
  }

  // Subir y procesar vídeo
  async uploadAndProcessVideo(file: UploadedFile): Promise<UploadResponse> {
    const videoId = generateVideoId();
    const fileExtension = require("path").extname(file.name);
    const filename = `${videoId}${fileExtension}`;
    const filepath = require("path").join(this.uploadDir, filename);

    // Guardar el archivo
    await file.mv(filepath);
    const stats = await fs.stat(filepath);

    // Obtener información del vídeo
    const videoInfo = await ffprobeService.getVideoInfo(filepath);

    // Crear metadatos iniciales
    const metadata: VideoMetadata = {
      id: videoId,
      filename: filename,
      originalFilename: file.name,
      filesize: stats.size,
      duration: videoInfo.duration || 0,
      width: videoInfo.width || 0,
      height: videoInfo.height || 0,
      codec: videoInfo.codec || "unknown",
      fps: videoInfo.fps || 0,
      uploadedAt: new Date(),
      status: "uploaded",
    };

    // Guardar metadatos iniciales
    await metadataService.saveMetadata(metadata);

    // Iniciar procesamiento
    this.processVideoAsync(videoId, filepath).catch((error) => {
      console.error("Error processing video:", error);
    });

    return {
      id: videoId,
      filename: filename,
      size: stats.size,
      path: filepath,
      uploadedAt: new Date(),
    };
  }

  // Procesar vídeo de forma asincrónica
  private async processVideoAsync(videoId: string, inputPath: string): Promise<void> {
    try {
      // Actualizar estado a procesando
      await metadataService.updateMetadata(videoId, {
        status: "processing",
        processingStartedAt: new Date(),
      });

      // Procesar a HLS
      const hlsPath = await hlsProcessingService.processVideo(videoId, inputPath);

      // Actualizar metadatos con resultado
      await metadataService.updateMetadata(videoId, {
        status: "completed",
        hlsPath: hlsPath,
        processingCompletedAt: new Date(),
      });

      console.log(`Video ${videoId} procesado exitosamente`);
    } catch (error) {
      console.error(`Error procesando video ${videoId}:`, error);

      // Guardar error en metadatos
      await metadataService.updateMetadata(videoId, {
        status: "failed",
        error: error instanceof Error ? error.message : "Unknown error",
      });
    }
  }
}

export const videoProcessingService = new VideoProcessingService();
