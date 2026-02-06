<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  currentPage: number
  totalPages: number
  totalElements: number
}>()

const emit = defineEmits(['page-change'])

// Computed property para generar un array de números de página basado en el total de páginas
const pageNumbers = computed(() => {
  const pages = []
  for (let i = 0; i < props.totalPages; i++) {
    pages.push(i)
  }
  return pages
})

// Función para manejar el cambio de página, emitiendo el nuevo número de página al componente padre
function changePage(page: number) {
  if (page >= 0 && page < props.totalPages) {
    emit('page-change', page)
  }
}
</script>

<template>
  <div class="pagination-container">
    <button @click="changePage(currentPage - 1)" :disabled="currentPage === 0" class="nav-button">
      Anterior
    </button>
    <span v-for="page in pageNumbers" :key="page">
      <button
        @click="changePage(page)"
        :class="{ 'page-button': true, active: page === currentPage }"
      >
        {{ page + 1 }}
      </button>
    </span>
    <button
      @click="changePage(currentPage + 1)"
      :disabled="currentPage === totalPages - 1"
      class="nav-button"
    >
      Siguiente
    </button>
  </div>
</template>

<style scoped>
.pagination-container {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 0.5rem;
  margin-top: 2rem;
}

.nav-button,
.page-button {
  padding: 0.5rem 1rem;
  border: 1px solid var(--color-border);
  background-color: var(--color-background-soft);
  color: var(--color-text);
  cursor: pointer;
  border-radius: 5px;
}

.nav-button:disabled {
  cursor: not-allowed;
  opacity: 0.5;
}

.page-button.active {
  background-color: var(--color-primary);
  color: var(--color-background);
  border-color: var(--color-primary);
}
</style>
