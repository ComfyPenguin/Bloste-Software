import type { WebSocket } from "ws";

// Extiende WebSocket para incluir _clientId
export interface WebSocketWithClientId extends WebSocket {
  _clientId?: string;
}
