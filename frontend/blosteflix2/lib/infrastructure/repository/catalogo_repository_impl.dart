import 'package:blosteflix2/domain/entities/categoria.dart';
import 'package:blosteflix2/domain/entities/video.dart';
import 'package:blosteflix2/domain/repositories/catalogo_repository.dart';
import 'package:blosteflix2/infrastructure/data_sources/catalogo_api.dart';
import 'package:blosteflix2/infrastructure/dtos/extra/paginated.dart';

class CatalogoRepositoryImpl extends CatalogoRepository{

  final CatalogoApi remote;

  CatalogoRepositoryImpl(this.remote);
  
  @override
  Future<Paginated<Video>> getVideos({required int page, required int size, int? categoriaId}) {
    return remote.getVideos(page: page, size: size, categoriaId: categoriaId);
  }

  @override
  Future<Paginated<Video>> searchVideos({
    required String titulo,
    required int page,
    required int size,
  }) {
    return remote.searchVideos(titulo: titulo, page: page, size: size);
  }

  @override
  Future<Video?> getById(int id) async {
    return remote.getVideosID(id);
  }

  @override
  Future<Paginated<Categoria>> getCategorias({required int page, required int size}) {
    return remote.getCategorias(page: page, size: size);
  }

  @override
  Future<Categoria> getCategoriasById(int id) {
    return remote.getCategoriaById(id);
  }
}