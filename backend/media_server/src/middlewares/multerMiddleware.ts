import multer from "multer";

// Configuracion de multer para subida de archivos
export const multerUpload = multer({
  dest: "/tmp",
  limits: { fileSize: 5 * 1024 * 1024 * 1024 }, // 5 GB
});
