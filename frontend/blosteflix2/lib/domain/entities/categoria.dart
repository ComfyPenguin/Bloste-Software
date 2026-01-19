class Categoria {
  int id;
  String nombre;
  String? descripcion;

  Categoria({required this.id, required this.nombre, this.descripcion});

  @override
  String toString() {
    return 'Categoria{id: $id, nombre: $nombre, descripcion: $descripcion}';
  }
}
