import 'package:blosteflix2/core/catalogo_locator.dart';
import 'package:blosteflix2/core/media_locator.dart';
import 'package:blosteflix2/domain/entities/video.dart';
import 'package:blosteflix2/presentation/widgets/miniaturas_card.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Video video;

  const VideoPlayerScreen({super.key, required this.video});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  String? _errorMessage;
  List<Video> _relatedVideos = [];
  bool _isLoadingRelated = true;

  // Mapa: etiqueta visible → sufijo real en la URL
  final Map<String, String> _qualityMap = {
    'Auto': 'master.m3u8',      // Sufijo → redirige a master.m3u8 (adaptive)
    '480p': '480/playlist.m3u8',
    '720p': '720/playlist.m3u8',
    '1080p': '1080/playlist.m3u8',
  };

  late String _selectedQualityLabel; // Ej: '720p' o 'Auto'

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Calidad por defecto: Auto
    _selectedQualityLabel = 'Auto';

    final String videoUrl = _getVideoUrl();
    debugPrint('Intentando cargar video HLS desde: $videoUrl');

    _initializePlayer(videoUrl);
    _loadRelatedVideos();
  }

  String _getVideoUrl() {
    final String suffix = _qualityMap[_selectedQualityLabel] ?? '';
    // Añadimos '/' + sufijo solo si hay sufijo (para fixed quality), evita errores de //
    final String qualityPath = suffix.isEmpty ? '' : '/$suffix';
    return '${MediaLocator().getRemoteURL()}${widget.video.urlVideo}$qualityPath';
  }

  Future<void> _initializePlayer(String url) async {
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));

      _videoPlayerController!.addListener(() {
        if (_videoPlayerController!.value.hasError) {
          final error = _videoPlayerController!.value.errorDescription ??
              'Error desconocido en el reproductor';
          debugPrint('Error del VideoPlayer: $error');
          if (mounted) {
            setState(() {
              _errorMessage = error;
            });
          }
        }
      });

      await _videoPlayerController!.initialize();

      if (mounted) {
        _createChewieController();
        setState(() {});
      }
    } catch (e) {
      debugPrint('Excepción al inicializar el video: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'No se pudo cargar el video: $e';
        });
      }
    }
  }

  Future<void> _changeQuality(String newQualityLabel) async {
    if (newQualityLabel == _selectedQualityLabel) return;

    // Guardar posición y estado de reproducción
    final Duration? currentPosition = await _videoPlayerController?.position;
    final bool wasPlaying = _videoPlayerController?.value.isPlaying ?? false;

    // Dispose antiguos
    _chewieController?.dispose();
    _videoPlayerController?.dispose();

    // Cambiar calidad
    setState(() {
      _selectedQualityLabel = newQualityLabel;
      _chewieController = null;
      _errorMessage = null;
    });

    // Nueva URL
    final String newUrl = _getVideoUrl();
    debugPrint('Cambiando a calidad $newQualityLabel → $newUrl');
    await _initializePlayer(newUrl);

    // Restaurar posición y reproducción
    if (currentPosition != null && _videoPlayerController != null) {
      await _videoPlayerController!.seekTo(currentPosition);
    }
    if (wasPlaying) {
      _videoPlayerController?.play();
    }
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: false,
      allowFullScreen: false,
      allowMuting: true,
      showControlsOnInitialize: true,
      aspectRatio: _videoPlayerController!.value.aspectRatio,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _errorMessage = null;
                    });
                    _changeQuality(_selectedQualityLabel);
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Nuevo método para cargar videos relacionados (una sola vez, cantidad limitada)
  Future<void> _loadRelatedVideos() async {
    if (!mounted) return;

    setState(() {
      _isLoadingRelated = true;
    });

    try {
      // Cargamos una página grande (30) para tener margen tras filtrar
      final paginatedResponse = await CatalogoLocator().getVideosUseCase
          .execute(page: 0, size: 30);

      // Filtramos el vídeo actual y limitamos a 20
      final filteredVideos = paginatedResponse.content
          .where((v) => v.urlVideo != widget.video.urlVideo)
          .take(20)
          .toList();

      if (mounted) {
        setState(() {
          _relatedVideos = filteredVideos;
          _isLoadingRelated = false;
        });
      }
    } catch (e) {
      debugPrint('Error cargando vídeos relacionados: $e');
      if (mounted) {
        setState(() {
          _isLoadingRelated = false;
        });
      }
      // Opcional: mostrar SnackBar de error
    }
  }
  

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Widget _buildPlayer() {
    if (_chewieController != null &&
        _videoPlayerController!.value.isInitialized) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Chewie(controller: _chewieController!),
          // Selector de calidad
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: PopupMenuButton<String>(
                color: Colors.black87,
                onSelected: _changeQuality,
                itemBuilder: (context) => _qualityMap.keys.map((label) {
                  return PopupMenuItem<String>(
                    value: label,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(label, style: const TextStyle(color: Colors.white)),
                        if (label == _selectedQualityLabel)
                          const Icon(Icons.check, color: Colors.white, size: 20),
                      ],
                    ),
                  );
                }).toList(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedQualityLabel,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 20),
          Text(
            'Cargando video...',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: _buildPlayer(),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.video.title,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'Por ${widget.video.author}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.video.description,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Videos relacionados',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 16),
                _otherVideos(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Reemplaza completamente el método _otherVideos()
Widget _otherVideos() {
  if (_isLoadingRelated) {
    return const Center(
      child: CircularProgressIndicator(color: Colors.white),
    );
  }

  if (_relatedVideos.isEmpty) {
    return const Text(
      'No hay vídeos relacionados',
      style: TextStyle(color: Colors.grey, fontSize: 16),
    );
  }
  // Todo, adaptar gridvideos() para que sea mas universal y gastarlo aqui.
  return GridView.builder(
      shrinkWrap: true, // Importante: permite incrustar en SingleChildScrollView
      physics: const NeverScrollableScrollPhysics(), // El scroll lo controla el padre
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 1, // 2 columnas en móvil → buen uso del espacio
      childAspectRatio: 1.3, // Formato típico de miniaturas
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
    ),
    itemCount: _relatedVideos.length,
      itemBuilder: (context, index) {
      final video = _relatedVideos[index];
      final remoteUrl = MediaLocator().getRemoteURL();
      final thumbnailUrl = '$remoteUrl${video.urlthumbnail}';

      return GestureDetector(
        onTap: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    VideoPlayerScreen(video: video),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                transitionDuration: const Duration(
                  milliseconds: 100,
                ), // Ajusta si quieres más rápido/lento
              ),
            );
          },
        child: MiniaturasCard(
          thumbnailUrl: thumbnailUrl,
          video: video,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        } else {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        }

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: orientation == Orientation.landscape
              ? null
              : AppBar(
                  title: Text(widget.video.title),
                ),
          body: orientation == Orientation.landscape
              ? Center(child: _buildPlayer())
              : _buildPortraitLayout(),
        );
      },
    );
  }
}