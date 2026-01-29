import 'package:blosteflix2/domain/repositories/catalogo_repository.dart';
import 'package:blosteflix2/infrastructure/dtos/paginated.dart';
import 'package:blosteflix2/domain/entities/video.dart';

class GetVideosUseCase {
  // Tambien admite una categoria por la cual filtrar.
  late final CatalogoRepository repository;

  GetVideosUseCase(this.repository);

  Future<Paginated<Video>> execute({
    required int page,
    required int size,
    int? categoriaId,
  }) {
    return repository.getVideos(
      page: page,
      size: size,
      categoriaId: categoriaId,
    );
  }
}