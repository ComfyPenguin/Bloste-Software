import express, { Router } from "express";
import multer from "multer";
import { uploadVideo, getVideoMetadata, getAllVideos } from "../controllers/videoController";
import storageConfig from "../config/storage.config";

const router = Router();

// Configurar multer para subida de archivos
const upload = multer({
  dest: "/tmp",
  limits: { fileSize: 5 * 1024 * 1024 * 1024 }, // 5 GB
});

// POST /api/upload - Pujar un vídeo
router.post("/upload", upload.single("video"), uploadVideo);

// GET /api/videos - Obtener todos los vídeos
router.get("/videos", getAllVideos);

// GET /api/videos/:id - Obtener metadatos de un vídeo
router.get("/videos/:id", getVideoMetadata);

// GET /api/hls/:videoId - Redirigir a master.m3u8
router.get("/hls/:videoId", (req, res) => {
  const { videoId } = req.params;
  res.redirect(`/api/hls/${videoId}/master.m3u8`);
});

// Servir archivos HLS (segmentos y playlists de resolución)
router.use("/hls", express.static(storageConfig.publicHlsDir));

export default router;
