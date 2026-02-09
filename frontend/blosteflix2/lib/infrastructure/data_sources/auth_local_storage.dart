import 'package:blosteflix2/domain/entities/auth_tokens.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalStorage {
  static const _accessTokenKey = 'auth_access_token';
  static const _refreshTokenKey = 'auth_refresh_token';
  static const _expiresAtKey = 'auth_expires_at';

  final FlutterSecureStorage _storage;

  AuthLocalStorage(this._storage);

  Future<void> saveTokens(AuthTokens tokens) async {
    await _storage.write(key: _accessTokenKey, value: tokens.accessToken);
    await _storage.write(key: _refreshTokenKey, value: tokens.refreshToken);
    await _storage.write(key: _expiresAtKey, value: tokens.expiresAt.toString());
  }

  Future<AuthTokens?> readTokens() async {
    final accessToken = await _storage.read(key: _accessTokenKey);
    final refreshToken = await _storage.read(key: _refreshTokenKey);
    final expiresAtRaw = await _storage.read(key: _expiresAtKey);

    if (accessToken == null || refreshToken == null || expiresAtRaw == null) {
      return null;
    }

    final expiresAt = int.tryParse(expiresAtRaw);
    if (expiresAt == null) {
      return null;
    }

    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );
  }

  Future<void> clear() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _expiresAtKey);
  }
}
