<script setup lang="ts">
import { ref, watch } from 'vue'

const BACKEND_URL = import.meta.env.VITE_BACKEND_MEDIA_URL || 'http://localhost:4000'

const emit = defineEmits<{
  (e: 'file-selected', title: string): void
}>()

const fileInput = ref<HTMLInputElement | null>(null)
const dragging = ref(false)
const selectedFile = ref<File | null>(null)
const objectUrl = ref<string>('')
watch(selectedFile, (file, prevFile) => {
  if (prevFile && objectUrl.value) {
    URL.revokeObjectURL(objectUrl.value)
  }
  if (file) {
    objectUrl.value = URL.createObjectURL(file)
  } else {
    objectUrl.value = ''
  }
})

const uploadProgress = ref(0)
const uploading = ref(false)
const error = ref('')

const allowedTypes = ['video/mp4', 'video/webm', 'video/ogg']
const maxSize = 5 * 1024 * 1024 * 1024 // 5GB

const onFileChange = (e: Event) => {
  const files = (e.target as HTMLInputElement).files
  if (files && files[0]) handleFile(files[0])
}

const handleFile = (file: File) => {
  error.value = ''
  if (!allowedTypes.includes(file.type)) {
    error.value = 'Tipo de archivo no permitido. Usa MP4/WebM/OGG.'
    return
  }
  if (file.size > maxSize) {
    error.value = 'Archivo demasiado grande (máx 5GB).'
    return
  }
  selectedFile.value = file
  const name = file.name.replace(/\.[^/.]+$/, '')
  emit('file-selected', name)
}

const onDrop = (e: DragEvent) => {
  e.preventDefault()
  dragging.value = false
  if (e.dataTransfer?.files?.[0]) handleFile(e.dataTransfer.files[0])
}

const uploadFile = async () => {
  if (!selectedFile.value) return
  uploading.value = true
  uploadProgress.value = 0
  try {
    const form = new FormData()
    form.append('file', selectedFile.value)

    const xhr = new XMLHttpRequest()
    xhr.open('POST', `${BACKEND_URL}/api/upload`)
    xhr.upload.onprogress = (evt) => {
      if (evt.lengthComputable) uploadProgress.value = Math.round((evt.loaded / evt.total) * 100)
    }
    xhr.onload = () => {
      uploading.value = false
      if (xhr.status >= 200 && xhr.status < 300) {
        console.log('Upload success', xhr.responseText)
        if (objectUrl.value) {
          URL.revokeObjectURL(objectUrl.value)
          objectUrl.value = ''
        }
        selectedFile.value = null
        uploadProgress.value = 0
      } else {
        error.value = 'Error subiendo archivo.'
      }
    }
    xhr.onerror = () => {
      uploading.value = false
      error.value = 'Error de red durante la subida.'
    }
    xhr.send(form)
  } catch {
    uploading.value = false
    error.value = 'Error inesperado.'
  }
}

const removeFile = () => {
  if (objectUrl.value) {
    URL.revokeObjectURL(objectUrl.value)
  }
  objectUrl.value = ''
  selectedFile.value = null
  uploadProgress.value = 0
  error.value = ''
  if (fileInput.value) fileInput.value.value = ''
}
</script>

<template>
  <div class="uploader">
    <label
      v-if="!selectedFile"
      class="uploader-dropzone"
      :class="{ dragging }"
      @dragover.prevent="dragging = true"
      @dragleave.prevent="dragging = false"
      @drop.prevent="onDrop"
    >
      <input ref="fileInput" type="file" accept="video/*" @change="onFileChange" hidden />
      <div class="uploader-message">
        <strong>Arrastra y suelta un video</strong><br />
        <small>o haz clic para seleccionar (MP4/WebM/OGG, máx 5GB)</small>
      </div>
    </label>

    <div v-if="selectedFile" class="uploader-preview">
      <video :src="objectUrl" controls class="preview-video"></video>
      <div class="preview-info">
        <div class="file-name">{{ selectedFile.name }}</div>
        <div class="file-size">{{ (selectedFile.size / (1024 * 1024)).toFixed(2) }} MB</div>
      </div>
      <div class="upload-controls">
        <button class="btn-secondary" type="button" @click="removeFile" :disabled="uploading">
          Eliminar
        </button>
        <button class="btn-primary" type="button" @click="uploadFile" :disabled="uploading">
          Subir Video
        </button>
      </div>
    </div>
    <div v-if="uploading" class="progress-bar">
      <div class="progress" :style="{ width: uploadProgress + '%' }"></div>
    </div>
  </div>

  <div v-if="error" class="uploader-error">{{ error }}</div>
</template>

<style src="./styles/form.css" scoped></style>
<style src="./styles/preview.css" scoped></style>
<style src="./styles/buttons.css" scoped></style>
<style src="./styles/responsive.css" scoped></style>
