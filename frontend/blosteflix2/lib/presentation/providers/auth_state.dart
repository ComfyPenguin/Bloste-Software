import 'package:blosteflix2/domain/entities/auth_tokens.dart';
import 'package:blosteflix2/domain/entities/usuario.dart';

enum AuthStatus { unauthenticated, authenticated, loading }

class AuthState {
  final AuthStatus status;
  final Usuario? user;
  final AuthTokens? tokens;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.user,
    this.tokens,
    this.errorMessage,
  });

  const AuthState.unauthenticated()
      : status = AuthStatus.unauthenticated,
        user = null,
        tokens = null,
        errorMessage = null;

  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    Usuario? user,
    AuthTokens? tokens,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      tokens: tokens ?? this.tokens,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
