import 'package:blosteflix2/core/auth_locator.dart';
import 'package:blosteflix2/domain/entities/auth_tokens.dart';
import 'package:blosteflix2/domain/usecases/tokens/get_user_from_token_usecase.dart';
import 'package:blosteflix2/domain/usecases/tokens/login_usecase.dart';
import 'package:blosteflix2/domain/usecases/tokens/refresh_token_usecase.dart';
import 'package:blosteflix2/domain/usecases/tokens/sign_up_usecase.dart';
import 'package:blosteflix2/infrastructure/data_sources/auth_local_storage.dart';
import 'package:blosteflix2/presentation/providers/auth_state.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authLocatorProvider = Provider<AuthLocator>((ref) => AuthLocator());

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

final authLocalStorageProvider = Provider<AuthLocalStorage>(
  (ref) => AuthLocalStorage(ref.watch(secureStorageProvider)),
);

final loginUsecaseProvider = Provider<LoginUsecase>(
  (ref) => ref.watch(authLocatorProvider).loginUsecase,
);

final signUpUsecaseProvider = Provider<SignUpUsecase>(
  (ref) => ref.watch(authLocatorProvider).signUpUsecase,
);

final refreshTokenUsecaseProvider = Provider<RefreshTokenUsecase>(
  (ref) => ref.watch(authLocatorProvider).refreshTokenUsecase,
);

final getUserFromTokenUsecaseProvider = Provider<GetUserFromTokenUsecase>(
  (ref) => ref.watch(authLocatorProvider).getUserFromTokenUsecase,
);

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(
    loginUsecase: ref.watch(loginUsecaseProvider),
    signUpUsecase: ref.watch(signUpUsecaseProvider),
    refreshTokenUsecase: ref.watch(refreshTokenUsecaseProvider),
    getUserFromTokenUsecase: ref.watch(getUserFromTokenUsecaseProvider),
    localStorage: ref.watch(authLocalStorageProvider),
  ),
);

class AuthController extends StateNotifier<AuthState> {
  final LoginUsecase _loginUsecase;
  final SignUpUsecase _signUpUsecase;
  final RefreshTokenUsecase _refreshTokenUsecase;
  final GetUserFromTokenUsecase _getUserFromTokenUsecase;
  final AuthLocalStorage _localStorage;

  AuthController({
    required LoginUsecase loginUsecase,
    required SignUpUsecase signUpUsecase,
    required RefreshTokenUsecase refreshTokenUsecase,
    required GetUserFromTokenUsecase getUserFromTokenUsecase,
    required AuthLocalStorage localStorage,
  })  : _loginUsecase = loginUsecase,
        _signUpUsecase = signUpUsecase,
        _refreshTokenUsecase = refreshTokenUsecase,
        _getUserFromTokenUsecase = getUserFromTokenUsecase,
        _localStorage = localStorage,
        super(const AuthState.unauthenticated());

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading, clearError: true);
    final result = await _loginUsecase.execute(email: email, password: password);
    await result.fold<Future<void>>(
      ifLeft: (failure) {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: failure.message,
        );
        return Future.value();
      },
      ifRight: (tokens) async => _handleTokens(tokens),
    );
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, clearError: true);
    final result = await _signUpUsecase.execute(
      name: name,
      email: email,
      password: password,
    );
    await result.fold<Future<void>>(
      ifLeft: (failure) {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: failure.message,
        );
        return Future.value();
      },
      ifRight: (tokens) async => _handleTokens(tokens),
    );
  }

  Future<void> restoreSession() async {
    if (state.status == AuthStatus.loading) {
      return;
    }
    state = state.copyWith(status: AuthStatus.loading, clearError: true);
    final storedTokens = await _localStorage.readTokens();
    if (storedTokens == null) {
      state = const AuthState.unauthenticated();
      return;
    }

    if (storedTokens.isAccessExpired) {
      final result = await _refreshTokenUsecase.execute(storedTokens.refreshToken);
      await result.fold<Future<void>>(
        ifLeft: (failure) async {
          await _localStorage.clear();
          state = const AuthState.unauthenticated();
        },
        ifRight: (newTokens) async => _handleTokens(newTokens),
      );
      return;
    }

    await _handleTokens(storedTokens);
  }

  Future<void> refreshSession() async {
    final tokens = state.tokens;
    if (tokens == null) {
      return;
    }
    state = state.copyWith(status: AuthStatus.loading, clearError: true);
    final result = await _refreshTokenUsecase.execute(tokens.refreshToken);
    await result.fold<Future<void>>(
      ifLeft: (failure) async {
        await _localStorage.clear();
        state = const AuthState.unauthenticated();
      },
      ifRight: (newTokens) async => _handleTokens(newTokens),
    );
  }

  Future<void> refreshUserDetails() async {
    final tokens = state.tokens;
    if (tokens == null) {
      return;
    }

    final previousState = state;
    state = state.copyWith(status: AuthStatus.authenticated, clearError: true);
    final userResult = await _getUserFromTokenUsecase.execute(tokens.accessToken);
    await userResult.fold<Future<void>>(
      ifLeft: (failure) {
        state = previousState.copyWith(
          status: AuthStatus.authenticated,
          errorMessage: failure.message,
        );
        return Future.value();
      },
      ifRight: (user) {
        state = previousState.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          tokens: tokens,
          errorMessage: null,
        );
        return Future.value();
      },
    );
  }

  Future<void> logout() async {
    await _localStorage.clear();
    state = const AuthState.unauthenticated();
  }

  Future<void> _handleTokens(AuthTokens tokens) async {
    await _localStorage.saveTokens(tokens);
    final userResult = await _getUserFromTokenUsecase.execute(tokens.accessToken);
    await userResult.fold<Future<void>>(
      ifLeft: (failure) {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          tokens: tokens,
          errorMessage: failure.message,
        );
        return Future.value();
      },
      ifRight: (user) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          tokens: tokens,
          errorMessage: null,
        );
        return Future.value();
      },
    );
  }
}
