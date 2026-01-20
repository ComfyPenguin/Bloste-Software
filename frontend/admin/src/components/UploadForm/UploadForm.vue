<script setup lang="ts">
import { ref, reactive, onMounted, watch } from 'vue'
const props = defineProps<{ suggestedTitle?: string }>()

// track last auto-assigned title so user edits are preserved
const lastAutoTitle = ref('')

watch(
  () => props.suggestedTitle,
  (newTitle) => {
    if (!newTitle) return
    // only auto-set when empty or previously auto-set
    if (formData.titulo.trim() === '' || formData.titulo === lastAutoTitle.value) {
      formData.titulo = newTitle
      lastAutoTitle.value = newTitle
    }
  },
)
import type { FormData } from '@/types/content.types'
import { categoriasApi } from '@/api/categories.api'

const formData = reactive<FormData>({
  titulo: '',
  autor: '',
  descripcion: '',
  categorias: [],
  privacidad: 'publico',
})

const categoriasDisponibles = ref<string[]>([])
const categoriasGrid = ref<HTMLElement | null>(null)
const cargandoCategorias = ref(true)
const errorCargaCategorias = ref('')

const nuevaCategoria = ref('')
const mostrandoErrores = ref(false)

// Función para cargar categorías de la API
const cargarCategorias = async () => {
  try {
    cargandoCategorias.value = true
    const data = await categoriasApi.getNamesCategories()
    categoriasDisponibles.value = data.content.map((cat) => cat.nombre)
    errorCargaCategorias.value = ''
  } catch (err) {
    // manejo de errores
    console.error('Error cargando categorías:', err)
    errorCargaCategorias.value = 'No se pudieron cargar las categorías. Intenta de nuevo más tarde.'
    categoriasDisponibles.value = []
  } finally {
    cargandoCategorias.value = false
  }
}

// Cargar categorías al montar el componente
onMounted(() => {
  cargarCategorias()
})

const agregarCategoria = () => {
  if (nuevaCategoria.value.trim() && !formData.categorias.includes(nuevaCategoria.value.trim())) {
    formData.categorias.push(nuevaCategoria.value.trim())
    nuevaCategoria.value = ''
  }
}

const onCategoriasWheel = (e: WheelEvent) => {
  if (!categoriasGrid.value) return
  // Prevent vertical scrolling and translate wheel to horizontal scroll
  e.preventDefault()
  categoriasGrid.value.scrollBy({ left: e.deltaY, behavior: 'smooth' })
}

const eliminarCategoria = (categoria: string) => {
  const index = formData.categorias.indexOf(categoria)
  if (index > -1) {
    formData.categorias.splice(index, 1)
  }
}

const validarFormulario = () => {
  return (
    formData.titulo.trim() !== '' &&
    formData.autor.trim() !== '' &&
    formData.descripcion.trim() !== ''
  )
}

const enviarFormulario = () => {
  mostrandoErrores.value = true

  if (validarFormulario()) {
    // TODO: Agregar la lógica para enviar el formulario
    console.log('Formulario enviado:', formData)
    // Reset del formulario
    Object.assign(formData, {
      titulo: '',
      autor: '',
      descripcion: '',
      categorias: [],
      privacidad: 'publico',
    })
    mostrandoErrores.value = false
  }
}

const limpiarFormulario = () => {
  Object.assign(formData, {
    titulo: '',
    autor: '',
    descripcion: '',
    categorias: [],
    privacidad: 'publico',
  })
  mostrandoErrores.value = false
}
</script>

