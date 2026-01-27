// Genera un ID único para un cliente de WebSocket
export function generateClientId(): string {
  return `client_${crypto.randomUUID().replace(/-/g, '_')}`
}
