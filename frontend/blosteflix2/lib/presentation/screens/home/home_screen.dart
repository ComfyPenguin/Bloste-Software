import 'package:blosteflix2/presentation/screens/inicio/miniaturas_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Image(image: AssetImage('assets/images/blosteflix_white.png')),
      ),
      body: MiniaturasScreen()
    );
  }
}

