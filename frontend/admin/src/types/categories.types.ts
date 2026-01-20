export interface Categoria {
  id: number
  nombre: string
  descripcion: string
}

export interface ApiResponse {
  content: Categoria[]
  empty: boolean
  first: boolean
  last: boolean
  number: number
  numberOfElements: number
  totalElements: number
  totalPages: number
}
