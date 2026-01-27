<script setup lang="ts">
import { ref, computed } from 'vue'
import VideoUploader from '@/components/VideoUploader.vue'
import VideoMetadataForm from '@/components/DataForm.vue'
import { catalogoApi } from '@/api/catalogo.api'
import { mediaServerApi } from '@/api/mediaServer.api'
import { useWebSocket } from '@/services/webSocket.service.ts'
import { generateClientId } from '@/utils/idGenerator.ts'
import type { WebSocketMessageData } from '@/types/websocket.type'
import type { FormData } from '@/types/content.type'

const videoFile = ref<File | null>(null)
const videoMetadata = ref<FormData>({
  titulo: '',
  descripcion: '',
  autor: '',
  categorias: [] as string[],
  duracion: 0,
  visible: true,
})
const isSubmitting = ref(false)
const submissionStatus = ref('') // Estado del envío [TEMPORAL]
const clientId = generateClientId()

const { connect, onVideoProcessed, onVideoFailed, onStatusUpdate, disconnect } = useWebSocket()

// Manejar el evento de video procesado
onVideoProcessed(async (data: WebSocketMessageData) => {
  submissionStatus.value = 'Guardando metadatos...'
  try {
    // Combinar los metadatos recibidos con los del formulario
    const contentToSave = {
      ...videoMetadata.value,
      duracion: data.metadata?.duration ?? videoMetadata.value.duracion,
      idVideo: data.videoId ?? videoMetadata.value.idVideo,
      urlImagen: data.metadata?.thumbnailPath ?? videoMetadata.value.urlImagen,
      urlVideo: data.metadata?.hlsPath ?? videoMetadata.value.urlVideo,
    }
    await catalogoApi.saveContent(contentToSave)
    submissionStatus.value = 'Video guardado correctamente.'
  } catch (error) {
    submissionStatus.value = 'Error al guardar los metadatos.'
    console.error(error)
  } finally {
    isSubmitting.value = false
    disconnect()
  }
})

// Manejar errores desde el WebSocket
onVideoFailed((data: WebSocketMessageData) => {
  submissionStatus.value = `Error en el procesado: ${data.error}`
  isSubmitting.value = false
  disconnect()
})

onStatusUpdate((data: WebSocketMessageData) => {
  submissionStatus.value = data.status || 'Actualizando estado...'
})

const isFormInvalid = computed(() => {
  const isInvalid =
    !videoFile.value ||
    !videoMetadata.value.titulo ||
    !videoMetadata.value.descripcion ||
    (videoMetadata.value.categorias?.length ?? 0) === 0 ||
    !videoMetadata.value.autor
  return isInvalid
})

function handleFileChange(file: File | null) {
  videoFile.value = file
}

function handleFormUpdate(form: FormData) {
  videoMetadata.value = form
}

async function submit() {
  if (isFormInvalid.value || !videoFile.value) {
    return
  }

  isSubmitting.value = true
  submissionStatus.value = 'Subiendo video...'

  // Conectar el WebSocket al enviar el video
  try {
    connect(clientId)
    await mediaServerApi.uploadVideo(videoFile.value, clientId)
    submissionStatus.value = 'Video subido. Procesando...'
  } catch (error) {
    submissionStatus.value = 'Error al subir el video.'
    console.error(error)
    isSubmitting.value = false
  }
}
</script>

<template>
  <div>
    <h1>Subir y procesar video</h1>
    <VideoUploader @update:file="handleFileChange" />
    <hr />
    <VideoMetadataForm @update:form="handleFormUpdate" />
    <hr />
    <button :disabled="isFormInvalid || isSubmitting" @click="submit">
      <span v-if="isSubmitting">{{ submissionStatus }}</span>
      <span v-else>Enviar</span>
    </button>
  </div>
</template>
