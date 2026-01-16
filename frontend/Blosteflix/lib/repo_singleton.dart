import 'package:flutter/foundation.dart';
import 'package:frontend/domain/repositories/video_repository.dart';
import 'package:frontend/infrastructure/data_sources/videos_api.dart';
import 'package:frontend/infrastructure/repository/videos_repository_impl.dart';

class RepoSingleton {
  // Instancia privada estática
  static RepoSingleton? _instancia;

  // Referencia al repositorio
  late VideosRepository repo;

  // Constructor de factory:
  factory RepoSingleton() {
    _instancia ??= RepoSingleton._();
    return _instancia!;
  }

  RepoSingleton._() {
    // ============================================
    // DEVELOPMENT vs PRODUCTION
    // ============================================
    // Use mock data in development (when running from IDE or debug mode)
    // Use real API in production
    // Production: Use real API
    final api = VideosApi("http://localhost:8080/api/catalogo");
    repo = VideosRepositoryImpl(api);
    debugPrint('🚀 Using REAL API for production');
  }
}
