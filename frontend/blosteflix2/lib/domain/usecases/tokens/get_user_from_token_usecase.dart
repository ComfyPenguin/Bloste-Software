import 'package:blosteflix2/core/errors/failure.dart';
import 'package:blosteflix2/domain/entities/usuario.dart';
import 'package:blosteflix2/domain/repositories/auth_repository.dart';
import 'package:dart_either/dart_either.dart';

class GetUserFromTokenUsecase {
  late final AuthRepository repository;

  GetUserFromTokenUsecase(this.repository);

  Future<Either<HttpFailure, Usuario>> execute(String accessToken) {
    return repository.getUserDetails(accessToken);
  }
  
}