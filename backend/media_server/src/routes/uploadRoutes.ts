import { Router } from "express";
import express from "express";
import { uploadVideo, getVideoMetadata, getAllVideos } from "../controllers/videoController";
import storageConfig from "../config/storage.config";

const router = Router();

// POST /api/upload - Pujar un vídeo
router.post("/upload", uploadVideo);

// GET /api/videos - Obtener todos los vídeos
router.get("/videos", getAllVideos);

// GET /api/videos/:id - Obtener metadatos de un vídeo
router.get("/videos/:id", getVideoMetadata);

// Servir archivos HLS
router.use("/hls", express.static(storageConfig.publicHlsDir));

export default router;
