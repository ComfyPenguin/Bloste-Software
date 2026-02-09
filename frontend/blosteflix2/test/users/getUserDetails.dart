import 'package:blosteflix2/domain/entities/auth_tokens.dart';
import 'package:blosteflix2/domain/entities/usuario.dart';
import 'package:blosteflix2/infrastructure/data_sources/auth_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final api = AuthApi('http://localhost:8069');

  test('Datos usuario a partir de token', () async {
  final result = await api.getUserDetails("eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5IiwibG9naW4iOiJkIiwicm9sZSI6InVzZXIiLCJpYXQiOjE3NzA2MzU4NjQsImV4cCI6MTc3MDYzOTQ2NCwidHlwZSI6ImFjY2VzcyJ9.MaHwcYYwFcd-aw2IAi6RhUk-7kxSTB8oHZY8scYUVzAA3L0UG60pLzkcs2ICmQuu5Rdq9aPlEWkcV6EhW_ULQBO5q7gJ4MEZ_DMt_8lgbnZok_StJ9-LxQJEKfA4-LK7rC1uwUgkeJE8sfPPLxQuWkVRtxkHZdVH_AbKYXUNZwNUYCjomqujco1ZpH3nljUY4N4ghR5kYPzCuvD7nftnbhfb76TXEXTYZyF3lo7Dv8viz8V_8a-J6lkRZJht47niDnb93_3-MtbFq7Gge9R9I99fL7OYZ1zm5U5UzlXlKZxHVISe5ZOFOYK5c67fLCpaN-998hElTcaKUqdoaG_eFQ");

  // Verificamos que sea Right
  expect(result.isRight, true);

  // Extraemos el valor del Right (falla el test si era Left)
  final usuario = result.getOrElse(() => throw Exception('Se esperaba Right pero llegó Left'));

  // Ahora sí podemos comparar con AuthTokens
  expect(usuario, isA<Usuario>());

  // Opcional: pruebas más específicas
  expect(usuario.email, isNotEmpty);
  expect(usuario.name, isNotNull);

  print('--- Tokens Recibidos ---');
  print(usuario.toString());
});
}