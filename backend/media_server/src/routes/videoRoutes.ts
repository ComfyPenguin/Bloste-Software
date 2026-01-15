import express, { Router } from "express";
import { multerUpload as multerMiddleware } from "../middlewares/multerMiddleware";
import { uploadVideo, getVideoMetadata, getAllVideos } from "../controllers/videoController";
import storageConfig from "../config/storage.config";

const router = Router();

// POST /api/upload - Subir un vídeo
router.post("/upload", multerMiddleware.single("video"), uploadVideo);

// GET /api/videos - Obtener todos los vídeos
router.get("/videos", getAllVideos);

// GET /api/videos/:id - Obtener metadatos de un vídeo
router.get("/videos/:id", getVideoMetadata);

// -- Rutas para servir HLS -- //

// GET /api/hls/:videoId - Redirigir a resolución automática
router.get("/hls/:videoId", (req, res) => {
  const { videoId } = req.params;
  res.redirect(`/api/hls/${videoId}/master.m3u8`);
});

// GET /api/hls/:videoId/480 - Redirigir a resolución 480p
router.get("/hls/:videoId/480", (req, res) => {
  const { videoId } = req.params;
  res.redirect(`/api/hls/${videoId}/480/playlist.m3u8`);
});

// GET /api/hls/:videoId/720 - Redirigir a resolución 720p
router.get("/hls/:videoId/720", (req, res) => {
  const { videoId } = req.params;
  res.redirect(`/api/hls/${videoId}/720/playlist.m3u8`);
});

// GET /api/hls/:videoId/1080 - Redirigir a resolución 1080p
router.get("/hls/:videoId/1080", (req, res) => {
  const { videoId } = req.params;
  res.redirect(`/api/hls/${videoId}/1080/playlist.m3u8`);
});

// Servir archivos HLS (segmentos y playlists de resolución)
router.use("/hls", express.static(storageConfig.publicHlsDir));

export default router;
