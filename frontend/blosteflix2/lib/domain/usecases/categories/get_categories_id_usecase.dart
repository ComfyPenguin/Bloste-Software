import 'package:blosteflix2/domain/entities/categoria.dart';
import 'package:blosteflix2/domain/repositories/catalogo_repository.dart';


class GetCategoriesIdUsecase {
  late final CatalogoRepository repository;

  GetCategoriesIdUsecase(this.repository);

  Future<Categoria?> execute({
    required int id,
  }) {
    return repository.getCategoriasById(id);
  }
}