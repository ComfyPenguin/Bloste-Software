import 'package:blosteflix2/domain/entities/categoria.dart';
import 'package:blosteflix2/domain/entities/video.dart';
import 'package:blosteflix2/infrastructure/dtos/paginated.dart';

abstract class CatalogoRepository {

  Future<Paginated<Video>> getVideos({
    required int page,
    required int size,
    int? categoriaId,
  });

  Future<Video?> getById(int id);

  Future<Paginated<Categoria>> getCategorias({
    required int page,
    required int size,
  });

  Future<Categoria> getCategoriasById(int id);
}