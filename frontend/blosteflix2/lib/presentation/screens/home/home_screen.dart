import 'dart:ui';

import 'package:blosteflix2/presentation/screens/account/account_screen.dart';
import 'package:blosteflix2/presentation/screens/inicio/miniaturas_screen.dart';
import 'package:blosteflix2/presentation/screens/search/search_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  int _selectedIndex = 0;
  final List<String> _titles = ['Inicio', 'Buscar', 'Cuenta'];
  final GlobalKey<MiniaturasScreenState> _homeKey =
      GlobalKey<MiniaturasScreenState>();
  DateTime? _lastTapTime;
  int? _lastTapIndex;

  void _onItemTapped(int index) {
    final now = DateTime.now();
    final isDoubleTap =
        _lastTapIndex == index &&
        _lastTapTime != null &&
        now.difference(_lastTapTime!) <= const Duration(milliseconds: 350);

    _lastTapIndex = index;
    _lastTapTime = now;

    if (index == 0 && _selectedIndex == 0 && isDoubleTap) {
      _homeKey.currentState?.reloadVideos();
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.white.withOpacity(0.12), // ← color de superficie transparente
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/b_logo_white.png',
              height: 42, // un poco más grande para que destaque
            ),
            const SizedBox(width: 8,),
            Text(_titles[_selectedIndex],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            )
            
          ],
        ),
        flexibleSpace: ClipRRect(
          // ← importante para limitar el blur
          /* borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),  */// bordes redondeados abajo = más moderno
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX:
                  24, // ← ¡aquí exageramos! (normal es 10-15, 20-30 = muy intenso)
              sigmaY: 24, // simétrico para look uniforme
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  // gradiente dentro del vidrio = profundidad extra
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.12), // más opaco arriba
                    Colors.white.withOpacity(0.05), // casi invisible abajo
                  ],
                ),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(
                      0.25,
                    ), // borde más visible = más "cristal"
                    width: 1.2,
                  ),
                ),
                boxShadow: [
                  // sombra interna sutil para "profundidad de vidrio"
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    spreadRadius: -4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const SizedBox.expand(), // ocupa todo el espacio
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white70),
        actions: const [
          // IconButton(icon: Icon(Icons.cast), onPressed: () {}),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          MiniaturasScreen(key: _homeKey),// Inicio
          const SearchScreen(), // Buscar
          const AccountScreen(),   // Cuenta
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: ''),
          NavigationDestination(icon: Icon(Icons.search), label: ''),
          NavigationDestination(icon: Icon(Icons.person), label: '')
        ],
      )
    );
  }
}

