import express from "express";
import env from "./config/env.config";
import uploadRoutes from "./routes/videoRoutes";
import { videoProcessingService } from "./services/videoProcessingService";

const app = express();

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
    console.log("Services initialized successfully");
  } catch (error) {
    console.error("Failed to initialize services:", error);
  }
}

initializeServices();

// Rutas
app.use("/api", uploadRoutes);

// Iniciar servidor
app.listen(env.PORT, () => {
  console.log(`Media server listening on port ${env.PORT}`);
  console.log(`Environment: ${env.NODE_ENV}`);
});
