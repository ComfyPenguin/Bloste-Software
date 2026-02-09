import 'package:blosteflix2/presentation/screens/home/home_screen.dart';
import 'package:blosteflix2/presentation/theming/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const Blosteflix());
}

class Blosteflix extends StatelessWidget {
  const Blosteflix({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlosteFlix',
      debugShowCheckedModeBanner: false,
      theme: BlosteTheme.extraDarkTheme,
      home: const HomeScreen(),
    );
  }
}
