<script setup lang="ts">
import { reactive, ref, onMounted, watch } from 'vue'
import type { FormData } from '@/types/content.type'
import { catalogoApi } from '@/api/catalogo.api'
import visibilityOn from '@/assets/visibility.svg'
import visibilityOff from '@/assets/visibility-off.svg'

const emit = defineEmits(['update:form'])

const props = defineProps<{
  form: FormData
}>()

// Local state for all form fields
const form = reactive<FormData>({
  titulo: props.form.titulo,
  descripcion: props.form.descripcion,
  categorias: props.form.categorias,
  autor: props.form.autor,
  visible: props.form.visible,
  duracion: props.form.duracion,
})

// State for the new category UI
const availableCategories = ref<string[]>([])
const newCategoryInput = ref('')

// Fetch available categories when the component is mounted
onMounted(async () => {
  try {
    const response = await catalogoApi.getCategories()
    // Extrae los nombres de las categorías del array content
    if (response && Array.isArray(response.content)) {
      availableCategories.value = response.content.map(
        (cat) => cat.nombre.charAt(0).toUpperCase() + cat.nombre.slice(1),
      )
    }
  } catch (error) {
    console.error('Error fetching categories:', error)
  }
})

// Function to add a category to the list
function addCategory(category: string) {
  const cat = category.trim()
  if (cat && !form.categorias.includes(cat)) {
    form.categorias.push(cat)
  }
}

// Function to handle the submission of a new category
function handleNewCategorySubmit() {
  addCategory(newCategoryInput.value)
  newCategoryInput.value = '' // Clear input
}

// Function to remove a category from the list
function removeCategory(categoryToRemove: string) {
  form.categorias = form.categorias.filter((cat) => cat !== categoryToRemove)
}

// Watch for changes in the form prop from the parent
watch(
  () => props.form,
  (newVal) => {
    form.titulo = newVal.titulo
    form.descripcion = newVal.descripcion
    form.autor = newVal.autor
    form.categorias = newVal.categorias
    form.visible = newVal.visible
    form.duracion = newVal.duracion
  },
  { deep: true },
)

// Watch for any changes in the form object and emit them to the parent
watch(
  form,
  (newFormState) => {
    emit('update:form', { ...newFormState })
  },
  { deep: true },
)
</script>

<template>
  <form class="data-form" @submit.prevent>
    <div class="form-field">
      <label for="titulo">Título</label>
      <input id="titulo" v-model="form.titulo" type="text" />
    </div>
    <div class="form-field">
      <label for="descripcion">Descripción</label>
      <textarea id="descripcion" v-model="form.descripcion"></textarea>
    </div>

    <!-- New Category Section -->
    <div class="form-field category-section">
      <label>Categorías seleccionadas:</label>

      <!-- Display Selected Categories -->
      <div class="selected-categories" v-if="form.categorias.length > 0">
        <span
          v-for="cat in form.categorias"
          :key="cat"
          class="selected-tag"
          @click="removeCategory(cat)"
        >
          {{ cat }}
        </span>
      </div>
      <p v-else class="no-categories-text">No se han seleccionado categorías.</p>

      <!-- Available Categories Selector -->
      <div class="available-categories-wrapper">
        <p>Categorías disponibles:</p>
        <div class="available-categories">
          <button
            v-for="cat in availableCategories"
            :key="cat"
            class="category-tag"
            @click.prevent="addCategory(cat)"
          >
            {{ cat }}
          </button>
        </div>
      </div>

      <!-- New Category Input -->
      <div class="new-category-form">
        <input
          id="new-category"
          v-model="newCategoryInput"
          type="text"
          placeholder="Crear nueva categoría"
          @keydown.enter.prevent="handleNewCategorySubmit"
        />
        <button @click.prevent="handleNewCategorySubmit" class="add-category-btn">Añadir</button>
      </div>
    </div>

    <div class="form-field-group">
      <div class="form-field author-field">
        <label for="autor">Autor</label>
        <input id="autor" v-model="form.autor" type="text" />
      </div>

      <div class="form-field visibility-field">
        <label>Visible</label>
        <button @click.prevent="form.visible = !form.visible" class="visibility-toggle">
          <img :src="form.visible ? visibilityOn : visibilityOff" alt="Toggle visibility" />
        </button>
      </div>
    </div>
  </form>
</template>

<style scoped>
/* Existing styles remain, new styles are added below */
.data-form {
  margin-top: 1.5rem;
}
.form-field {
  margin-bottom: 1.5rem;
}
.form-field label {
  display: block;
  color: var(--color-text);
  font-weight: bold;
}
.form-field input[type='text'],
.form-field textarea {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid var(--color-border);
  border-radius: 4px;
  background-color: var(--color-background);
  color: var(--color-text);
  font-size: 1rem;
  box-sizing: border-box;
}
.form-field textarea {
  min-height: 80px;
  resize: vertical;
}
.form-field input::placeholder,
.form-field textarea::placeholder {
  color: var(--color-text-muted);
  opacity: 0.8;
}
.form-field input[type='text']:focus,
.form-field textarea:focus {
  border-color: var(--color-primary);
  box-shadow: 0 0 0 3px hsla(26, 97%, 55%, 0.2);
  outline: none;
}

.form-field-group {
  display: flex;
  gap: 1rem;
  align-items: center; /* Aligns items to the bottom */
  margin-bottom: 1.5rem;
}

.author-field {
  flex-grow: 1;
  margin-bottom: 0;
}

.visibility-field {
  margin-bottom: 0;
}

.visibility-toggle {
  background-color: var(--color-background-mute);
  border: 1px solid var(--color-border);
  border-radius: 4px;
  padding: 0.65rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}

.visibility-toggle:hover {
  border-color: var(--color-primary);
}

.visibility-toggle img {
  width: 24px;
  height: 24px;
  filter: var(--svg-filter);
}

/* New Category Styles */
.category-section {
  border: 1px solid var(--color-border);
  padding: 1rem;
  border-radius: 4px;
}

.selected-categories {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  margin-bottom: 1rem;
}

.selected-tag {
  display: flex;
  align-items: center;
  background-color: var(--color-primary);
  color: var(--color-background);
  padding: 0.3rem 0.7rem;
  border-radius: 15px;
  font-size: 0.9rem;
  cursor: pointer;
}

.selected-tag:hover {
  opacity: 0.9;
}

.no-categories-text {
  color: var(--color-text-muted);
  font-style: italic;
  margin-bottom: 1rem;
}

.available-categories-wrapper {
  margin-bottom: 1rem;
}

.available-categories-wrapper p {
  font-size: 0.9rem;
  color: var(--color-text-muted);
  margin-bottom: 0.5rem;
}

.available-categories {
  display: flex;
  overflow-x: auto;
  gap: 0.5rem;
  padding-bottom: 10px; /* Space for scrollbar */
}

.category-tag {
  background-color: var(--color-primary);
  color: var(--color-background);
  border: none;
  padding: 0.4rem 0.8rem;
  border-radius: 15px;
  cursor: pointer;
  white-space: nowrap;
}

.category-tag:hover {
  opacity: 0.9;
  color: var(--color-background);
}

.new-category-form {
  display: flex;
  gap: 0.5rem;
  margin-top: 1rem;
}

.new-category-form input {
  flex-grow: 1;
}

.add-category-btn {
  background-color: var(--color-primary);
  color: var(--color-background);
  padding: 0 1rem;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.add-category-btn:hover {
  opacity: 0.9;
}
</style>
