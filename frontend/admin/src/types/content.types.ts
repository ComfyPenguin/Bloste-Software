export interface FormData {
  titulo: string
  autor: string
  descripcion: string
  categorias: string[]
  privacidad: 'publico' | 'oculto'
}
