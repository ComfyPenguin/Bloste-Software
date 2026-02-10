class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final int expiresAt;
  
  AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  bool get isAccessExpired => expiresAt < DateTime.now().millisecondsSinceEpoch;

  @override
  String toString() => 'AuthTokens(accessToken: $accessToken, refreshToken: $refreshToken, expiresAt: $expiresAt)';
}