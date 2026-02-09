import 'package:blosteflix2/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLogin = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isLogin) {
      await ref.read(authControllerProvider.notifier).login(
            email: _emailController.text,
            password: _passwordController.text,
          );
    } else {
      await ref.read(authControllerProvider.notifier).signup(
            name: _nameController.text,
            email: _emailController.text,
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF050505),
              Color(0xFF0E0E0E),
              Color(0xFF141414),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    Image.asset(
                      'assets/images/blosteflix_white.png',
                      height: 64,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _isLogin
                          ? 'Inicia sesión para continuar'
                          : 'Crea una cuenta en minutos',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 14,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF121212),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.45),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AnimatedCrossFade(
                              duration: const Duration(milliseconds: 250),
                              crossFadeState: _isLogin
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              firstChild: const SizedBox.shrink(),
                              secondChild: Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: TextFormField(
                                  controller: _nameController,
                                  textInputAction: TextInputAction.next,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _inputDecoration(
                                    label: 'Nombre',
                                    icon: Icons.person_outline,
                                  ),
                                  validator: (value) {
                                    if (!_isLogin && (value == null || value.trim().isEmpty)) {
                                      return 'Introduce tu nombre';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration(
                                label: 'Email',
                                icon: Icons.email_outlined,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Introduce tu email';
                                }
                                if (!value.contains('@')) {
                                  return 'Email no válido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration(
                                label: 'Contraseña',
                                icon: Icons.lock_outline,
                                suffix: IconButton(
                                  onPressed: () {
                                    setState(() => _obscurePassword = !_obscurePassword);
                                  },
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.length < 6) {
                                  return 'Mínimo 6 caracteres';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) => _submit(),
                            ),
                            if (authState.errorMessage != null) ...[
                              const SizedBox(height: 16),
                              Text(
                                authState.errorMessage!,
                                style: TextStyle(
                                  color: Colors.redAccent.shade100,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: authState.isLoading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                backgroundColor: const Color(0xFFF37A1F),
                                disabledBackgroundColor: const Color(0xFF7B3D0B),
                              ),
                              child: authState.isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Text(
                                      _isLogin ? 'Entrar' : 'Crear cuenta',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: authState.isLoading
                                  ? null
                                  : () {
                                      setState(() => _isLogin = !_isLogin);
                                    },
                              child: Text(
                                _isLogin
                                    ? '¿No tienes cuenta? Regístrate'
                                    : '¿Ya tienes cuenta? Inicia sesión',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.75)),
      prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.75)),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFF1A1A1A),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFF37A1F), width: 1.2),
      ),
    );
  }
}
