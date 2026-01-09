import 'package:flutter/foundation.dart';
import 'package:frontend/domain/repositories/video_repository.dart';
import 'package:frontend/infrastructure/data_sources/videos_api.dart';
import 'package:frontend/infrastructure/repository/videos_repository_impl.dart';
import 'package:frontend/infrastructure/repository/mock_videos_repository.dart';

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
    if (kDebugMode) {
      // Development: Use mock repository with sample data
      repo = MockVideosRepository();
      debugPrint('🧪 Using MOCK repository for development');
    } else {
      // Production: Use real API
      final api = VideosApi("http://10.0.2.2:3000/api/videolist");
      repo = VideosRepositoryImpl(api);
      debugPrint('🚀 Using REAL API for production');
    }
  }
}
