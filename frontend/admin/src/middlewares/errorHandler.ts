import env from '@/configs/env.config'

// Middleware para manejar errores de forma centralizada
export function handleError(error: unknown, fallbackMessage = 'Ha ocurrido un error'): string {
  const isDev = env.VITE_APP_ENV === 'development'

  let details = ''
  if (error instanceof Error) {
    details = error.message
  } else if (typeof error === 'string') {
    details = error
  } else if (error && typeof error === 'object' && 'message' in error) {
    details = String((error as { message?: unknown }).message ?? '')
  }

  if (isDev) {
    // Detalles completos en desarrollo
    console.error(error)
  }

  if (isDev && details) {
    return `${fallbackMessage}: ${details}`
  }

  return fallbackMessage
}
