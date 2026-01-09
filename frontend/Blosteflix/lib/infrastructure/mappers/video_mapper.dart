import 'package:frontend/domain/entities/video.dart';

class VideoMapper {
  // Método estático que recibe un JSON y devuelve una instancia de un Video
  static Video fromJson(Map<String, dynamic> json) {
    return Video(
      id: json["id"],
      topic: json["topic"],
      description: json["description"],
      duration: json["duration"],
      thumbnail: json["thumbnail"],
    );
  }
}
