
import 'package:blosteflix2/domain/entities/categoria.dart';
import 'package:blosteflix2/infrastructure/data_sources/catalogo_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final api = CatalogoApi('http://10.0.2.2:8080');

  test('Devuelve 1 categoria', () async {
    final result = await api.getCategoriaById(1); // Cambiar id para conseguir otra entrada de la api

    expect(result, isA<Categoria>());

    print('--- CATEGORIA RECIBIDA ---');
    print(result.toString());
  });
}