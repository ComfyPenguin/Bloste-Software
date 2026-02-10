import 'package:blosteflix2/domain/entities/usuario.dart';

class UserMapper {
  static Usuario fromJson(Map<String, dynamic> json) {
    return Usuario(
      name: json['name'],
      email: json['email'],
    );
  }
}