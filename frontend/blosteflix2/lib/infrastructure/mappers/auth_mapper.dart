import 'package:blosteflix2/domain/entities/auth_tokens.dart';

class AuthMapper {
  static AuthTokens fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      expiresAt: json['expires_in']
    );
  }
}