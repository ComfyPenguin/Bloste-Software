class Categoria {
  int? id;
  String nombre;

  Categoria({required this.id, required this.nombre});

  @override
  String toString() {
    return 'Categoria{id: $id, nombre: $nombre}';
  }
}
