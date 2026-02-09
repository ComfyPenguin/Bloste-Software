import 'package:blosteflix2/core/catalogo_locator.dart';
import 'package:blosteflix2/core/media_locator.dart';
import 'package:blosteflix2/domain/entities/categoria.dart';
import 'package:blosteflix2/domain/entities/video.dart';
import 'package:blosteflix2/presentation/screens/videos/video_player_screen.dart';
import 'package:blosteflix2/presentation/widgets/miniaturas_card.dart';
import 'package:blosteflix2/presentation/services/auth_token_service.dart';
import 'package:blosteflix2/infrastructure/data_sources/auth_local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GridVideos extends StatefulWidget {
  final Categoria? categoriaSeleccionada;
  final ScrollController scrollController;

  const GridVideos({
    super.key,
    this.categoriaSeleccionada,
    required this.scrollController,
  });

  @override
  State<GridVideos> createState() => _GridVideosState();
}

class _GridVideosState extends State<GridVideos> {
  final List<Video> _videos = [];

  int _currentPage = 0;
  final int _sizeToLoad = 10;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _hasError = false;
  String? _authToken;
  late AuthTokenService _authTokenService;

  @override
  void initState() {
    super.initState();
    _authTokenService = AuthTokenService(
      AuthLocalStorage(const FlutterSecureStorage()),
    );
    _loadAuthToken();
    _loadMoreVideos(); // carga inicial

    widget.scrollController.addListener(() {
      if (!mounted) return;

      if (widget.scrollController.position.pixels >=
              widget.scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _loadMoreVideos();
      }
    });
  }

  /// Carga el token de autenticación
  Future<void> _loadAuthToken() async {
    try {
      final token = await _authTokenService.getAccessToken();
      if (mounted) {
        setState(() {
          _authToken = token;
        });
      }
    } catch (e) {
      debugPrint('Error al cargar token: $e');
    }
  }

  @override
  void didUpdateWidget(covariant GridVideos oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Cambio de categoría → reset y recarga
    if (widget.categoriaSeleccionada?.id !=
        oldWidget.categoriaSeleccionada?.id) {
      setState(() {
        _videos.clear();
        _currentPage = 0;
        _hasMore = true;
        _hasError = false;
        _isLoading = false;
      });
      _loadMoreVideos();
    }
  }

  Future<void> _loadMoreVideos() async {
    if (_isLoading || !_hasMore) return;

    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final int? categoriaId = widget.categoriaSeleccionada?.id;

      final response = await CatalogoLocator().getVideosUseCase.execute(
        page: _currentPage,
        size: _sizeToLoad,
        categoriaId: categoriaId,
      );

      if (!mounted) return;

      setState(() {
        _videos.addAll(response.content);
        _currentPage++;
        _isLoading = false;

        if (response.content.isEmpty || response.content.length < _sizeToLoad) {
          _hasMore = false;
        }

        // Opcional: límite máximo de videos
        if (_videos.length >= 100) {
          _hasMore = false;
          if (_videos.length > 100) {
            _videos.length = 100;
          }
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      debugPrint("Error cargando videos: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError && _videos.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Error al cargar videos"),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _loadMoreVideos,
                child: const Text("Reintentar"),
              ),
            ],
          ),
        ),
      );
    }

    if (_videos.isEmpty && !_isLoading && !_hasError) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.video_collection_outlined,
                size: 80,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                widget.categoriaSeleccionada == null
                    ? "No hay videos disponibles"
                    : "No hay videos en '${widget.categoriaSeleccionada!.nombre}'",
                style: const TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (_hasMore)
                TextButton(
                  onPressed: _loadMoreVideos,
                  child: const Text("Reintentar"),
                ),
            ],
          ),
        ),
      );
    }

    // Grid normal → ahora como SliverGrid
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 1,
        childAspectRatio: 1.3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index == _videos.length) {
          if (!_isLoading && !_hasMore) return const SizedBox.shrink();
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final video = _videos[index];
        final remoteUrl = MediaLocator().getRemoteURL();
        final thumbnailUrl = '$remoteUrl${video.urlthumbnail}';

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(video: video),
              ),
            );
          },
          child: MiniaturasCard(
            thumbnailUrl: thumbnailUrl,
            video: video,
            authToken: _authToken,
          ),
        );
      }, childCount: _videos.length + (_isLoading || _hasMore ? 1 : 0)),
    );
  }
}
