import express from "express";
import fileUpload from "express-fileupload";
import path from "path";
import env from "./config/env.config";
import uploadRoutes from "./routes/uploadRoutes";
import { videoProcessingService } from "./services/videoProcessingService";

const app = express();

// CORS Middleware
app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
  res.header("Access-Control-Allow-Headers", "Content-Type, Authorization");
  res.header("Access-Control-Max-Age", "3600");

  if (req.method === "OPTIONS") {
    return res.sendStatus(204);
  }

  next();
});

// Middlewares
app.use(express.json());
app.use(
  fileUpload({
    limits: { fileSize: 5 * 1024 * 1024 * 1024 }, // 5GB
    useTempFiles: true,
    tempFileDir: "/tmp",
  })
);

// Inicialitzar serveis
async function initializeServices() {
  try {
    await videoProcessingService.init();
    console.log("Services initialized successfully");
  } catch (error) {
    console.error("Failed to initialize services:", error);
  }
}

initializeServices();

// Servir archivos estáticos (HTML, CSS, JS)
app.use(express.static(path.join(__dirname, "..")));

// Rutas
app.use("/api", uploadRoutes);

// Iniciar servidor
app.listen(env.PORT, () => {
  console.log(`Media server escuchando en el puerto ${env.PORT}`);
  console.log(`Entorno: ${env.NODE_ENV}`);
});
