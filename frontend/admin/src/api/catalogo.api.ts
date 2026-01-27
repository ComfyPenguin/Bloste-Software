import type { FormData } from '@/types/content.type'
import env from '@/configs/env.config'
import axios from 'axios'
import type { ApiResponse } from '@/types/categories.type'

const CATALOGO_URL = env.VITE_BACKEND_CATALOGO_URL || 'http://localhost:8080'

export const catalogoApi = {
  // Guarda el contenido completo (formulario + datos del video procesado)
  async saveContent(data: FormData) {
    try {
      const response = await axios.post(`${CATALOGO_URL}/api/catalogo`, data, {
        headers: {
          'Content-Type': 'application/json',
        },
      })
      return response.data
    } catch {
      throw new Error('Error al guardar el contenido')
    }
  },

  // Obtener los nombres de las categorías disponibles
  async getNamesCategories() {
    const response = await axios.get<ApiResponse>(`${CATALOGO_URL}/api/categorias`)
    return response.data
  },
}
