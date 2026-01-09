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
    // Inicialización del repositorio
    final api = VideosApi("http://10.0.2.2:3000/api/videolist");

    // Inyección de dependencias
    repo = VideosRepositoryImpl(api);
  }
}
