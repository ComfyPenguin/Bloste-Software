export interface Categoria {
  id: number
  nombre: string
}

export interface Catalogo {
  id: number
  titulo: string
  descripcion: string
  autor: string
  duracion: number
  categoria: Categoria[]
  fechaSubida: string
  fechaActualizacion: string
  idVideo: string
  urlImagen: string
  urlVideo: string
}

export interface ApiResponseContent {
  content: Catalogo[]
  empty: boolean
  first: boolean
  last: boolean
  number: number
  numberOfElements: number
  totalElements: number
  totalPages: number
}

export interface ApiResponseCategories {
  content: Categoria[]
  empty: boolean
  first: boolean
  last: boolean
  number: number
  numberOfElements: number
  totalElements: number
  totalPages: number
}
