<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import axios from 'axios'

const BACKEND_CATALOGO_URL = import.meta.env.VITE_BACKEND_CATALOGO_URL || 'http://localhost:8080'

interface FormData {
  titulo: string
  autor: string
  descripcion: string
  categorias: string[]
  privacidad: 'publico' | 'oculto'
}

interface Categoria {
  id: number
  nombre: string
  descripcion: string
}

interface ApiResponse {
  content: Categoria[]
  empty: boolean
  first: boolean
  last: boolean
  number: number
  numberOfElements: number
  totalElements: number
  totalPages: number
}

const formData = reactive<FormData>({
  titulo: '',
  autor: '',
  descripcion: '',
  categorias: [],
  privacidad: 'publico'
})

const categoriaDisponibles = ref<string[]>([])
const cargandoCategorias = ref(true)
const errorCargaCategorias = ref('')

const nuevaCategoria = ref('')
const mostrandoErrores = ref(false)

// Función para cargar categorías de la API
const cargarCategorias = async () => {
  try {
    cargandoCategorias.value = true
    errorCargaCategorias.value = ''

    const response = await axios.get<ApiResponse>(`${BACKEND_CATALOGO_URL}/api/categorias`)

    // Extraer solo los nombres de las categorías
    categoriaDisponibles.value = response.data.content.map(categoria => categoria.nombre)

  } catch (error) {
    console.error('Error al cargar categorías:', error)

    if (axios.isAxiosError(error)) {
      errorCargaCategorias.value = error.response?.data?.message || error.message || 'Error de conexión'
    } else {
      errorCargaCategorias.value = error instanceof Error ? error.message : 'Error desconocido'
    }

    // Categorías por defecto en caso de error
    categoriaDisponibles.value = ['Tecnología', 'Educación', 'Música', 'Deportes']
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

const eliminarCategoria = (categoria: string) => {
  const index = formData.categorias.indexOf(categoria)
  if (index > -1) {
    formData.categorias.splice(index, 1)
  }
}

const validarFormulario = () => {
  return formData.titulo.trim() !== '' &&
         formData.autor.trim() !== '' &&
         formData.descripcion.trim() !== ''
}

const enviarFormulario = () => {
  mostrandoErrores.value = true

  if (validarFormulario()) {
    // Aquí puedes agregar la lógica para enviar el formulario
    console.log('Formulario enviado:', formData)
    // Reset del formulario
    Object.assign(formData, {
      titulo: '',
      autor: '',
      descripcion: '',
      categorias: [],
      privacidad: 'publico'
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
    privacidad: 'publico'
  })
  mostrandoErrores.value = false
}
</script>

<template>
  <div class="upload-form">
    <div class="form-header">
      <h2>Formulario de Subida</h2>
      <p>Completa la información del contenido</p>
    </div>

    <form @submit.prevent="enviarFormulario" class="form-container">
      <!-- Título -->
      <div class="form-group">
        <label for="titulo" class="form-label">
          Título <span class="required">*</span>
        </label>
        <input
          id="titulo"
          v-model="formData.titulo"
          type="text"
          class="form-input"
          :class="{ 'error': mostrandoErrores && !formData.titulo.trim() }"
          placeholder="Ingresa el título del contenido"
          maxlength="100"
        />
        <div v-if="mostrandoErrores && !formData.titulo.trim()" class="error-message">
          El título es obligatorio
        </div>
      </div>

      <!-- Autor -->
      <div class="form-group">
        <label for="autor" class="form-label">
          Autor <span class="required">*</span>
        </label>
        <input
          id="autor"
          v-model="formData.autor"
          type="text"
          class="form-input"
          :class="{ 'error': mostrandoErrores && !formData.autor.trim() }"
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
          :class="{ 'error': mostrandoErrores && !formData.descripcion.trim() }"
          placeholder="Describe el contenido..."
          rows="4"
          maxlength="500"
        ></textarea>
        <div class="char-counter">
          {{ formData.descripcion.length }}/500 caracteres
        </div>
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
            <p>⚠️ {{ errorCargaCategorias }}</p>
            <button type="button" @click="cargarCategorias" class="btn-reintentar">
              Reintentar
            </button>
          </div>

          <!-- Categorías cargadas -->
          <div v-else class="categorias-grid">
            <button
              v-for="categoria in categoriaDisponibles"
              :key="categoria"
              type="button"
              class="categoria-sugerida"
              :class="{ 'selected': formData.categorias.includes(categoria) }"
              @click="formData.categorias.includes(categoria) ? eliminarCategoria(categoria) : formData.categorias.push(categoria)"
            >
              {{ categoria }}
            </button>
          </div>
        </div>

        <!-- Categorías seleccionadas -->
        <div v-if="formData.categorias.length > 0" class="categorias-seleccionadas">
          <h4>Categorías seleccionadas:</h4>
          <div class="categorias-tags">
            <span
              v-for="categoria in formData.categorias"
              :key="categoria"
              class="categoria-tag"
            >
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
            <input
              v-model="formData.privacidad"
              type="radio"
              value="publico"
              class="radio-input"
            />
            <span class="radio-custom"></span>
            <div class="radio-content">
              <strong>Público</strong>
              <small>Visible para todos los usuarios</small>
            </div>
          </label>
          <label class="radio-option">
            <input
              v-model="formData.privacidad"
              type="radio"
              value="oculto"
              class="radio-input"
            />
            <span class="radio-custom"></span>
            <div class="radio-content">
              <strong>Oculto</strong>
              <small>Solo visible para ti</small>
            </div>
          </label>
        </div>
      </div>

      <!-- Botones de acción -->
      <div class="form-actions">
        <button type="button" @click="limpiarFormulario" class="btn-secondary">
          Limpiar
        </button>
        <button type="submit" class="btn-primary">
          Guardar Contenido
        </button>
      </div>
    </form>
  </div>
</template>

<style scoped>
.upload-form {
  max-width: 800px;
  margin: 0 auto;
  padding: 2rem;
  background: #ffffff;
  border-radius: 12px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.form-header {
  text-align: center;
  margin-bottom: 2rem;
}

.form-header h2 {
  color: #2c3e50;
  margin-bottom: 0.5rem;
  font-size: 2rem;
  font-weight: 600;
}

.form-header p {
  color: #7f8c8d;
  font-size: 1rem;
}

.form-container {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.form-label {
  font-weight: 600;
  color: #2c3e50;
  font-size: 0.95rem;
}

.required {
  color: #e74c3c;
}

.form-input,
.form-textarea {
  padding: 0.75rem;
  border: 2px solid #e9ecef;
  border-radius: 8px;
  font-size: 1rem;
  transition: border-color 0.3s ease;
  background: #ffffff;
}

.form-input:focus,
.form-textarea:focus {
  outline: none;
  border-color: #3498db;
  box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
}

.form-input.error,
.form-textarea.error {
  border-color: #e74c3c;
}

.form-textarea {
  resize: vertical;
  min-height: 100px;
}

.char-counter {
  font-size: 0.85rem;
  color: #7f8c8d;
  text-align: right;
}

.error-message {
  color: #e74c3c;
  font-size: 0.85rem;
  margin-top: 0.25rem;
}

/* Categorías */
.categoria-input-group {
  display: flex;
  gap: 0.5rem;
}

.categoria-input {
  flex: 1;
}

.btn-agregar-categoria {
  padding: 0.75rem 1rem;
  background: #3498db;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  transition: background-color 0.3s ease;
}

.btn-agregar-categoria:hover:not(:disabled) {
  background: #2980b9;
}

.btn-agregar-categoria:disabled {
  background: #bdc3c7;
  cursor: not-allowed;
}

.categorias-disponibles,
.categorias-seleccionadas {
  margin-top: 1rem;
}

.categorias-disponibles h4,
.categorias-seleccionadas h4 {
  margin-bottom: 0.5rem;
  color: #2c3e50;
  font-size: 0.9rem;
  font-weight: 600;
}

.categorias-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  overflow: auto;
  max-height: 100px;
  padding-bottom: 0.5rem;
  scrollbar-width: thin;
  scrollbar-color: #bdc3c7 #f8f9fa;
}

.categorias-grid::-webkit-scrollbar {
  height: 6px;
}

.categorias-grid::-webkit-scrollbar-track {
  background: #f8f9fa;
  border-radius: 3px;
}

.categorias-grid::-webkit-scrollbar-thumb {
  background: #bdc3c7;
  border-radius: 3px;
}

.categorias-grid::-webkit-scrollbar-thumb:hover {
  background: #95a5a6;
}

.categoria-sugerida {
  padding: 0.5rem 1rem;
  border: 2px solid #e9ecef;
  background: #f8f9fa;
  border-radius: 20px;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 0.85rem;
  font-weight: 500;
}

.categoria-sugerida:hover {
  border-color: #3498db;
  background: #ebf3fd;
}

.categoria-sugerida.selected {
  background: #3498db;
  color: white;
  border-color: #3498db;
}

.categorias-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.categoria-tag {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 0.75rem;
  background: #27ae60;
  color: white;
  border-radius: 20px;
  font-size: 0.85rem;
  font-weight: 500;
}

.btn-eliminar-categoria {
  background: none;
  border: none;
  color: white;
  cursor: pointer;
  font-size: 1.2rem;
  line-height: 1;
  padding: 0;
  margin-left: 0.25rem;
  border-radius: 50%;
  width: 18px;
  height: 18px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background-color 0.3s ease;
}

.btn-eliminar-categoria:hover {
  background: rgba(255, 255, 255, 0.2);
}

/* Radio buttons */
.radio-group {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.radio-option {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  cursor: pointer;
  padding: 1rem;
  border: 2px solid #e9ecef;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.radio-option:hover {
  border-color: #3498db;
  background: #f8f9fa;
}

.radio-input {
  display: none;
}

.radio-custom {
  width: 20px;
  height: 20px;
  border: 2px solid #bdc3c7;
  border-radius: 50%;
  position: relative;
  transition: border-color 0.3s ease;
}

.radio-input:checked + .radio-custom {
  border-color: #3498db;
}

.radio-input:checked + .radio-custom::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 10px;
  height: 10px;
  background: #3498db;
  border-radius: 50%;
}

.radio-content {
  display: flex;
  flex-direction: column;
}

.radio-content strong {
  color: #2c3e50;
  margin-bottom: 0.25rem;
}

.radio-content small {
  color: #7f8c8d;
  font-size: 0.85rem;
}

/* Botones de acción */
.form-actions {
  display: flex;
  gap: 1rem;
  justify-content: flex-end;
  margin-top: 2rem;
  padding-top: 1.5rem;
  border-top: 1px solid #e9ecef;
}

.btn-primary,
.btn-secondary {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  font-size: 1rem;
  transition: all 0.3s ease;
}

.btn-primary {
  background: #27ae60;
  color: white;
}

.btn-primary:hover {
  background: #229954;
  transform: translateY(-1px);
}

.btn-secondary {
  background: #95a5a6;
  color: white;
}

.btn-secondary:hover {
  background: #7f8c8d;
}

/* Estados de carga para categorías */
.cargando-categorias {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem;
  background: #f8f9fa;
  border-radius: 8px;
  color: #7f8c8d;
  font-size: 0.9rem;
}

.spinner {
  width: 20px;
  height: 20px;
  border: 2px solid #e9ecef;
  border-top: 2px solid #3498db;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.error-categorias {
  padding: 1rem;
  background: #fdf2f2;
  border: 1px solid #fecaca;
  border-radius: 8px;
  color: #e74c3c;
}

.error-categorias p {
  margin: 0 0 0.5rem 0;
  font-size: 0.9rem;
}

.btn-reintentar {
  padding: 0.5rem 1rem;
  background: #e74c3c;
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 0.85rem;
  font-weight: 500;
  transition: background-color 0.3s ease;
}

.btn-reintentar:hover {
  background: #c0392b;
}

/* Responsivo */
@media (max-width: 768px) {
  .upload-form {
    margin: 1rem;
    padding: 1.5rem;
  }

  .form-actions {
    flex-direction: column-reverse;
  }

  .categoria-input-group {
    flex-direction: column;
  }

  .categorias-grid {
    justify-content: center;
  }
}
</style>
