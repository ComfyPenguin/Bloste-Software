import 'package:blosteflix2/domain/entities/video.dart';
import 'package:blosteflix2/domain/repositories/catalogo_repository.dart';

class GetVideosIdUsecase {
  late final CatalogoRepository repository;

  GetVideosIdUsecase(this.repository);

  Future<Video?> execute({
    required int id,
  }) {
    return repository.getById(id);
  }
}