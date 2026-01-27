<script setup lang="ts">
import { reactive } from 'vue'
import type { FormData } from '@/types/content.type'

const form: FormData = reactive({
  titulo: '',
  descripcion: '',
  categorias: [] as string[],
  autor: '',
  visible: true,
  duracion: 0,
})

const emit = defineEmits(['update:form'])

function updateForm() {
  const processedForm: FormData = {
    ...form,
    categorias: String(form.categorias).split(',').map((c) => c.trim()), // Procesar categorías como array
  }
  emit('update:form', processedForm)
}
</script>

<template>
  <form @input="updateForm">
    <div>
      <label for="titulo">Título</label>
      <input id="titulo" v-model="form.titulo" type="text" />
    </div>
    <div>
      <label for="descripcion">Descripción</label>
      <textarea id="descripcion" v-model="form.descripcion"></textarea>
    </div>
    <div>
      <label for="categorias">Categorías (separadas por comas)</label>
      <textarea id="categorias" v-model="form.categorias"></textarea>
    </div>
    <div>
      <label for="autor">Autor</label>
      <input id="autor" v-model="form.autor" type="text" />
    </div>
    <div>
      <label for="visible">Visible</label>
      <input id="visible" v-model="form.visible" type="checkbox" />
    </div>
  </form>
</template>
