import 'package:blosteflix2/domain/entities/categoria.dart';
import 'package:blosteflix2/infrastructure/data_sources/catalogo_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final api = CatalogoApi('http://localhost:8080');

  test('Devuelve categorias paginadas', () async {
    final result = await api.getCategorias(page: 0, size: 10);

    expect(result.content.isNotEmpty, true);
    expect(result.page, 0);
    expect(result.size, 10);
    expect(result.content.first, isA<Categoria>());

    print('--- CATEGORIAS RECIBIDAS ---');
    for (final categoria in result.content) {
      print(categoria.toString());
    }
  });
}