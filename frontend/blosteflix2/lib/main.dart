import 'package:blosteflix2/presentation/screens/auth/auth_gate.dart';
import 'package:blosteflix2/presentation/theming/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: Blosteflix()));
}

class Blosteflix extends StatelessWidget {
  const Blosteflix({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlosteFlix',
      debugShowCheckedModeBanner: false,
      theme: BlosteTheme.extraDarkTheme,
      home: const AuthGate(),
    );
  }
}
