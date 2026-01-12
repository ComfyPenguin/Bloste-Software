import type { Request, Response } from "express";
import { videoProcessingService } from "../services/videoProcessingService";
import { metadataService } from "../services/metadataService";

// Subir un vídeo
export async function uploadVideo(req: Request, res: Response): Promise<void> {
  try {
    if (!req.files || !req.files.video) {
      res.status(400).json({ error: "No file uploaded" });
      return;
    }

    const file = Array.isArray(req.files.video) ? req.files.video[0] : req.files.video;

    const result = await videoProcessingService.uploadAndProcessVideo(file);

    res.status(201).json({
      success: true,
      data: {
        id: result.id,
        filename: result.filename,
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
