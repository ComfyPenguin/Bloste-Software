import multer from "multer";
import storageConfig from "../configs/storage.config";

// Configuracion de multer para subida de archivos
export const multerMiddleware = multer({
  dest: storageConfig.uploadDir,
  limits: { fileSize: 5 * 1024 * 1024 * 1024 }, // 5 GB
  fileFilter: (req, file, cb) => {
    if (file.mimetype.startsWith("video/")) {
      cb(null, true);
    } else {
      cb(new Error("Only video files are allowed"));
    }
  },
});
