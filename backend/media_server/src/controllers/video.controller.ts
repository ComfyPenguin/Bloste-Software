import type { Request, Response } from "express";
import { videoProcessingService } from "../services/videoProcessing.service";
import { metadataService } from "../services/metadata.service";
import { ValidationError, NotFoundError } from "../types/errors.type";
import { asyncHandler } from "../middlewares/error.middleware";

// Subir un vídeo
export const uploadVideo = asyncHandler(async (req: Request, res: Response): Promise<void> => {
  if (!req.file) {
    throw new ValidationError("No file uploaded");
  }

  // Leer clientId de la cabecera (case-insensitive)
  const clientId = req.headers["clientid"] || req.headers["client-id"];
  if (!clientId || typeof clientId !== "string") {
    throw new ValidationError("Missing clientId in headers");
  }

  const result = await videoProcessingService.uploadAndProcessVideo(req.file, clientId);

  res.status(201).json({
    success: true,
    data: {
      id: result.id,
      originalFilename: result.originalFilename,
      size: result.size,
      message: "Video uploaded. Processing in progress...",
    },
  });
});

// Obtener metadatos de un vídeo por ID
export const getVideoMetadata = asyncHandler(async (req: Request, res: Response): Promise<void> => {
  const { id } = req.params;

  const metadata = await metadataService.getMetadata(id);

  if (!metadata) {
    throw new NotFoundError(`Video with id '${id}' not found`);
  }

  res.json({
    success: true,
    data: metadata,
  });
});

// Obtener todos los vídeos
export const getAllVideos = asyncHandler(async (req: Request, res: Response): Promise<void> => {
  const videos = await metadataService.getAllMetadata();

  res.json({
    success: true,
    data: videos,
    total: videos.length,
  });
});
