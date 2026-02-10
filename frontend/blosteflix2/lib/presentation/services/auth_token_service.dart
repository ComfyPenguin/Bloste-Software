import 'package:blosteflix2/infrastructure/data_sources/auth_local_storage.dart';

// Servicio para obtener el token de autenticación del almacenamiento local
class AuthTokenService {
  final AuthLocalStorage _authLocalStorage;

  AuthTokenService(this._authLocalStorage);

  // Obtiene el token de acceso almacenado localmente
  Future<String?> getAccessToken() async {
    final tokens = await _authLocalStorage.readTokens();
    return tokens?.accessToken;
  }

  // Obtiene el header Authorization con el Bearer token
  Future<String?> getAuthorizationHeader() async {
    final token = await getAccessToken();
    if (token != null) {
      return 'Bearer $token';
    }
    return null;
  }
}
