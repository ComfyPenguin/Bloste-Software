import 'package:blosteflix2/core/errors/failure.dart';
import 'package:blosteflix2/domain/entities/auth_tokens.dart';
import 'package:blosteflix2/domain/repositories/auth_repository.dart';
import 'package:dart_either/dart_either.dart';

class RefreshTokenUsecase {
  late final AuthRepository repository;

  RefreshTokenUsecase(this.repository);

  Future<Either<HttpFailure,AuthTokens>> execute(String refreshToken) {
    return repository.refreshToken(refreshToken);
  }
}