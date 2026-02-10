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
      // Leer el contenido del archivo JSON
      const metadata = await fs.readJson(filePath);

      // Verificar que el status sea "uploaded"
      if (metadata.status === "uploaded") {
        await fs.remove(filePath);
        console.log(`Metadata file deleted: ${filePath}`);
      } else {
        console.log(
          `Metadata file not deleted - status is not "uploaded": ${filePath} (current status: ${metadata.status})`
        );
      }
    } catch (error) {
      console.error(`Error deleting metadata file ${filePath}:`, error);
    }
  }

  // Limpiar todos los archivos temporales
  async deleteAllFilesInFolder(folderPath: string): Promise<void> {
    try {
      const files = await fs.readdir(folderPath);
      for (const file of files) {
        const filePath = `${folderPath}/${file}`;
        await fs.remove(filePath);
      }
      console.log(`All files in folder deleted: ${folderPath}`);
    } catch (error) {
      console.error(`Error deleting files in folder ${folderPath}:`, error);
    }
  }
}

export const cleanupService = new CleanupService();
