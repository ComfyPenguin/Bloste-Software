interface EnvConfig {
  VITE_BACKEND_MEDIA_SERVER_URL: string
  VITE_WEBSOCKET_MEDIA_SERVER_URL: string
  VITE_BACKEND_CATALOGO_URL: string
  VITE_BACKEND_AUTH_URL: string
  VITE_APP_ENV?: string
}

// Carga de variables de entorno con valores predeterminados
export const env: EnvConfig = {
  VITE_BACKEND_MEDIA_SERVER_URL:
    import.meta.env.VITE_BACKEND_MEDIA_SERVER_URL || 'http://localhost:4000',
  VITE_WEBSOCKET_MEDIA_SERVER_URL:
    import.meta.env.VITE_WEBSOCKET_MEDIA_SERVER_URL || 'ws://localhost:4000/ws',
  VITE_BACKEND_CATALOGO_URL: import.meta.env.VITE_BACKEND_CATALOGO_URL || 'http://localhost:8080',
  VITE_BACKEND_AUTH_URL: import.meta.env.VITE_BACKEND_AUTH_URL || 'http://localhost:8069',
  VITE_APP_ENV: import.meta.env.VITE_APP_ENV || 'development',
}

export default env
