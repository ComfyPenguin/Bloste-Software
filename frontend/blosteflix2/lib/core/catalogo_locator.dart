import 'package:blosteflix2/domain/repositories/catalogo_repository.dart';
import 'package:blosteflix2/domain/usecases/categories/get_categories_id_usecase.dart';
import 'package:blosteflix2/domain/usecases/categories/get_categories_usecase.dart';
import 'package:blosteflix2/domain/usecases/videos/get_videos_id_usecase.dart';
import 'package:blosteflix2/domain/usecases/videos/get_videos_usecase.dart';
import 'package:blosteflix2/infrastructure/data_sources/catalogo_api.dart';
import 'package:blosteflix2/infrastructure/repository/catalogo_repository_impl.dart';

class CatalogoLocator {
  String remoteUrl = "http://10.146.48.159:8080";

  // Instància privada estàtica (Patró Singleton)
  static CatalogoLocator? _instancia;
  // Referencia al repositorio (clase abstracta)
  late CatalogoRepository _catalogoRepository;

  late final CatalogoApi _api;

  // Use cases
  late final GetVideosUseCase getVideosUseCase;
  late final GetVideosIdUsecase getVideosIdUsecase;
  late final GetCategoriesUsecase getCategoriesUsecase;
  late final GetCategoriesIdUsecase getCategoriesIdUsecase;

  factory CatalogoLocator() {
    _instancia ??= CatalogoLocator._();
    return _instancia!;
  }

  CatalogoLocator._() {
    _api = CatalogoApi(remoteUrl);

    _catalogoRepository = CatalogoRepositoryImpl(_api);

    getVideosUseCase = GetVideosUseCase(_catalogoRepository);
    getVideosIdUsecase = GetVideosIdUsecase(_catalogoRepository);
    getCategoriesUsecase = GetCategoriesUsecase(_catalogoRepository);
    getCategoriesIdUsecase = GetCategoriesIdUsecase(_catalogoRepository);
  }

  String getRemoteURL() => remoteUrl;
}
