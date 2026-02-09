import 'package:blosteflix2/core/errors/failure.dart';
import 'package:blosteflix2/domain/entities/auth_tokens.dart';
import 'package:blosteflix2/domain/repositories/auth_repository.dart';
import 'package:dart_either/dart_either.dart';

class LoginUsecase {
  late final AuthRepository repository;

  LoginUsecase(this.repository);

  Future<Either<HttpFailure, AuthTokens>> execute({
    required String email, required String password
    }) {
      return repository.login(email, password);
    }
  
}