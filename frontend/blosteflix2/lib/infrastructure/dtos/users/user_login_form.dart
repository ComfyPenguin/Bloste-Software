class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  // Post body
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}