import 'package:blosteflix2/domain/entities/categoria.dart';

class CategoriaMapper {
  static Categoria fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
    );
  }
}