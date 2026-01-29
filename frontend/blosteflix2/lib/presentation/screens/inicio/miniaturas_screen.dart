import 'package:blosteflix2/domain/entities/categoria.dart';
import 'package:blosteflix2/presentation/widgets/categoria_slider.dart';
import 'package:blosteflix2/presentation/widgets/grid_videos.dart';
import 'package:flutter/material.dart';

class MiniaturasScreen extends StatefulWidget {
  const MiniaturasScreen({super.key});

  @override
  State<MiniaturasScreen> createState() => _MiniaturasScreenState();
}

class _MiniaturasScreenState extends State<MiniaturasScreen> {
  Categoria? _categoriaSeleccionada; // null = "Todo"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. El slider de categorías (se desplaza con el contenido)
          SliverPersistentHeader(
            floating: true,     // aparece al subir aunque no esté pinned
            pinned: false,      // NO se queda fijo arriba
            delegate: _CategoriaHeaderDelegate(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CategoriaSlider(
                  onCategoriaChanged: (nuevaCategoria) {
                    setState(() {
                      _categoriaSeleccionada = nuevaCategoria;
                    });
                  },
                ),
              ),
            ),
          ),

          // 2. Espacio opcional o divider si quieres separación visual
          // SliverToBoxAdapter(
          //   child: Divider(height: 1, thickness: 1),
          // ),

          // 3. El contenido principal (grid de videos)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: GridVideos(
              categoriaSeleccionada: _categoriaSeleccionada,
            ),
          ),
        ],
      ),
    );
  }
}

// Delegate necesario para SliverPersistentHeader
class _CategoriaHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _CategoriaHeaderDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 66;   // altura del slider + padding vertical

  @override
  double get minExtent => 66;

  @override
  bool shouldRebuild(covariant _CategoriaHeaderDelegate oldDelegate) {
    return false;
  }
}