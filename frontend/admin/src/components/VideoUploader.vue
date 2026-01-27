<script setup lang="ts">
import { ref } from 'vue'

const file = ref<File | null>(null)

const emit = defineEmits(['update:file'])

function handleFileChange(event: Event) {
  const target = event.target as HTMLInputElement
  if (target.files) {
    file.value = target.files[0] ?? null
    emit('update:file', file.value)
  }
}
</script>

<template>
  <div>
    <label for="video-upload">Subir video</label>
    <input
      id="video-upload"
      type="file"
      accept="video/*"
      @change="handleFileChange"
    />
    <p v-if="file">Archivo seleccionado: {{ file.name }}</p>
  </div>
</template>
