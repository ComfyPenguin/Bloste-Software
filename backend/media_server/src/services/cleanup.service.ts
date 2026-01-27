import * as fs from "fs-extra";

// Limpiar archivos después del procesamiento
export class CleanupService {
  async deleteOriginalVideo(filePath: string): Promise<void> {
    try {
      await fs.remove(filePath);
      console.log(`Original video file deleted: ${filePath}`);
    } catch (error) {
      console.error(`Error deleting original video file ${filePath}:`, error);
    }
  }

  // Limpiar metadatos después del procesamiento
  async deleteMetadataFile(filePath: string): Promise<void> {
    try {
      await fs.remove(filePath);
      console.log(`Metadata file deleted: ${filePath}`);
    } catch (error) {
      console.error(`Error deleting metadata file ${filePath}:`, error);
    }
  }
}

export const cleanupService = new CleanupService();
