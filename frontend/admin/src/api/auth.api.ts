import env from '@/configs/env.config'
import axios from 'axios'
import { handleError } from '@/middlewares/errorHandler'

const AUTH_URL = env.VITE_BACKEND_AUTH_URL

interface LoginCredentials {
  login: string
  password: string
}

interface RegisterData {
  name: string
  login: string
  password: string
}

// API para autenticación y gestión de usuarios de odoo
export const authApi = {
  // Iniciar sesión y obtener tokens
  async login(loginCredentials: LoginCredentials) {
    try {
      const response = await axios.post(`${AUTH_URL}/api/auth/token`, loginCredentials, {
        headers: {
          'Content-Type': 'application/json',
        },
      })
      return response.data
    } catch (error) {
      throw new Error(handleError(error, 'Error al iniciar sesión'))
    }
  },

  // Renovar el token usando el refresh token
  async refreshToken(refreshToken: string) {
    try {
      const response = await axios.post(
        `${AUTH_URL}/api/auth/refresh`,
        { refresh_token: refreshToken },
        {
          headers: {
            'Content-Type': 'application/json',
          },
        },
      )
      return response.data
    } catch (error) {
      throw new Error(handleError(error, 'Error al renovar el token'))
    }
  },

  // Registrar un nuevo usuario
  async register(registerData: RegisterData) {
    try {
      const response = await axios.post(`${AUTH_URL}/api/auth/register`, registerData, {
        headers: {
          'Content-Type': 'application/json',
        },
      })
      return { data: response.data, status: response.status }
    } catch (error: any) {
      if (error.response?.status === 400) {
        throw new Error('El usuario ya existe')
      }
      throw new Error(handleError(error, 'Error al registrar el usuario'))
    }
  },

  // Obtener información del usuario autenticado
  async getUserInfo(token: string) {
    try {
      const response = await axios.get(`${AUTH_URL}/api/users/me`, {
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${token}`,
        },
      })
      return response.data
    } catch (error) {
      throw new Error(handleError(error, 'Error al obtener la información del usuario'))
    }
  },
}
