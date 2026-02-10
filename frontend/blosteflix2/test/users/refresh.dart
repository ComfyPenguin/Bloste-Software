import 'package:blosteflix2/domain/entities/auth_tokens.dart';
import 'package:blosteflix2/infrastructure/data_sources/auth_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final api = AuthApi('http://localhost:8069');

  test('Hace login', () async {
  final result = await api.refreshToken("eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxNCIsImxvZ2luIjoiaiIsInJvbGUiOiJ1c2VyIiwiaWF0IjoxNzcwNjM4MjU4LCJleHAiOjE3NzEyNDMwNTgsInR5cGUiOiJyZWZyZXNoIn0.Ll5IgpWwtuw4oTvXecgwg1NiesKgGP7vlNfHvslMBT-DNldfxR5nIkMJuGrc8j6V56siPatFuRrIRVm6zG6dl_KVIbAM8ih_E3w7OF3tuQTeTZRiRFTXyN-fovLeySuJHvVAW0oKa4MV_g9XsPyGRsWgZ4IK_zrWnAL9hVKeY5ijDJAbK_JSKcHXkJZGwZcm25J8Qm16a6o2E0Lm57WUE41I_-F6TWhRFSWzjPSVK3q8gpUHkEVEtCtzrhlngC6P633oW1Lthx4POSMfX6scbxdy0REjoiGIaHGeo5J11YD_ljt8xg96AdK_Uqx4wKxmKEfBlamvjNocB-JOyQOPvw");

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