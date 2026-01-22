import express, { Router } from "express";
import { multerUpload as multerMiddleware } from "../middlewares/multer.middleware";
import { uploadVideo, getVideoMetadata, getAllVideos } from "../controllers/video.controller";
import storageConfig from "../configs/storage.config";

const router = Router();

// POST /api/upload - Subir un vídeo
router.post("/upload", multerMiddleware.single("video"), uploadVideo);

// GET /api/videos - Obtener todos los vídeos
router.get("/videos", getAllVideos);

// GET /api/videos/:id - Obtener metadatos de un vídeo
router.get("/videos/:id", getVideoMetadata);

// Servir archivos HLS (segmentos y playlists de resolución)
router.use("/hls", express.static(storageConfig.hlsDir));

// Servir miniaturas de vídeos
router.use("/thumbnails", express.static(storageConfig.thumbnailDir));

export default router;
