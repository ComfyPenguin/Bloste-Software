import 'package:blosteflix2/domain/entities/auth_tokens.dart';
import 'package:blosteflix2/infrastructure/data_sources/auth_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final api = AuthApi('http://localhost:8069');

  test('Hace login', () async {
  final result = await api.login("d", "d");

  // Verificamos que sea Right
  expect(result.isRight, true);

  // Extraemos el valor del Right (falla el test si era Left)
  final tokens = result.getOrElse(() => throw Exception('Se esperaba Right pero llegó Left'));

  // Ahora sí podemos comparar con AuthTokens
  expect(tokens, isA<AuthTokens>());

  // Opcional: pruebas más específicas
  expect(tokens.accessToken, isNotEmpty);
  expect(tokens.refreshToken, isNotNull);

  print('--- Tokens Recibidos ---');
  print(tokens.toString());
});
}