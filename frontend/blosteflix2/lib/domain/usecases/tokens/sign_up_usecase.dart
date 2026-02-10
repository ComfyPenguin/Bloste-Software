import 'package:blosteflix2/core/errors/failure.dart';
import 'package:blosteflix2/domain/entities/auth_tokens.dart';
import 'package:blosteflix2/domain/repositories/auth_repository.dart';
import 'package:dart_either/dart_either.dart';

class SignUpUsecase {
  late final AuthRepository repository;

  SignUpUsecase(this.repository);

  Future<Either<HttpFailure,AuthTokens>> execute({
    required String name, required String email, required String password
    }) {
      return repository.signup(name, email, password);
    }
}