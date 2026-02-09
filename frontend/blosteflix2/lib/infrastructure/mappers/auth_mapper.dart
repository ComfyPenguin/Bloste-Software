import 'package:blosteflix2/domain/entities/auth_tokens.dart';

class AuthMapper {
  static AuthTokens fromJson(Map<String, dynamic> json) {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final expiresIn = json['expires_in'];
    final expiresAtRaw = json['expires_at'] ?? json['expiresAt'];

    int? expiresAt;
    if (expiresIn is int) {
      expiresAt = nowMs + (expiresIn * 1000);
    } else if (expiresIn is String) {
      final parsed = int.tryParse(expiresIn);
      if (parsed != null) {
        expiresAt = nowMs + (parsed * 1000);
      }
    } else if (expiresAtRaw is int) {
      expiresAt = expiresAtRaw < 1000000000000 ? expiresAtRaw * 1000 : expiresAtRaw;
    } else if (expiresAtRaw is String) {
      final parsed = int.tryParse(expiresAtRaw);
      if (parsed != null) {
        expiresAt = parsed < 1000000000000 ? parsed * 1000 : parsed;
      }
    }

    return AuthTokens(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      expiresAt: expiresAt ?? nowMs,
    );
  }
}