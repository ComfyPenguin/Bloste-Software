import 'package:blosteflix2/core/catalogo_locator.dart';
import 'package:blosteflix2/presentation/screens/home/home_screen.dart';
import 'package:blosteflix2/presentation/screens/videos/videos_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  CatalogoLocator(); // inicializa todo

  runApp(const BlosteflixApp());
}

class BlosteflixApp extends StatelessWidget {
  const BlosteflixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlosteFlix',
      debugShowCheckedModeBanner: false,
      home: HomeScreenWrapper(),
    );
  }
}

class HomeScreenWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final useCase = CatalogoLocator().getVideosUseCase;
    return ChangeNotifierProvider(
      create: (_) => VideosController(useCase)..loadNextPage(),
      child: const HomeScreen(),
    );
  }
}