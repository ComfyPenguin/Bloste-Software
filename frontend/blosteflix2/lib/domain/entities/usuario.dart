class Usuario {
  String name;
  String email;
  bool isLoggedIn;

  Usuario({
    required this.name,
    required this.email,
    this.isLoggedIn = false,
  });

  @override
  String toString() {
    return 'Usuario{name: $name, email: $email, isLoggedIn: $isLoggedIn}';
  }
}