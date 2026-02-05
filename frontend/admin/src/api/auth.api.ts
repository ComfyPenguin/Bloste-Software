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

export const authApi = {
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
  async register(registerData: RegisterData) {
    try {
      const response = await axios.post(`${AUTH_URL}/api/auth/register`, registerData, {
        headers: {
          'Content-Type': 'application/json',
        },
      })
      return response.data
    } catch (error) {
      throw new Error(handleError(error, 'Error al registrar el usuario'))
    }
  },

  async logout() {
    try {
      const response = await axios.post(`${AUTH_URL}/api/auth/logout`, null, {
        headers: {
          'Content-Type': 'application/json',
        },
      })
      return response.data
    } catch (error) {
      throw new Error(handleError(error, 'Error al cerrar sesión'))
    }
  },

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
