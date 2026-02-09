import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:blosteflix2/core/errors/failure.dart';
import 'package:blosteflix2/domain/entities/auth_tokens.dart';
import 'package:blosteflix2/domain/entities/usuario.dart';
import 'package:blosteflix2/infrastructure/mappers/auth_mapper.dart';
import 'package:blosteflix2/infrastructure/mappers/user_mapper.dart';
import 'package:dart_either/dart_either.dart';
import 'package:http/http.dart' as http;


class AuthApi {

  String urlBase;

  AuthApi(this.urlBase);

  // Either a la izquierda el valor "malo" y a la derecha el valor "bueno"

  Future<Either<HttpFailure, AuthTokens>> login(String email, String password) async {
    try {
      // Hacer peticion
      final http.Response data = await http.post(
        Uri.parse('$urlBase/api/auth/token'),
        //Montar cuerpo de peticion
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'login': email.trim(), //Trim -> Elimina espacios delante y detras del email
          'password': password,
        }),
      ).timeout(const Duration(seconds: 12));

      // A partir de aqui data tiene la informacion con la respuesta del backend

      if(data.statusCode == HttpStatus.ok){
        final body = utf8.decode(data.bodyBytes);
        final jsonData = jsonDecode(body) as Map<String, dynamic>;
        return Right(AuthMapper.fromJson(jsonData));
      } else {
        return Left(HttpFailure.fromStatusCode(data.statusCode));
      }
    } on SocketException {
      return Left(NetworkFailure(message: 'No se pudo conectar al servidor'));
    } on TimeoutException {
      return Left(NetworkFailure(message: 'La conexión expiró'));
    }
    
  }

  Future<Either<HttpFailure , AuthTokens>> signup(String user, String email, String password) async {
    try {
      final http.Response data = await http.post(
        Uri.parse('$urlBase/api/auth/register'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': user,
          'login': email,
          'password': password
        }),
      ).timeout(const Duration(seconds: 12));

      if(data.statusCode == HttpStatus.created){
        final body = utf8.decode(data.bodyBytes);
        final jsonData = jsonDecode(body) as Map<String, dynamic>;
        return Right(AuthMapper.fromJson(jsonData));
      } else {
        return Left(HttpFailure.fromStatusCode(data.statusCode));
      }
    } on SocketException {
      return Left(NetworkFailure(message: 'No se pudo conectar al servidor'));
    } on TimeoutException {
      return Left(NetworkFailure(message: 'La conexión expiró'));
    }
  }

  Future<Either<HttpFailure , AuthTokens>> refreshToken(String token) async {
    try {
      final http.Response data = await http.post(
        Uri.parse('$urlBase/api/auth/refresh'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'token': token,
        }),
      ).timeout(const Duration(seconds: 12));

      if(data.statusCode == HttpStatus.ok){
        final body = utf8.decode(data.bodyBytes);
        final jsonData = jsonDecode(body) as Map<String, dynamic>;
        return Right(AuthMapper.fromJson(jsonData));
      } else {
        return Left(HttpFailure.fromStatusCode(data.statusCode));
      }
    } on SocketException {
      return Left(NetworkFailure(message: 'No se pudo conectar al servidor'));
    } on TimeoutException {
      return Left(NetworkFailure(message: 'La conexión expiró'));
    }
  }

  Future<Either<HttpFailure , Usuario>> getUserDetails(String accessToken) async {
    try {
      final http.Response data = await http.get(
        Uri.parse('$urlBase/api/users/me'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 12));

      if(data.statusCode == HttpStatus.ok){
        final body = utf8.decode(data.bodyBytes);
        final jsonData = jsonDecode(body) as Map<String, dynamic>;
        return Right(UserMapper.fromJson(jsonData));
      } else {
        return Left(HttpFailure.fromStatusCode(data.statusCode));
      }
    } on SocketException {
      return Left(NetworkFailure(message: 'No se pudo conectar al servidor'));
    } on TimeoutException {
      return Left(NetworkFailure(message: 'La conexión expiró'));
    }
  }

}