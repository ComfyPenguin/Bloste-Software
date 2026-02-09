import 'package:blosteflix2/core/errors/failure.dart';
import 'package:blosteflix2/domain/entities/auth_tokens.dart';
import 'package:blosteflix2/domain/entities/usuario.dart';
import 'package:dart_either/dart_either.dart';

abstract class AuthRepository {

 Future<Either<HttpFailure, AuthTokens>> login(String email, String password);
 Future<Either<HttpFailure, AuthTokens>> signup(String name, String email, String password);
 Future<Either<HttpFailure, AuthTokens>> refreshToken(String refreshToken);
 Future<Either<HttpFailure, Usuario>> getUserDetails(String accessToken);

}