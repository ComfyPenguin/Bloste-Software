import type { Request, Response } from "express";
import { uploadService } from "../services/uploadService";

// Subir un vídeo
export async function uploadVideo(req: Request, res: Response): Promise<void> {
  try {
    // Verificar que se ha subido un archivo
    if (!req.files || !req.files.video) {
      res.status(400).json({ error: "No file uploaded" });
      return;
    }

    // Obtener el archivo subido
    const file = Array.isArray(req.files.video) ? req.files.video[0] : req.files.video;

    const result = await uploadService.saveFile(file);

    res.status(201).json({
      success: true,
      data: {
        id: result.id,
        filename: result.filename,
        size: result.size,
        uploadedAt: result.uploadedAt,
      },
    });
  } catch (error) {
    console.error("Upload error:", error);
    res.status(500).json({ error: "Failed to upload file" });
  }
}
