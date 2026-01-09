// Parte de infraestructura del repositorio
// Implementa las funcionalidades de la clase abstracta ComarquesRepository

import 'package:flutter/widgets.dart';
import 'package:frontend/domain/entities/video.dart';
import 'package:frontend/domain/repositories/video_repository.dart';
import 'package:frontend/infrastructure/data_sources/videos_api.dart';
import 'package:frontend/infrastructure/mappers/video_mapper.dart';

class VideosRepositoryImpl implements VideosRepository {
  // Referencia a la API remota
  final VideosApi remote;
  // La API se inicializa en el constructor
  VideosRepositoryImpl(this.remote);

  // Obtiene una lista de todos los vídeos
  @override
  Future<List<Video>> getVideos() async {
    try {
      debugPrint("************");
      final jsonVideos = await remote.getVideos();
      debugPrint(jsonVideos.toString());
      return jsonVideos
          .map((videoJSON) => VideoMapper.fromJson(videoJSON))
          .toList();
    } catch (e) {
      debugPrint("\x1B[31mError al recuperar vídeos: $e\x1B[0m");
      return [];
    }
  }

  // Obtiene una lista de videos por topic
  @override
  Future<List<Video>> getVideosByTopic(String topic) async {
    try {
      final jsonVideos = await remote.getVideosByTopic(topic);
      return jsonVideos
          .map((videoJSON) => VideoMapper.fromJson(videoJSON))
          .toList();
    } catch (e) {
      print("\x1B[31mError al recuperar vídeos por topic: $e\x1B[0m");
      return [];
    }
  }

  // Obtiene información sobre un vídeo en concreto
  @override
  Future<Video?> getVideoById(String id) async {
    try {
      final jsonVideos = await remote.getVideoById(id);
      return VideoMapper.fromJson(jsonVideos);
    } catch (e) {
      print("\x1B[31mError al recuperar la información del vídeo: $e\x1B[0m");
      return null;
    }
  }
}
