import { Router } from "express";
import path from "path";
import fs from "fs-extra";
import { uploadVideo, getVideoMetadata, getAllVideos } from "../controllers/videoController";
import storageConfig from "../config/storage.config";

const router = Router();

// POST /api/upload - Pujar un vídeo
router.post("/upload", uploadVideo);

// GET /api/videos - Obtener todos los vídeos
router.get("/videos", getAllVideos);

// GET /api/videos/:id - Obtener metadatos de un vídeo
router.get("/videos/:id", getVideoMetadata);

// GET /api/hls/:id - Servir video
router.get("/hls/:id", async (req, res) => {
  const masterPath = path.resolve(storageConfig.publicHlsDir, req.params.id, "master.m3u8");

  // TODO: Mejorar la gestión de errores (Middleware de errores global)
  if (!(await fs.pathExists(masterPath))) {
    return res.status(404).json({ error: "HLS master not found" });
  }

  res.sendFile(masterPath);
});

export default router;
