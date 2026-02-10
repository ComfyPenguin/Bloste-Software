import 'package:blosteflix2/presentation/providers/auth_providers.dart';
import 'package:blosteflix2/presentation/providers/auth_state.dart';
import 'package:blosteflix2/presentation/screens/auth/auth_screen.dart';
import 'package:blosteflix2/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  bool _didRestore = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didRestore) {
      _didRestore = true;
      Future.microtask(() => ref.read(authControllerProvider.notifier).restoreSession());
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    if (authState.status == AuthStatus.loading && !authState.isAuthenticated) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (authState.isAuthenticated) {
      return const HomeScreen();
    }

    return const AuthScreen();
  }
}
