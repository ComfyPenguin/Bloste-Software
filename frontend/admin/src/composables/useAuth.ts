import { ref } from 'vue'
import { decodeJwt, importSPKI, jwtVerify } from 'jose'
import publicKeyPem from '@/keys/public.pem?raw'
import { authApi } from '@/api/auth.api'
import { handleError } from '@/middlewares/errorHandler'

interface DecodedToken {
  sub?: string
  login?: string
  role?: string
  iat?: number
  exp?: number
  type?: string
}

export function useAuth() {
  const isAdmin = ref(false)
  const userInfo = ref<DecodedToken | null>(null)

  const JWT_ALGORITHM = 'RS256'

  // Verificar JWT con clave pública y devolver el payload
  async function decodeToken(token: string): Promise<DecodedToken | null> {
    try {
      const key = await importSPKI(publicKeyPem.trim(), JWT_ALGORITHM)
      const { payload } = await jwtVerify(token, key, { algorithms: [JWT_ALGORITHM] })
      return payload as DecodedToken
    } catch (error) {
      handleError(error, 'Token inválido o firma no válida')
      return null
    }
  }

  // Verificar si el usuario es admin
  async function checkAdminStatus(token: string): Promise<boolean> {
    const decoded = await decodeToken(token)
    userInfo.value = decoded

    if (decoded?.role === 'admin') {
      isAdmin.value = true
      return true
    }

    isAdmin.value = false
    return false
  }

  // Obtener token del localStorage
  function getToken(): string | null {
    return localStorage.getItem('authToken')
  }

  // Obtener refresh token del localStorage
  function getRefreshToken(): string | null {
    return localStorage.getItem('refreshToken')
  }

  // Verificar si el token ha expirado o está a punto de expirar
  function isTokenExpired(token: string): boolean {
    //Tiempo de gracia para renovar el token antes de que expire
    const TOKEN_EXPIRY_MARGIN_SECONDS = 120
    try {
      const { exp } = decodeJwt(token)
      if (!exp) return false
      const now = Math.floor(Date.now() / 1000)
      return exp <= now + TOKEN_EXPIRY_MARGIN_SECONDS
    } catch (error) {
      handleError(error, 'No se pudo leer el token')
      return true
    }
  }

  // Renovar el token usando el refresh token
  async function refreshAccessToken(): Promise<string | null> {
    try {
      const refreshToken = getRefreshToken()
      if (!refreshToken) return null
      const response = await authApi.refreshToken(refreshToken)
      if (response?.access_token) {
        localStorage.setItem('authToken', response.access_token)
      }
      if (response?.refresh_token) {
        localStorage.setItem('refreshToken', response.refresh_token)
      }
      return response?.access_token ?? null
    } catch (error) {
      handleError(error, 'Error al renovar el token')
      return null
    }
  }

  // Obtener un token válido, renovándolo si fuese necesario
  async function getValidToken(): Promise<string | null> {
    const token = getToken()
    if (!token) return null
    if (isTokenExpired(token)) {
      return await refreshAccessToken()
    }
    return token
  }

  // Verificar si el usuario está autenticado y es admin
  async function isAuthenticated(): Promise<boolean> {
    const token = await getValidToken()
    if (!token) return false

    return await checkAdminStatus(token)
  }

  return {
    isAdmin,
    userInfo,
    decodeToken,
    checkAdminStatus,
    getToken,
    getValidToken,
    isAuthenticated,
  }
}
