import * as fs from "fs-extra";
import * as path from "path";
import env from "../config/env.config";
import { generateVideoId } from "../utils/idGenerator";
import type { UploadResponse } from "../types";

// Servicio encargado de gestionar la subida de archivos al servidor.
export class UploadService {
  private uploadDir = env.UPLOAD_DIR;

  // Inicializar directorios necesarios
  async init(): Promise<void> {
    await fs.ensureDir(this.uploadDir);
  }

  // Guardar el archivo subido y devuelve los metadatos
  async saveFile(file: Express.Multer.File): Promise<UploadResponse> {
    const videoId = generateVideoId();
    const fileExtension = path.extname(file.originalname);
    const filename = `${videoId}${fileExtension}`;
    const filepath = path.join(this.uploadDir, filename);

    // Mover el archivo desde la ubicación temporal
    await fs.move(file.path, filepath);

    // Obtener estadísticas del archivo
    const stats = await fs.stat(filepath);

    return {
      id: videoId,
      filename: filename,
      size: stats.size,
      path: filepath,
      uploadedAt: new Date(),
    };
  }
}

export const uploadService = new UploadService();
