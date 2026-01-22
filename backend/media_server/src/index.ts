import express from "express";
import path from "path";
import { createServer } from "http";
import env from "./configs/env.config";
import videoRoutes from "./routes/video.routes";
import { videoProcessingService } from "./services/videoProcessing.service";
import { websocketService } from "./services/websocket.service";
import storageConfig from "./configs/storage.config";
import { errorHandler, notFoundHandler } from "./middlewares/error.middleware";

const app = express();
const httpServer = createServer(app);

// CORS Middleware
app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Methods", "GET, POST");
  res.header("Access-Control-Allow-Headers", "Content-Type, Authorization");
  res.header("Access-Control-Max-Age", "3600");

  if (req.method === "OPTIONS") {
    return res.sendStatus(204);
  }

  next();
});

// Middlewares
app.use(express.json());

// Inicializar servicios
async function initializeServices() {
  try {
    await videoProcessingService.init();
    websocketService.init(httpServer);
    console.log("Services initialized successfully");
  } catch (error) {
    console.error("Failed to initialize services:", error);
  }
}

initializeServices();

// Rutas
app.use("/api", videoRoutes);

// Servir thumbnails
app.use("/thumbnails", express.static(path.join(storageConfig.hlsDir, "thumbnails")));

// Middleware de manejo de errores
app.use(notFoundHandler);
app.use(errorHandler);

// Iniciar servidor
httpServer.listen(env.PORT, () => {
  console.log(`Media server listening on port ${env.PORT}`);
  console.log(`WebSocket server available at ws://localhost:${env.PORT}/ws`);
  console.log(`Environment: ${env.NODE_ENV}`);
});
