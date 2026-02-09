import axios from 'axios'
import env from '@/configs/env.config'

const MEDIA_SERVER_URL = env.VITE_BACKEND_MEDIA_SERVER_URL

// API para interactuar con el servidor de medios (subida de videos)
export const mediaServerApi = {
  async uploadVideo(file: File, clientId: string) {
    const formData = new FormData()
    formData.append('video', file)
    const token = localStorage.getItem('authToken')

    try {
      const response = await axios.post(`${MEDIA_SERVER_URL}/api/upload`, formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
          clientid: clientId,
          Authorization: `Bearer ${token}`,
        },
      })
      return response.data
    } catch (error) {
      console.error('Error uploading video:', error)
      throw new Error('Error al subir el video')
    }
  },
}
