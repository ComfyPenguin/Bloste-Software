import * as fs from "fs-extra";
import * as path from "path";
import type { UploadedFile } from "express-fileupload";
import env from "../config/env.config";
import { generateVideoId } from "../utils/idGenerator";
import type { UploadResponse } from "../types";

export class UploadService {
  private uploadDir = env.UPLOAD_DIR;

  async init(): Promise<void> {
    await fs.ensureDir(this.uploadDir);
  }

  // Guardar el archivo subido y devuelve los metadatos
  async saveFile(file: UploadedFile): Promise<UploadResponse> {
    const videoId = generateVideoId();
    const fileExtension = path.extname(file.name);
    const filename = `${videoId}${fileExtension}`;
    const filepath = path.join(this.uploadDir, filename);

    // Guardar el archivo
    await file.mv(filepath);

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
