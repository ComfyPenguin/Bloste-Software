import 'package:blosteflix2/domain/entities/categoria.dart';
import 'package:blosteflix2/domain/repositories/catalogo_repository.dart';
import 'package:blosteflix2/infrastructure/dtos/paginated.dart';

class GetCategoriesUsecase {
    late final CatalogoRepository repository;

    GetCategoriesUsecase(this.repository);

    Future<Paginated<Categoria>> execute({
        required int page,
        required int size,
    }) {
        return repository.getCategorias(
            page: page,
            size: size,
        );
    }

}