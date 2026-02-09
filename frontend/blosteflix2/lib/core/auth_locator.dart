import 'package:blosteflix2/domain/repositories/auth_repository.dart';
import 'package:blosteflix2/domain/usecases/tokens/get_user_from_token_usecase.dart';
import 'package:blosteflix2/domain/usecases/tokens/login_usecase.dart';
import 'package:blosteflix2/domain/usecases/tokens/refresh_token_usecase.dart';
import 'package:blosteflix2/domain/usecases/tokens/sign_up_usecase.dart';
import 'package:blosteflix2/infrastructure/data_sources/auth_api.dart';
import 'package:blosteflix2/infrastructure/repository/auth_repository_impl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthLocator {
  late String remoteUrl;

  static AuthLocator? _instancia;

  late AuthRepository _authRepository;

  late final AuthApi _api;

  //Use cases
  late final GetUserFromTokenUsecase getUserFromTokenUsecase;
  late final SignUpUsecase signUpUsecase;
  late final RefreshTokenUsecase refreshTokenUsecase;
  late final LoginUsecase loginUsecase;

  factory AuthLocator() {
    _instancia ??= AuthLocator._();
    return _instancia!;
  }

  AuthLocator._() {
    remoteUrl = dotenv.env['AUTH_URL'] ?? 'http://localhost:8069';
    _api = AuthApi(remoteUrl);
    _authRepository = AuthRepositoryImpl(_api);
    getUserFromTokenUsecase = GetUserFromTokenUsecase(_authRepository);
    signUpUsecase = SignUpUsecase(_authRepository);
    refreshTokenUsecase = RefreshTokenUsecase(_authRepository);
    loginUsecase = LoginUsecase(_authRepository);
  }

  String getRemoteURL() => remoteUrl;
}
