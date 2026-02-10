import { ref, type Ref } from 'vue'
import type { WebSocketMessage, WebSocketMessageData } from '@/types/websocket.type'
import env from '@/configs/env.config'

// Servicio WebSocket para manejar la comunicación en tiempo real
export class WebSocketService {
  private WEBSOCKET_URL: string
  private ws: Ref<WebSocket | null>
  public connected: Ref<boolean>
  private clientId: Ref<string>
  private unexpectedClose: boolean
  private callbacks: Ref<{
    onVideoProcessed?: (data: WebSocketMessageData) => void
    onVideoFailed?: (data: WebSocketMessageData) => void
    onStatusUpdate?: (data: WebSocketMessageData) => void
    onUnexpectedClose?: () => void // Callback para cierre inesperado
  }>

  constructor() {
    this.WEBSOCKET_URL = env.VITE_WEBSOCKET_MEDIA_SERVER_URL
    this.ws = ref<WebSocket | null>(null)
    this.connected = ref(false)
    this.clientId = ref('')
    this.unexpectedClose = false
    this.callbacks = ref({})
  }

  // Conectar al WebSocket con un ID de cliente específico
  connect(id: string) {
    this.clientId.value = id
    this.unexpectedClose = false
    this.ws.value = new WebSocket(this.WEBSOCKET_URL)

    this.ws.value.onopen = () => {
      console.log('WebSocket connected')
      this.connected.value = true
      this.ws.value?.send(JSON.stringify({ clientId: this.clientId.value }))
    }

    // Mensajes entrantes del WebSocket
    this.ws.value.onmessage = (event) => {
      try {
        const message: WebSocketMessage = JSON.parse(event.data)
        console.log('WebSocket message received:', message)
        switch (message.event) {
          case 'videoProcessed':
            this.callbacks.value.onVideoProcessed?.(message.data)
            break
          case 'videoFailed':
            this.callbacks.value.onVideoFailed?.(message.data)
            break
          case 'statusUpdate':
            this.callbacks.value.onStatusUpdate?.(message.data)
            break
        }
      } catch (error) {
        console.error('Error parsing WebSocket message:', error)
      }
    }

    // Manejar errores del WebSocket
    this.ws.value.onerror = (error) => {
      console.error('WebSocket error:', error)
      this.callbacks.value.onUnexpectedClose?.()
    }

    // Manejar cierre del WebSocket
    this.ws.value.onclose = () => {
      console.log('WebSocket disconnected')
      this.connected.value = false
      if (!this.unexpectedClose) {
        this.callbacks.value.onUnexpectedClose?.()
      }
    }
  }

  disconnect() {
    if (this.ws.value) {
      this.unexpectedClose = true
      this.ws.value.close()
      this.ws.value = null
      this.connected.value = false
    }
  }

  // Registrar callbacks para eventos específicos
  onVideoProcessed(callback: (data: WebSocketMessageData) => void) {
    this.callbacks.value.onVideoProcessed = callback
  }

  onVideoFailed(callback: (data: WebSocketMessageData) => void) {
    this.callbacks.value.onVideoFailed = callback
  }

  onStatusUpdate(callback: (data: WebSocketMessageData) => void) {
    this.callbacks.value.onStatusUpdate = callback
  }

  onUnexpectedClose(callback: () => void) {
    this.callbacks.value.onUnexpectedClose = callback
  }
}

// Composable para usar el servicio WebSocket en componentes Vue
export function useWebSocket() {
  const service = new WebSocketService()

  return {
    connect: (id: string) => service.connect(id),
    disconnect: () => service.disconnect(),
    onVideoProcessed: (cb: (data: WebSocketMessageData) => void) => service.onVideoProcessed(cb),
    onVideoFailed: (cb: (data: WebSocketMessageData) => void) => service.onVideoFailed(cb),
    onStatusUpdate: (cb: (data: WebSocketMessageData) => void) => service.onStatusUpdate(cb),
    onUnexpectedClose: (cb: () => void) => service.onUnexpectedClose(cb),
    connected: service.connected,
  }
}
