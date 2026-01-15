import type { Request, Response } from "express";
import { videoProcessingService } from "../services/videoProcessingService";
import { metadataService } from "../services/metadataService";

// Subir un vídeo
export async function uploadVideo(req: Request, res: Response): Promise<void> {
  try {
    if (!req.file) {
      res.status(400).json({ error: "No file uploaded" });
      return;
    }

    const result = await videoProcessingService.uploadAndProcessVideo(req.file);

    res.status(201).json({
      success: true,
      data: {
        id: result.id,
        originalFilename: result.originalFilename,
        size: result.size,
        uploadedAt: result.uploadedAt,
        message: "Video uploaded. Processing in progress...",
      },
    });
  } catch (error) {
    console.error("Upload error:", error);
    res.status(500).json({ error: "Failed to upload file" });
  }
}

// Obtener metadatos de un vídeo por ID
export async function getVideoMetadata(req: Request, res: Response): Promise<void> {
  try {
    const { id } = req.params;

    const metadata = await metadataService.getMetadata(id);

    if (!metadata) {
      res.status(404).json({ error: "Video not found" });
      return;
    }

    res.json({
      success: true,
      data: metadata,
    });
  } catch (error) {
    console.error("Error getting metadata:", error);
    res.status(500).json({ error: "Failed to get video metadata" });
  }
}

// Obtener todos los vídeos
export async function getAllVideos(req: Request, res: Response): Promise<void> {
  try {
    const videos = await metadataService.getAllMetadata();

    res.json({
      success: true,
      data: videos,
      total: videos.length,
    });
  } catch (error) {
    console.error("Error getting videos:", error);
    res.status(500).json({ error: "Failed to get videos" });
  }
}
