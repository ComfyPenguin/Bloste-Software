import * as fs from "fs-extra";
import * as path from "path";
import storageConfig from "../config/storage.config";
import type { VideoMetadata } from "../types/metadata";

export class MetadataService {
  private metadataDir: string;

  constructor() {
    this.metadataDir = path.join(storageConfig.processingDir, "metadata");
  }

  async init(): Promise<void> {
    await fs.ensureDir(this.metadataDir);
  }

  // Guardar metadatos de vídeo
  async saveMetadata(metadata: VideoMetadata): Promise<void> {
    const filePath = path.join(this.metadataDir, `${metadata.id}.json`);
    await fs.writeJson(filePath, metadata, { spaces: 2 });
  }

  // Obtener metadatos de vídeo por ID
  async getMetadata(videoId: string): Promise<VideoMetadata | null> {
    const filePath = path.join(this.metadataDir, `${videoId}.json`);

    try {
      if (await fs.pathExists(filePath)) {
        return await fs.readJson(filePath);
      }
      return null;
    } catch (error) {
      console.error("Error reading metadata:", error);
      return null;
    }
  }

  // Actualizar metadatos de vídeo
  async updateMetadata(videoId: string, updates: Partial<VideoMetadata>): Promise<void> {
    const filePath = path.join(this.metadataDir, `${videoId}.json`);

    try {
      const current = (await fs.readJson(filePath)) as VideoMetadata;
      const updated: VideoMetadata = Object.assign({}, current, updates);
      await fs.writeJson(filePath, updated, { spaces: 2 });
    } catch (error) {
      console.error("Error updating metadata:", error);
      throw error;
    }
  }

  // Eliminar metadatos de vídeo
  async deleteMetadata(videoId: string): Promise<void> {
    const filePath = path.join(this.metadataDir, `${videoId}.json`);
    await fs.remove(filePath);
  }

  // Obtener todos los metadatos de vídeo
  async getAllMetadata(): Promise<VideoMetadata[]> {
    const files = await fs.readdir(this.metadataDir);
    const metadata: VideoMetadata[] = [];

    for (const file of files) {
      if (file.endsWith(".json")) {
        const data = await fs.readJson(path.join(this.metadataDir, file));
        metadata.push(data);
      }
    }

    return metadata;
  }
}

export const metadataService = new MetadataService();
