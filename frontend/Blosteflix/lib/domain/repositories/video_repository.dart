import 'package:frontend/domain/entities/video.dart';

abstract class VideosRepository {
  // Obtiene información de una lista de videos
  Future<List<Video>> getVideos();

  // Obtiene información de una lista de videos por topic
  Future<List<Video>> getVideosByTopic(String topic);

  // Obtiene información de un video en concreto
  Future<Video?> getVideoById(String id);
}