<template>
  <div class="upload-form">
    <form @submit.prevent="enviarFormulario" class="form-container">
      <!-- Título -->
      <div class="form-group">
        <label for="titulo" class="form-label"> Título <span class="required">*</span> </label>
        <input
          id="titulo"
          v-model="formData.titulo"
          type="text"
          class="form-input"
          :class="{ error: mostrandoErrores && !formData.titulo.trim() }"
          placeholder="Título del contenido"
          maxlength="100"
        />
        <div v-if="mostrandoErrores && !formData.titulo.trim()" class="error-message">
          El título es obligatorio
        </div>
      </div>

      <!-- Autor -->
      <div class="form-group">
        <label for="autor" class="form-label"> Autor <span class="required">*</span> </label>
        <input
          id="autor"
          v-model="formData.autor"
          type="text"
          class="form-input"
          :class="{ error: mostrandoErrores && !formData.autor.trim() }"
          placeholder="Nombre del autor"
          maxlength="50"
        />
        <div v-if="mostrandoErrores && !formData.autor.trim()" class="error-message">
          El autor es obligatorio
        </div>
      </div>

      <!-- Descripción -->
      <div class="form-group">
        <label for="descripcion" class="form-label">
          Descripción <span class="required">*</span>
        </label>
        <textarea
          id="descripcion"
          v-model="formData.descripcion"
          class="form-textarea"
          :class="{ error: mostrandoErrores && !formData.descripcion.trim() }"
          placeholder="Descripción del contenido..."
          rows="4"
          maxlength="500"
        ></textarea>
        <div class="char-counter">{{ formData.descripcion.length }}/500 caracteres</div>
        <div v-if="mostrandoErrores && !formData.descripcion.trim()" class="error-message">
          La descripción es obligatoria
        </div>
      </div>

      <!-- Categorías -->
      <div class="form-group">
        <label class="form-label">Categorías</label>

        <!-- Agregar nueva categoría -->
        <div class="categoria-input-group">
          <input
            v-model="nuevaCategoria"
            type="text"
            class="form-input categoria-input"
            placeholder="Agregar categoría personalizada"
            @keyup.enter="agregarCategoria"
            maxlength="30"
          />
          <button
            type="button"
            @click="agregarCategoria"
            class="btn-agregar-categoria"
            :disabled="!nuevaCategoria.trim()"
          >
            Agregar
          </button>
        </div>

        <!-- Categorías disponibles -->
        <div class="categorias-disponibles">
          <h4>Categorías sugeridas:</h4>

          <!-- Estado de carga -->
          <div v-if="cargandoCategorias" class="cargando-categorias">
            <div class="spinner"></div>
            <span>Cargando categorías...</span>
          </div>

          <!-- Error de carga -->
          <div v-else-if="errorCargaCategorias" class="error-categorias">
            <p>{{ errorCargaCategorias }}</p>
            <button type="button" @click="cargarCategorias" class="btn-reintentar">
              Reintentar
            </button>
          </div>

          <!-- Categorías cargadas -->
          <div v-else class="categorias-grid" ref="categoriasGrid" @wheel="onCategoriasWheel">
            <button
              v-for="categoria in categoriasDisponibles"
              :key="categoria"
              type="button"
              class="categoria-sugerida"
              :class="{ selected: formData.categorias.includes(categoria) }"
              @click="
                formData.categorias.includes(categoria)
                  ? eliminarCategoria(categoria)
                  : formData.categorias.push(categoria)
              "
            >
              {{ categoria }}
            </button>
          </div>
        </div>

        <!-- Categorías seleccionadas -->
        <div v-if="formData.categorias.length > 0" class="categorias-seleccionadas">
          <h4>Categorías seleccionadas:</h4>
          <div class="categorias-tags">
            <span v-for="categoria in formData.categorias" :key="categoria" class="categoria-tag">
              {{ categoria }}
              <button
                type="button"
                @click="eliminarCategoria(categoria)"
                class="btn-eliminar-categoria"
                aria-label="Eliminar categoría"
              >
                ×
              </button>
            </span>
          </div>
        </div>
      </div>

      <!-- Privacidad -->
      <div class="form-group">
        <label class="form-label">Privacidad</label>
        <div class="radio-group">
          <label class="radio-option">
            <input v-model="formData.privacidad" type="radio" value="publico" class="radio-input" />
            <span class="radio-custom"></span>
            <div class="radio-content">
              <strong>Público</strong>
              <small>Visible para todos los usuarios</small>
            </div>
          </label>
          <label class="radio-option">
            <input v-model="formData.privacidad" type="radio" value="oculto" class="radio-input" />
            <span class="radio-custom"></span>
            <div class="radio-content">
              <strong>Oculto</strong>
              <small>Nadie podrá ver este contenido</small>
            </div>
          </label>
        </div>
      </div>

      <!-- Botones de acción -->
      <div class="form-actions">
        <button type="button" @click="limpiarFormulario" class="btn-secondary">Limpiar</button>
        <button type="submit" class="btn-primary">Guardar Contenido</button>
      </div>
    </form>
  </div>
</template>

<style src="./styles/form.css" scoped></style>
<style src="./styles/categories.css" scoped></style>
<style src="./styles/buttons.css" scoped></style>
<style src="./styles/responsive.css" scoped></style>
<style src="./styles/radio-buttons.css" scoped></style>
