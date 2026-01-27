import { ref, onUnmounted, type Ref } from 'vue'
import type { WebSocketMessage, WebSocketMessageData } from '@/types/websocket.type'
import env from '@/configs/env.config'

// Servicio WebSocket para manejar la comunicación en tiempo real
export class WebSocketService {
  private WEBSOCKET_URL: string
  private ws: Ref<WebSocket | null>
  public connected: Ref<boolean>
  private clientId: Ref<string>
  private callbacks: Ref<{
    onVideoProcessed?: (data: WebSocketMessageData) => void
    onVideoFailed?: (data: WebSocketMessageData) => void
    onStatusUpdate?: (data: WebSocketMessageData) => void
  }>

  constructor() {
    this.WEBSOCKET_URL = env.VITE_WEBSOCKET_MEDIA_SERVER_URL || 'ws://localhost:4000/ws'
    this.ws = ref<WebSocket | null>(null)
    this.connected = ref(false)
    this.clientId = ref('')
    this.callbacks = ref({})

    onUnmounted(() => {
      this.disconnect()
    })
  }

  // Conectar al WebSocket con un ID de cliente específico
  connect(id: string) {
    this.clientId.value = id
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

    this.ws.value.onerror = (error) => {
      console.error('WebSocket error:', error)
    }

    this.ws.value.onclose = () => {
      console.log('WebSocket disconnected')
      this.connected.value = false
    }
  }

  disconnect() {
    if (this.ws.value) {
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
}

export function useWebSocket() {
  const service = new WebSocketService()

  return {
    connect: (id: string) => service.connect(id),
    disconnect: () => service.disconnect(),
    onVideoProcessed: (cb: (data: WebSocketMessageData) => void) => service.onVideoProcessed(cb),
    onVideoFailed: (cb: (data: WebSocketMessageData) => void) => service.onVideoFailed(cb),
    onStatusUpdate: (cb: (data: WebSocketMessageData) => void) => service.onStatusUpdate(cb),
    connected: service.connected,
  }
}
