import { ref } from 'vue'
import { importSPKI, jwtVerify } from 'jose'
import publicKeyPem from '@/keys/public.pem?raw'
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

  // Verificar si el usuario está autenticado y es admin
  async function isAuthenticated(): Promise<boolean> {
    const token = getToken()
    if (!token) return false

    return await checkAdminStatus(token)
  }

  return {
    isAdmin,
    userInfo,
    decodeToken,
    checkAdminStatus,
    getToken,
    isAuthenticated,
  }
}
