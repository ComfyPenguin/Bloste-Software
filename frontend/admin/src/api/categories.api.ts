import axios from 'axios'
import type { ApiResponse } from '@/types/categories.types'

const BACKEND_URL = import.meta.env.VITE_BACKEND_CATALOGO_URL || 'http://localhost:8080'

export const categoriasApi = {
  getNamesCategories: async () => {
    const response = await axios.get<ApiResponse>(`${BACKEND_URL}/api/categorias`)
    return response.data
  },
}
