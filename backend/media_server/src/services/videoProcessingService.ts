import * as fs from "fs-extra";
import * as path from "path";
import env from "../config/env.config";
import { generateVideoId } from "../utils/idGenerator";
import { ffprobeService } from "./ffprobeService";
import { hlsProcessingService } from "./hlsProcessingService";
import { metadataService } from "./metadataService";
import { thumbnailService } from "./thumbnailService";
import { cleanupService } from "./cleanupService";
import type { VideoMetadata, UploadResponse } from "../types";

// Servicio para gestionar la subida y procesamiento de vídeos
export class VideoProcessingService {
  private uploadDir = env.UPLOAD_DIR;

  // Inicializar directorios necesarios
  async init(): Promise<void> {
    await fs.ensureDir(this.uploadDir);
    await metadataService.init();
  }

  // Subir y procesar vídeo
  async uploadAndProcessVideo(file: Express.Multer.File): Promise<UploadResponse> {
    const videoId = generateVideoId();
    const fileExtension = path.extname(file.originalname);
    const filename = `${videoId}${fileExtension}`;
    const filepath = path.join(this.uploadDir, filename);

    // Mover el archivo desde la ubicación temporal
    await fs.move(file.path, filepath);
    const stats = await fs.stat(filepath);

    // Obtener información del vídeo
    const videoInfo = await ffprobeService.getVideoInfo(filepath);

    // Crear metadatos iniciales
    const metadata: VideoMetadata = {
      id: videoId,
      filesize: stats.size,
      duration: videoInfo.duration || 0,
      codec: videoInfo.codec || "unknown",
      fps: videoInfo.fps || 0,
      uploadedAt: new Date(),
      status: "uploaded",
    };

    // Guardar metadatos iniciales
    await metadataService.saveMetadata(metadata);

    // Iniciar procesamiento asíncrono
    this.processVideo(videoId, filepath);

    return {
      id: videoId,
      originalFilename: file.originalname,
      size: stats.size,
      uploadedAt: new Date(),
    };
  }

  // Procesar vídeo
  private async processVideo(videoId: string, inputPath: string): Promise<void> {
    try {
      // Actualizar estado a procesando
      await metadataService.updateMetadata(videoId, {
        uploadedAt: new Date(),
        status: "processing",
      });

      // Procesar a HLS
      await hlsProcessingService.processVideo(videoId, inputPath);

      // Generar thumbnail
      await thumbnailService.generateThumbnail(videoId, inputPath);

      // Borrar el video original después del procesamiento
      await cleanupService.deleteOriginalVideo(inputPath);

      // Rutas a los endpints
      const thumbnailPath = "thumbnails/" + `${videoId}.png`;
      const hlsPath = "hls/" + videoId;

      // Actualizar metadatos con resultado
      await metadataService.updateMetadata(videoId, {
        completedAt: new Date(),
        hlsPath: hlsPath,
        thumbnailPath: thumbnailPath,
        status: "completed",
      });

      console.log(`Video ${videoId} processed successfully`);
    } catch (error) {
      console.error(`Error processing video ${videoId}:`, error);

      // Guardar error en metadatos
      await metadataService.updateMetadata(videoId, {
        status: "failed",
        error: error instanceof Error ? error.message : "Unknown error",
      });
    }
  }
}

export const videoProcessingService = new VideoProcessingService();
