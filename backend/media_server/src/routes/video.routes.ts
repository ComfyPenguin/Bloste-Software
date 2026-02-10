import express, { Router } from "express";
import { multerMiddleware } from "../middlewares/multer.middleware";
import { adminAuthentication, registeredAuthentication } from "../middlewares/auth.middleware";
import { uploadVideo, getVideoMetadata, getAllVideos } from "../controllers/video.controller";
import storageConfig from "../configs/storage.config";

const router = Router();

// POST /api/upload - Subir un vídeo
router.post("/upload", adminAuthentication, multerMiddleware.single("video"), uploadVideo);

// GET /api/videos - Obtener todos los vídeos
router.get("/videos", adminAuthentication, getAllVideos);

// GET /api/videos/:id - Obtener metadatos de un vídeo
router.get("/videos/:id", adminAuthentication, getVideoMetadata);

// Servir archivos HLS (segmentos y playlists de resolución)
router.use("/hls", registeredAuthentication, express.static(storageConfig.hlsDir));

// Servir miniaturas de vídeos
router.use("/thumbnails", registeredAuthentication, express.static(storageConfig.thumbnailDir));

export default router;
