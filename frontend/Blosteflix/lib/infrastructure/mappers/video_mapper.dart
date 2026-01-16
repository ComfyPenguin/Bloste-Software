import 'package:frontend/domain/entities/video.dart';

class VideoMapper {
  // Método estático que recibe un JSON y devuelve una instancia de un Video
  static Video fromJson(Map<String, dynamic> json) {
    return Video(
      id: json["idVideo"]?.toString() ?? json["id"].toString(),
      topic: (json["categorias"] is List && json["categorias"].isNotEmpty)
          ? json["categorias"].join(", ")
          : null,
      description: json["descripcion"]?.toString(),
      duration: (json["duracion"] is num)
          ? (json["duracion"] as num).toDouble()
          : double.tryParse(json["duracion"].toString()),
      urlVideo: json["urlVideo"]?.toString(),
      thumbnail: json["urlImagen"]?.toString(),
      author: json["autor"]?.toString(),
    );
  }
}
