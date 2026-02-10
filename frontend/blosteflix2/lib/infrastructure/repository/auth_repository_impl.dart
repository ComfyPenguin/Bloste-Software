import 'package:blosteflix2/core/errors/failure.dart';
import 'package:blosteflix2/domain/entities/auth_tokens.dart';
import 'package:blosteflix2/domain/entities/usuario.dart';
import 'package:blosteflix2/domain/repositories/auth_repository.dart';
import 'package:blosteflix2/infrastructure/data_sources/auth_api.dart';
import 'package:dart_either/src/dart_either.dart';

class AuthRepositoryImpl extends AuthRepository {

  final AuthApi remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<Either<HttpFailure, Usuario>> getUserDetails(String accessToken) {
    return remote.getUserDetails(accessToken);
  }

  @override
  Future<Either<HttpFailure, AuthTokens>> login(String email, String password) {
    return remote.login(email, password);
  }

  @override
  Future<Either<HttpFailure, AuthTokens>> refreshToken(String refreshToken) {
    return remote.refreshToken(refreshToken);
  }

  @override
  Future<Either<HttpFailure, AuthTokens>> signup(String name, String email, String password) {
    return remote.signup(name, email, password);
  }
  
}