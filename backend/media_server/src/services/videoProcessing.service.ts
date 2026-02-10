import * as fs from "fs-extra";
import * as path from "path";
import env from "../configs/env.config";
import { generateVideoId } from "../utils/idGenerator";
import { ffprobeService } from "./ffprobe.service";
import { hlsService } from "./hls.service";
import { metadataService } from "./metadata.service";
import { thumbnailService } from "./thumbnail.service";
import { cleanupService } from "./cleanup.service";
import { websocketService } from "./webSocket.service";
import type { VideoMetadata, UploadResponse } from "../types/metadata.type";

// Servicio para gestionar la subida y procesamiento de vídeos
export class VideoProcessingService {
  private uploadDir = env.UPLOAD_DIR;
  private metadataDir = env.METADATA_DIR;

  // Inicializar directorios necesarios
  async init(): Promise<void> {
    await fs.ensureDir(this.uploadDir);
    await metadataService.init();
  }

  // Subir y procesar vídeo
  async uploadAndProcessVideo(
    file: Express.Multer.File,
    clientId: string
  ): Promise<UploadResponse> {
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
      status: "uploaded",
    };

    // Guardar metadatos iniciales
    await metadataService.saveMetadata(metadata);

    // Asociar videoId con clientId en el websocketService
    websocketService.associateVideoWithClient(videoId, clientId);

    // Iniciar procesamiento
    this.processVideo(videoId, filepath);

    return {
      id: videoId,
      originalFilename: file.originalname,
      size: stats.size,
    };
  }

  // Procesar vídeo
  private async processVideo(videoId: string, inputPath: string): Promise<void> {
    try {
      // Emitir evento de estado
      websocketService.emitStatusUpdate(videoId);

      // Procesar a HLS
      await hlsService.videoToHLS(videoId, inputPath);

      // Generar thumbnail
      await thumbnailService.generateThumbnail(videoId, inputPath);

      // Borrar el video original después del procesamiento
      await cleanupService.deleteOriginalVideo(inputPath);

      // Rutas a los endpints
      const thumbnailPath = "/api/thumbnails/" + `${videoId}.png`;
      const hlsPath = "/api/hls/" + videoId;

      // Actualizar metadatos con resultado
      await metadataService.updateMetadata(videoId, {
        hlsPath: hlsPath,
        thumbnailPath: thumbnailPath,
      });

      // Obtener metadatos completos y emitir evento
      const completeMetadata = await metadataService.getMetadata(videoId);
      if (completeMetadata) {
        websocketService.emitVideoProcessed(videoId, completeMetadata);
      }

      console.log(`Video ${videoId} processed successfully`);
      await cleanupService.deleteMetadataFile(`${this.metadataDir}/${videoId}.json`);
    } catch (error) {
      console.error(`Error processing video ${videoId}:`, error);

      // Obtener mensaje de error
      const errorMessage = error instanceof Error ? error.message : "Unknown error";

      // Guardar error en metadatos
      await metadataService.updateMetadata(videoId, {
        status: "failed",
        error: errorMessage,
      });

      // Emitir evento de fallo
      websocketService.emitVideoFailed(videoId, errorMessage);
    }
  }
}

export const videoProcessingService = new VideoProcessingService();
