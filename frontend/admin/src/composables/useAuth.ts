import { ref } from 'vue'
import { authApi } from '@/api/auth.api'
import { handleError } from '@/middlewares/errorHandler'

interface DecodedToken {
  id?: number
  name?: string
  email?: string
  partner_id?: number
  [key: string]: any
}

export function useAuth() {
  const isAdmin = ref(false)
  const userInfo = ref<DecodedToken | null>(null)

  // Decodificar JWT sin verificar firma (solo para leer datos)
  function decodeToken(token: string): DecodedToken | null {
    try {
      const parts = token.split('.')
      if (parts.length !== 3) return null

      const decoded = JSON.parse(atob(parts[1]))
      return decoded
    } catch (error) {
      handleError(error, 'Error al decodificar el token')
      return null
    }
  }

  // Verificar si el usuario es admin
  async function checkAdminStatus(token: string): Promise<boolean> {
    try {
      const userDetails = await authApi.getUserInfo(token)
      userInfo.value = userDetails
      console.log('User details:', userDetails)

      // Verificar si el usuario es admin
      if (userDetails.id === 2 || userDetails.email === 'admin') {
        isAdmin.value = true
        return true
      }

      isAdmin.value = false
      return false
    } catch (error) {
      handleError(error, 'Error al comprobar permisos de administrador')
      isAdmin.value = false
      return false
    }
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
