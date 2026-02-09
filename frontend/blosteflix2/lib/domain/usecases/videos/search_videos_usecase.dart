import 'package:blosteflix2/domain/entities/video.dart';
import 'package:blosteflix2/domain/repositories/catalogo_repository.dart';
import 'package:blosteflix2/infrastructure/dtos/extra/paginated.dart';

class SearchVideosUsecase {
  late final CatalogoRepository repository;

  SearchVideosUsecase(this.repository);

  Future<Paginated<Video>> execute({
    required String titulo,
    required int page,
    required int size,
  }) {
    return repository.searchVideos(
      titulo: titulo,
      page: page,
      size: size,
    );
  }
}
