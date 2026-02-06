<script setup lang="ts">
import { ref, watch } from 'vue'
import DataForm from './DataForm.vue'
import type { FormData } from '@/types/content.type'
import type { Catalogo } from '@/types/categories.type'
import { useToast } from '@/composables/useToast'

const props = defineProps<{
  itemId: number | null
  item: Catalogo | null
  visible: boolean
}>()

const emit = defineEmits(['save', 'close'])
const toast = useToast()

const formData = ref<FormData>({
  titulo: '',
  descripcion: '',
  autor: '',
  categorias: [],
  visible: true,
})

// Evitar scroll del fondo cuando el popup está abierto
watch(
  () => props.visible,
  (isVisible) => {
    if (isVisible) {
      document.body.style.overflow = 'hidden'
    } else {
      document.body.style.overflow = ''
    }
  },
)

// Actualizar el estado del formulario cuando se abra el popup con un nuevo item
watch([() => props.visible, () => props.item], async ([isVisible, item]) => {
  if (isVisible && item) {
    try {
      const categoriasFromItem = Array.isArray(item.categorias)
        ? item.categorias.map((c) => c.nombre.charAt(0).toUpperCase() + c.nombre.slice(1))
        : []
      formData.value = {
        titulo: item.titulo,
        descripcion: item.descripcion,
        autor: item.autor,
        categorias: categoriasFromItem,
        visible: Boolean(item.visible),
      }
    } catch (error) {
      toast.error('No se pudo cargar la información para editar.')
      console.error(error)
      handleClose()
    }
  }
})

// Funciones para manejar eventos del popup
function handleFormUpdate(newFormState: FormData) {
  formData.value = newFormState
}

// Función para manejar el guardado de cambios desde el popup de edición
function handleSave() {
  if (props.itemId) {
    emit('save', {
      titulo: formData.value.titulo,
      descripcion: formData.value.descripcion,
      autor: formData.value.autor,
      categorias: formData.value.categorias,
      visible: formData.value.visible,
    })
  }
}

// Función para manejar el cierre del popup
function handleClose() {
  emit('close')
}
</script>

<template>
  <div v-if="visible" class="popup-overlay" @click.self="handleClose">
    <div class="popup-content">
      <div class="popup-header">
        <h2>Editar Contenido</h2>
        <button @click="handleClose" class="close-button">&times;</button>
      </div>
      <div class="popup-body">
        <DataForm :form="formData" @update:form="handleFormUpdate" />
      </div>
      <div class="popup-footer">
        <button @click="handleClose" class="cancel-btn">Cancelar</button>
        <button @click="handleSave" class="save-btn">Guardar Cambios</button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.popup-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.7);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.popup-content {
  background-color: var(--color-background-soft);
  padding: 2rem;
  border-radius: 8px;
  width: 90%;
  max-width: 600px;
  max-height: 90vh;
  display: flex;
  flex-direction: column;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
}

.popup-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid var(--color-border);
  padding-bottom: 1rem;
  margin-bottom: 1rem;
}

.popup-header h2 {
  color: var(--color-heading);
}

.close-button {
  background: none;
  border: none;
  font-size: 2rem;
  cursor: pointer;
  color: var(--color-text);
}

.popup-body {
  overflow-y: auto;
  flex-grow: 1;
  padding-right: 1rem;
  margin-right: -1rem;
}

.popup-footer {
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
  border-top: 1px solid var(--color-border);
  padding-top: 1rem;
  margin-top: 1rem;
}

.cancel-btn,
.save-btn {
  padding: 0.5rem 1rem;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  font-size: 1rem;
}

.cancel-btn {
  background-color: var(--color-background-mute);
  color: var(--color-text);
}

.save-btn {
  background-color: var(--color-primary);
  color: var(--color-background);
}
</style>
