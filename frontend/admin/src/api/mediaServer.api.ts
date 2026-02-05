import axios from 'axios'
import env from '@/configs/env.config'

const MEDIA_SERVER_URL = env.VITE_BACKEND_MEDIA_SERVER_URL

export const mediaServerApi = {
  async uploadVideo(file: File, clientId: string) {
    const formData = new FormData()
    formData.append('video', file)

    try {
      const response = await axios.post(`${MEDIA_SERVER_URL}/api/upload`, formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
          clientid: clientId,
        },
      })
      return response.data
    } catch (error) {
      console.error('Error uploading video:', error)
      throw new Error('Error al subir el video')
    }
  },
}
