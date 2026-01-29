import 'package:blosteflix2/core/catalogo_locator.dart';
import 'package:blosteflix2/domain/entities/categoria.dart';
import 'package:flutter/material.dart';
import 'categoria_blob.dart';

class CategoriaSlider extends StatefulWidget {
  final ValueChanged<Categoria>? onCategoriaChanged;

  const CategoriaSlider({
    super.key,
    this.onCategoriaChanged,
  });

  @override
  State<CategoriaSlider> createState() => _CategoriaSliderState();
}

class _CategoriaSliderState extends State<CategoriaSlider> {
  final ScrollController _scrollController = ScrollController();
  
  final Categoria _todo = Categoria(id: null, nombre: "Todo");
  final List<Categoria> categorias = [];
  
  late Categoria categoriaSeleccionada;
  
  static const int MAX_CATEGORIAS = 50;
  int _currentPage = 0;
  final int _sizeToLoad = 15;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    categoriaSeleccionada = _todo;
    categorias.add(_todo);
    _loadMoreCategorias();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _loadMoreCategorias();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreCategorias() async {
    if (_isLoading || !_hasMore) return;
    setState(() => _isLoading = true);

    try {
      final paginated = await CatalogoLocator()
          .getCategoriesUsecase
          .execute(page: _currentPage, size: _sizeToLoad);

      setState(() {
        for (final cat in paginated.content) {
          if (!categorias.any((c) => c.id == cat.id)) {
            categorias.add(cat);
          }
        }
        _currentPage++;
        _isLoading = false;
        if (paginated.content.length < _sizeToLoad) _hasMore = false;
        if (categorias.length > MAX_CATEGORIAS) {
          categorias.length = MAX_CATEGORIAS;
          _hasMore = false;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(left: 0, right: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categorias.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == categorias.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }

          final cat = categorias[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: CategoriaBlob(
              nombre: cat.nombre,
              isSelected: cat.id == categoriaSeleccionada.id,
              onTap: () {
                setState(() => categoriaSeleccionada = cat);
                widget.onCategoriaChanged?.call(cat);
              },
            ),
          );
        },
      ),
    );
  }
}