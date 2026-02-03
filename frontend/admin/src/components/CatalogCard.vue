<script setup lang="ts">
import type { Catalogo } from '@/types/categories.type'
import env from '@/configs/env.config'
import { computed, ref } from 'vue'
import imageNotFound from '@/assets/image_not_found.svg'
import { Formatter } from '@/utils/formatter'

const props = defineProps<{
  item: Catalogo
}>()

const imageBaseUrl = env.VITE_BACKEND_MEDIA_SERVER_URL as string
const imageSrc = ref(imageBaseUrl + props.item.urlImagen)

const emit = defineEmits(['click'])

function handleClick() {
  emit('click')
}

function handleImageError() {
  imageSrc.value = imageNotFound
}

const formattedDuration = computed(() => Formatter.durationTime(props.item.duracion))
const relativeUploadDate = computed(() => Formatter.timeAgo(props.item.fechaSubida))
</script>

<template>
  <div class="catalog-card" @click="handleClick">
    <div class="card-image-container">
      <img
        :src="imageSrc"
        :alt="props.item.titulo"
        :class="['card-image', { 'error-image': imageSrc === imageNotFound }]"
        @error="handleImageError"
      />
      <div class="duration-badge">{{ formattedDuration }}</div>
    </div>
    <div class="card-content">
      <h3 class="card-title">{{ props.item.titulo }}</h3>
      <p class="card-author">{{ props.item.autor }}</p>
      <p class="card-upload-date">{{ relativeUploadDate }}</p>
    </div>
  </div>
</template>

<style scoped>
.catalog-card {
  border: 1px solid var(--color-border);
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  transition:
    transform 0.2s,
    box-shadow 0.2s;
  background-color: var(--color-background-soft);
}

.catalog-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
}

.card-image-container {
  position: relative;
  width: 100%;
  height: 180px;
}

.card-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.duration-badge {
  position: absolute;
  bottom: 8px;
  right: 8px;
  background-color: rgba(0, 0, 0, 0.75);
  color: white;
  padding: 2px 6px;
  border-radius: 4px;
  font-size: 0.8rem;
  font-weight: 500;
}

.card-image.error-image {
  object-fit: contain;
  padding: 1rem;
  background-color: var(--color-background);
  filter: var(--svg-filter);
}

@media (prefers-color-scheme: dark) {
  .card-image.error-image {
    filter: var(--svg-filter-dark);
  }
}

.card-content {
  padding: 1rem;
}

.card-title {
  font-size: 1.1rem;
  font-weight: bold;
  color: var(--color-heading);
  margin-bottom: 0.5rem;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.card-author {
  font-size: 0.9rem;
  color: var(--color-text-muted);
  margin-bottom: 0.25rem;
}

.card-upload-date {
  font-size: 0.8rem;
  color: var(--color-text-muted);
}
</style>
