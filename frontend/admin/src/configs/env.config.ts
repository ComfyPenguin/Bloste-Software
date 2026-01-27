interface EnvConfig {
  VITE_BACKEND_MEDIA_SERVER_URL: string
  VITE_WEBSOCKET_MEDIA_SERVER_URL: string
  VITE_BACKEND_CATALOGO_URL: string
}

export const env: EnvConfig = {
  VITE_BACKEND_MEDIA_SERVER_URL:
    import.meta.env.VITE_BACKEND_MEDIA_SERVER_URL || 'http://localhost:4000',
  VITE_WEBSOCKET_MEDIA_SERVER_URL:
    import.meta.env.VITE_WEBSOCKET_MEDIA_SERVER_URL || 'ws://localhost:4000/ws',
  VITE_BACKEND_CATALOGO_URL: import.meta.env.VITE_BACKEND_CATALOGO_URL || 'http://localhost:8080',
}

export default env
