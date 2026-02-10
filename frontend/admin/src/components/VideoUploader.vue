<script setup lang="ts">
import { ref, onUnmounted } from 'vue'
import { Formatter } from '@/utils/formatter'

const file = ref<File | null>(null)
const videoSrc = ref<string | null>(null)
const videoMetadata = ref<{ name: string; size: string; duration: string } | null>(null)
const fileInput = ref<HTMLInputElement | null>(null)

const emit = defineEmits(['update:file', 'update:videoTitle'])

// Función para manejar el cambio de archivo en el input
function handleFileChange(event: Event) {
  const target = event.target as HTMLInputElement
  const selectedFile = target.files?.[0]

  // Validar que se ha seleccionado un archivo y que es un video
  if (selectedFile && selectedFile.type.startsWith('video/')) {
    file.value = selectedFile

    // Eliminar la URL de objeto antigua para evitar fugas de memoria
    if (videoSrc.value) {
      URL.revokeObjectURL(videoSrc.value)
    }

    // Crear nueva URL de objeto para la vista previa del video
    const newSrc = URL.createObjectURL(selectedFile)
    videoSrc.value = newSrc

    // Crear elemento de video para obtener metadatos
    const videoEl = document.createElement('video')
    videoEl.src = newSrc
    videoEl.onloadedmetadata = () => {
      videoMetadata.value = {
        name: selectedFile.name,
        size: Formatter.bytes(selectedFile.size),
        duration: Formatter.durationTime(videoEl.duration),
      }
    }

    emit('update:file', file.value)
    emit('update:videoTitle', selectedFile.name)
  } else {
    // Tipo de archivo no válido
    file.value = null
    videoSrc.value = null
    videoMetadata.value = null
    emit('update:file', null)
  }
}

// Función para resetear el uploader
function resetUploader() {
  file.value = null
  videoSrc.value = null
  videoMetadata.value = null
  if (fileInput.value) {
    fileInput.value.value = ''
  }
  emit('update:file', null)
}

// Limpiar URLs de objetos al desmontar el componente
onUnmounted(() => {
  if (videoSrc.value) {
    URL.revokeObjectURL(videoSrc.value)
  }
})

defineExpose({
  resetUploader,
})
</script>

<template>
  <div class="video-uploader">
    <input
      ref="fileInput"
      id="video-upload"
      type="file"
      accept="video/*"
      @change="handleFileChange"
      class="hidden-input"
    />

    <!-- Mostrar área de carga si no se ha seleccionado un video -->
    <label for="video-upload" class="upload-area" v-if="!videoSrc">
      <p class="upload-text">Arrastra aquí tu video o haz clic para seleccionar</p>
    </label>

    <!-- Mostrar vista previa al seleccionar un video -->
    <div class="preview-container" v-else>
      <video :src="videoSrc" controls class="video-preview"></video>
      <div v-if="videoMetadata" class="metadata-display">
        <p><strong>Título original:</strong> {{ videoMetadata.name }}</p>
        <p><strong>Tamaño:</strong> {{ videoMetadata.size }}</p>
        <p><strong>Duración:</strong> {{ videoMetadata.duration }}</p>
      </div>
      <label for="video-upload" class="change-button">Cambiar video</label>
    </div>
  </div>
</template>

<style scoped>
.video-uploader {
  margin-bottom: 1.5rem;
}

.hidden-input {
  display: none;
}

.upload-area {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 2rem;
  border: 2px dashed var(--color-border);
  border-radius: 8px;
  background-color: var(--color-background-mute);
  cursor: pointer;
  min-height: 150px;
}

.upload-area:hover {
  opacity: 0.9;
  background-color: var(--color-background);
}

.upload-text {
  color: var(--color-text);
  font-size: 1.1rem;
  text-align: center;
}

.preview-container {
  border: 1px solid var(--color-border);
  border-radius: 8px;
  padding: 1rem;
  background-color: var(--color-background);
}

.video-preview {
  height: 400px; /* Altura fija de 400px */
  width: auto; /* Mantener la proporción de aspecto */
  max-width: 100%; /* Asegurar que no se salga del contenedor horizontalmente */
  object-fit: contain; /* Asegura que el video se ajusta sin cortar */
  display: block; /* Para permitir margin: auto */
  margin: 0 auto 1rem auto; /* Centrar y margen inferior */
  border-radius: 6px;
}

.metadata-display {
  margin-bottom: 1rem;
  padding: 1rem;
  background-color: var(--color-background-mute);
  border-radius: 6px;
}

.metadata-display p {
  margin: 0.5rem 0;
  color: var(--color-text);
}

.metadata-display strong {
  color: var(--color-heading);
}

.change-button {
  display: inline-block;
  padding: 0.5rem 1rem;
  background-color: var(--color-primary);
  color: var(--color-background);
  border-radius: 5px;
  text-align: center;
  cursor: pointer;
}

.change-button:hover {
  opacity: 0.9;
}
</style>
