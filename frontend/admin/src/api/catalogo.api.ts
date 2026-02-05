import type { FormData } from '@/types/content.type'
import env from '@/configs/env.config'
import axios from 'axios'
import type { ApiResponseCategories, ApiResponseContent, Catalogo } from '@/types/categories.type'

const CATALOGO_URL = env.VITE_BACKEND_CATALOGO_URL

export const catalogoApi = {
  // Guarda el contenido completo (formulario + datos del video procesado)
  // TODO: Agregar token de autenticación en el header
  async saveContent(data: FormData, token: string) {
    try {
      const response = await axios.post(`${CATALOGO_URL}/api/catalogo`, data, {
        headers: {
          'Content-Type': 'application/json',
          // Authorization: `Bearer ${token}`,
        },
      })
      return response.data
    } catch {
      throw new Error('Error al guardar el contenido')
    }
  },

  // Obtener contenidos paginados
  async getContentsPaginated(page: number = 0, size: number = 10) {
    const response = await axios.get<ApiResponseContent>(
      `${CATALOGO_URL}/api/catalogo?page=${page}&size=${size}`,
    )
    return response.data
  },

  // Obtener todos los videos
  async getAllContents() {
    const response = await axios.get<ApiResponseContent>(`${CATALOGO_URL}/api/catalogo/all`)
    return response.data
  },

  // Obtener las categorías
  async getCategories() {
    const response = await axios.get<ApiResponseCategories>(`${CATALOGO_URL}/api/categorias`)
    return response.data
  },

  // Obtener contenido por su ID
  async getContentById(id: number) {
    try {
      const response = await axios.get<Catalogo>(`${CATALOGO_URL}/api/catalogo/${id}`)
      return response.data
    } catch {
      throw new Error('Error al obtener el contenido por ID')
    }
  },

  // Actualizar un contenido existente
  async updateContent(id: number, data: FormData) {
    try {
      const response = await axios.put(`${CATALOGO_URL}/api/catalogo/${id}`, data, {
        headers: {
          'Content-Type': 'application/json',
        },
      })
      return response.data
    } catch {
      throw new Error('Error al actualizar el contenido')
    }
  },
}
