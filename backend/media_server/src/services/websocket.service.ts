import { WebSocketServer, WebSocket } from "ws";
import type { Data as WebSocketData } from "ws";
import type { Server } from "http";
import type { VideoMetadata } from "../types/metadata.type";
import type { WebSocketWithClientId } from "../types/websocket.type";

// Servicio para gestionar conexiones WebSocket
export class WebSocketService {
  private wss: WebSocketServer | null = null;
  private clients: Set<WebSocketWithClientId> = new Set();
  // Mapa de clientId a WebSocket
  private clientIdToSocket: Map<string, WebSocketWithClientId> = new Map();
  // Mapa de videoId a clientId
  private videoIdToClientId: Map<string, string> = new Map();

  // Inicializar el servidor WebSocket
  init(server: Server): void {
    this.wss = new WebSocketServer({ server, path: "/ws" });

    this.wss.on("connection", (ws: WebSocketWithClientId) => {
      console.log("New WebSocket client connected");
      this.clients.add(ws);

      // Esperar el primer mensaje con el clientId
      const onMessage = (data: WebSocketData) => {
        try {
          const msg = JSON.parse(data.toString());
          if (msg && msg.clientId && typeof msg.clientId === "string") {
            this.clientIdToSocket.set(msg.clientId, ws);
            ws._clientId = msg.clientId; // Guardar en el socket para cerrar conexiones después
            ws.off("message", onMessage); // Escuchar solo el primer mensaje
            console.log(`WebSocket asociado a clientId: ${msg.clientId}`);
          }
        } catch (e) {
          console.error("Error parsing WebSocket message:", e);
        }
      };
      ws.on("message", onMessage);

      ws.on("close", () => {
        console.log("WebSocket client disconnected");
        this.clients.delete(ws);
        // Limpiar clientIdToSocket
        const clientId = ws._clientId;
        if (clientId && this.clientIdToSocket.get(clientId) === ws) {
          this.clientIdToSocket.delete(clientId);
        }
      });

      ws.on("error", (error) => {
        console.error("WebSocket error:", error);
        this.clients.delete(ws);
        const clientId = ws._clientId;
        if (clientId && this.clientIdToSocket.get(clientId) === ws) {
          this.clientIdToSocket.delete(clientId);
        }
      });
    });
  }

  // Asociar videoId con clientId
  associateVideoWithClient(videoId: string, clientId: string): void {
    this.videoIdToClientId.set(videoId, clientId);

    console.log("WebSocket server initialized on /ws");
  }

  // Enviar evento completado
  emitVideoProcessed(videoId: string, metadata: VideoMetadata): void {
    const message = JSON.stringify({
      event: "videoProcessed",
      data: {
        videoId,
        metadata,
        timestamp: new Date().toISOString(),
      },
    });
    this.sendToVideoOwner(videoId, message);
  }

  // Enviar evento fallido
  emitVideoFailed(videoId: string, error: string): void {
    const message = JSON.stringify({
      event: "videoFailed",
      data: {
        videoId,
        error,
        timestamp: new Date().toISOString(),
      },
    });
    this.sendToVideoOwner(videoId, message);
  }

  // Enviar actualización de estado
  emitStatusUpdate(videoId: string): void {
    const message = JSON.stringify({
      event: "statusUpdate",
      data: {
        videoId,
        status: "processing",
        timestamp: new Date().toISOString(),
      },
    });
    this.sendToVideoOwner(videoId, message);
  }

  // Enviar mensaje al cliente
  private sendToVideoOwner(videoId: string, message: string): void {
    const clientId = this.videoIdToClientId.get(videoId);
    if (!clientId) return;
    const ws = this.clientIdToSocket.get(clientId);
    if (ws && ws.readyState === WebSocket.OPEN) {
      ws.send(message);
    }
  }

  // Cerrar todas las conexiones
  close(): void {
    this.clients.forEach((client) => {
      client.close();
    });
    this.wss?.close();
  }
}

export const websocketService = new WebSocketService();
