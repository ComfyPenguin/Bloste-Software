import 'package:blosteflix2/domain/entities/video.dart';
import 'package:blosteflix2/infrastructure/mappers/categoria_mapper.dart';

class VideoMapper {
  // Convierte JSON del backend a Video
  static Video fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] as int,
      idVideo: json['idVideo'] as String,
      title: json['titulo'] as String,
      description: json['descripcion'] as String,
      author: json['autor'] as String,
      urlthumbnail: json['urlImagen'] as String,
      urlVideo: json['urlVideo'] as String,
      duration: json['duracion'] as int,
      fechaSubida: DateTime.parse(json['fechaSubida'] as String),
      fechaActualizacion: DateTime.parse(json['fechaActualizacion'] as String),
      categories: (json['categorias'] as List)
          .map((e) => CategoriaMapper.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}