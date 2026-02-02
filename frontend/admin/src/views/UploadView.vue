<script setup lang="ts">
import { ref, computed } from 'vue'
import VideoUploader from '@/components/VideoUploader.vue'
import DataForm from '@/components/DataForm.vue'
import { catalogoApi } from '@/api/catalogo.api'
import { mediaServerApi } from '@/api/mediaServer.api'
import { useWebSocket } from '@/services/webSocket.service.ts'
import { generateClientId } from '@/utils/idGenerator.ts'
import type { WebSocketMessageData } from '@/types/websocket.type'
import type { FormData } from '@/types/content.type'
import { useToast } from '@/composables/useToast'

const videoUploader = ref<InstanceType<typeof VideoUploader> | null>(null)
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
const clientId = generateClientId()
const { success, error, info } = useToast()

const { connect, onVideoProcessed, onVideoFailed, onUnexpectedClose, disconnect } = useWebSocket()

// Manejar el evento de video procesado
onVideoProcessed(async (data: WebSocketMessageData) => {
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
    success(`Video: ${contentToSave.titulo}\nGuardado correctamente en el catálogo.`)
    clearForm()
  } catch (err) {
    error(`Video: ${videoMetadata.value.titulo}\nError al guardar el video en el catálogo.`)
    console.error(err)
  } finally {
    isSubmitting.value = false
    disconnect()
  }
})

// Manejar errores desde el WebSocket
onVideoFailed((data: WebSocketMessageData) => {
  error(`Error en el procesado: ${data.error}`)
  isSubmitting.value = false
  disconnect()
})

// Manejar cierre inesperado del WebSocket
onUnexpectedClose(() => {
  if (isSubmitting.value) {
    error('Se ha perdido la conexión con el servidor de procesado de videos.')
    isSubmitting.value = false
  }
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

function handleVideoTitleChange(title: string) {
  const withoutExtension = title.replace(/\.[^/.]+$/, '')
  videoMetadata.value.titulo = withoutExtension
}

// Lipiar el formulario y componente VideoUploader
function clearForm() {
  videoFile.value = null
  videoMetadata.value = {
    titulo: '',
    descripcion: '',
    autor: '',
    categorias: [] as string[],
    duracion: 0,
    visible: true,
  }

  // Reiniciar el componente VideoUploader
  if (videoUploader.value) {
    videoUploader.value.resetUploader()
  }
}

async function submit() {
  if (isFormInvalid.value || !videoFile.value) {
    info('Por favor, completa todos los campos requeridos y selecciona un video.')
    return
  }

  isSubmitting.value = true

  // Conectar el WebSocket al enviar el video
  try {
    info('Procesando video...')
    connect(clientId)
    await mediaServerApi.uploadVideo(videoFile.value, clientId)
  } catch (err) {
    error(`Video: ${videoMetadata.value.titulo}\nError al procesar el video.`)
    console.error(err)
    isSubmitting.value = false
  }
}
</script>

<template>
  <div class="upload-view">
    <div class="upload-container">
      <div class="form-container">
        <div class="form-section uploader-section">
          <VideoUploader
            ref="videoUploader"
            @update:file="handleFileChange"
            @update:videoTitle="handleVideoTitleChange"
          />
        </div>
        <div class="form-section">
          <DataForm :form="videoMetadata" @update:form="handleFormUpdate" />
        </div>
      </div>

      <button :disabled="isFormInvalid || isSubmitting" @click="submit" class="submit-button">
        <span v-if="isSubmitting">Subiendo...</span>
        <span v-else>Enviar</span>
      </button>
    </div>
  </div>
</template>

<style scoped>
.upload-view {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  min-height: 80vh;
  padding: 2rem;
}

.upload-container {
  max-width: 1200px; /* Aumentar el max-width para el diseño horizontal */
  width: 100%;
  background-color: var(--color-background-soft);
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); /* Sombra para tema claro */
  border: 1px solid var(--color-border);
  color: var(--color-text);
}

/* Brillo para el tema oscuro */
html.dark .upload-container {
  box-shadow: 0 -4px 25px -8px hsla(var(--primary), 0.5);
}

h1 {
  text-align: center;
  color: var(--color-heading);
  margin-bottom: 2rem; /* Aumentar margen */
}

.form-container {
  display: flex;
  flex-direction: row;
  gap: 2rem;
  margin-bottom: 2rem;
}

.form-section {
  flex: 1; /* Cada sección ocupa el 50% del espacio */
  min-width: 0; /* Para que flexbox maneje el tamaño correctamente */
}

.uploader-section {
  display: flex;
  align-items: center;
  justify-content: center;
}

/* Media Query para pantallas pequeñas */
@media (max-width: 800px) {
  .form-container {
    flex-direction: column;
  }
}

.submit-button {
  display: block;
  padding: 0.75rem 1.5rem;
  margin-left: auto;
  margin-right: 0;
  background-color: var(--color-primary); /* Usar el color primario de la paleta */
  color: var(--color-background); /* Usar un color de fondo para el texto del botón */
  border: none;
  border-radius: 5px;
  font-size: 1rem;
  cursor: pointer;
}

.submit-button:hover:not(:disabled) {
  opacity: 0.9;
}

.submit-button:disabled {
  background-color: var(--color-border);
  color: var(--color-text-muted);
  cursor: not-allowed;
  opacity: 0.6;
}

.submission-status {
  text-align: center;
  margin-top: 1rem;
  font-style: italic;
  color: var(--color-text);
}
</style>
