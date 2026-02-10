import 'package:blosteflix2/core/catalogo_locator.dart';
import 'package:blosteflix2/core/media_locator.dart';
import 'package:blosteflix2/domain/entities/video.dart';
import 'package:blosteflix2/presentation/screens/videos/video_player_screen.dart';
import 'package:blosteflix2/presentation/utils/duration_formatter.dart';
import 'package:blosteflix2/presentation/widgets/miniaturas_card.dart';
import 'package:blosteflix2/presentation/services/auth_token_service.dart';
import 'package:blosteflix2/infrastructure/data_sources/auth_local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Video> _results = [];
  String _query = '';
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
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _loadMore();
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
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _startSearch(String query) {
    final trimmed = query.trim();
    setState(() {
      _query = trimmed;
      _results.clear();
      _currentPage = 0;
      _hasMore = true;
      _hasError = false;
    });
    if (trimmed.isNotEmpty) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore || _query.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final response = await CatalogoLocator().searchVideosUsecase.execute(
        titulo: _query,
        page: _currentPage,
        size: _sizeToLoad,
      );

      if (!mounted) return;

      setState(() {
        _results.addAll(response.content);
        _currentPage++;
        _isLoading = false;
        if (response.content.isEmpty || response.content.length < _sizeToLoad) {
          _hasMore = false;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      debugPrint('Error buscando videos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.search,
                      onSubmitted: _startSearch,
                      decoration: InputDecoration(
                        hintText: 'Buscar por título',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.06),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _startSearch(_controller.text),
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
          ),
          if (_query.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  'Escribe un título para buscar videos',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else if (_hasError && _results.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Error al buscar videos'),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _loadMore,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            )
          else if (_results.isEmpty && !_isLoading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  'No se encontraron resultados',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600
                      ? 4
                      : 1,
                  childAspectRatio: 1.3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == _results.length) {
                      if (!_isLoading && !_hasMore) {
                        return const SizedBox.shrink();
                      }
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final video = _results[index];
                    final remoteUrl = MediaLocator().getRemoteURL();
                    final thumbnailUrl = '$remoteUrl${video.urlthumbnail}';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VideoPlayerScreen(video: video),
                          ),
                        );
                      },
                      child: MiniaturasCard(
                        thumbnailUrl: thumbnailUrl,
                        video: video,
                        authToken: _authToken,
                        durationText: formatDurationText(video.duration),
                      ),
                    );
                  },
                  childCount:
                      _results.length + (_isLoading || _hasMore ? 1 : 0),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
