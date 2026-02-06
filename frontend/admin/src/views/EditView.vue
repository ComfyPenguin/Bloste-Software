<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { catalogoApi } from '@/api/catalogo.api'
import type { Catalogo } from '@/types/categories.type'
import type { FormData } from '@/types/content.type'
import CatalogCard from '@/components/CatalogCard.vue'
import EditPopup from '@/components/EditPopup.vue'
import PageNavigator from '@/components/PageNavigator.vue'
import { useToast } from '@/composables/useToast'

const contentList = ref<Catalogo[]>([])
const isLoading = ref(true)
const selectedItem = ref<Catalogo | null>(null)
const isPopupVisible = ref(false)

// Estado de la paginacion
const currentPage = ref(0)
const totalPages = ref(0)
const totalElements = ref(0)
const pageSize = ref(18)

const toast = useToast()

// Función para cargar el contenido paginado
async function fetchContent(page = 0) {
  isLoading.value = true
  try {
    const response = await catalogoApi.getContentsPaginated(page, pageSize.value)
    if (response && response.content) {
      contentList.value = response.content
      currentPage.value = response.number
      totalPages.value = response.totalPages
      totalElements.value = response.totalElements
    }
  } catch (error) {
    toast.error('Error al cargar el contenido.')
    console.error(error)
  } finally {
    isLoading.value = false
  }
}

// Cargar el contenido al montar el componente
onMounted(() => fetchContent(currentPage.value))

async function handleCardClick(item: Catalogo) {
  try {
    const fullItem = await catalogoApi.getContentById(item.id)
    selectedItem.value = fullItem
    isPopupVisible.value = true
  } catch (error) {
    toast.error('Error al cargar el contenido seleccionado.')
    console.error(error)
  }
}

// Función para manejar el cierre del popup de edición
function handleClosePopup() {
  isPopupVisible.value = false
  selectedItem.value = null
}

// Función para manejar el guardado de cambios desde el popup de edición
async function handleSaveChanges(updatedData: FormData) {
  if (!selectedItem.value) return

  try {
    await catalogoApi.updateContent(selectedItem.value.id, updatedData)
    toast.success('Contenido actualizado correctamente.')
    handleClosePopup()
    await fetchContent(currentPage.value)
  } catch (error) {
    toast.error('Error al actualizar el contenido.')
    console.error(error)
  }
}

// Función para manejar el cambio de página desde el PageNavigator
function handlePageChange(page: number) {
  fetchContent(page)
}
</script>

<template>
  <div class="edit-view-container">
    <div v-if="isLoading" class="loading-state">
      <p>Cargando contenido...</p>
    </div>

    <div v-else-if="contentList.length === 0" class="empty-state">
      <p>No hay contenido disponible para editar.</p>
    </div>

    <div v-else>
      <div class="content-grid">
        <CatalogCard
          v-for="item in contentList"
          :key="item.id"
          :item="item"
          @click="handleCardClick(item)"
        />
      </div>
      <PageNavigator
        :current-page="currentPage"
        :total-pages="totalPages"
        :total-elements="totalElements"
        @page-change="handlePageChange"
      />
    </div>

    <EditPopup
      :item-id="selectedItem?.id ?? null"
      :item="selectedItem"
      :visible="isPopupVisible"
      @close="handleClosePopup"
      @save="handleSaveChanges"
    />
  </div>
</template>

<style scoped>
.edit-view-container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  padding: 2rem;
  width: 100%;
}

h1 {
  text-align: center;
  color: var(--color-heading);
  margin-bottom: 2rem;
}

.loading-state,
.empty-state {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  color: var(--color-text-muted);
  font-size: 1.2rem;
  min-height: 400px;
}

.content-grid {
  flex: 1;
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

/* Media queries para móviles */
@media (max-width: 768px) {
  .edit-view-container {
    padding: 1rem;
    min-height: 100vh;
  }

  .content-grid {
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    gap: 1rem;
    margin-bottom: 1.5rem;
  }
}

@media (max-width: 480px) {
  .edit-view-container {
    padding: 0.5rem;
  }

  .content-grid {
    grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
    gap: 0.75rem;
    margin-bottom: 1rem;
  }
}
</style>
