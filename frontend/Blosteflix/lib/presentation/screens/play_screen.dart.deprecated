import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/video.dart';
import 'package:frontend/repo_singleton.dart';

class PlayScreen extends StatelessWidget {
  final String idVideo;

  const PlayScreen({super.key, required this.idVideo});

  @override
  Widget build(BuildContext context) {
    // Cargamos el video por ID
    final videoFuture = RepoSingleton().repo.getVideoById(idVideo);
    // Cargamos todos los videos para la lista
    final allVideosFuture = RepoSingleton().repo.getVideos();

    return Scaffold(
      appBar: AppBar(title: const Text("Reproduciendo Video")),
      body: FutureBuilder<Video?>(
        future: videoFuture,
        builder: (context, videoSnapshot) {
          if (videoSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (videoSnapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "Se ha producido un error: ${videoSnapshot.error}",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final videoActual = videoSnapshot.data;

          if (videoActual == null) {
            return const Center(child: Text("No se ha encontrado el video"));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Tarjeta grande con el video actual
                  VideoPlayerCard(video: videoActual),

                  const SizedBox(height: 20),

                  // Tarjeta con la lista de todos los videos
                  FutureBuilder<List<Video>>(
                    future: allVideosFuture,
                    builder: (context, allVideosSnapshot) {
                      if (allVideosSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final todosLosVideos =
                          allVideosSnapshot.data ?? const <Video>[];

                      return VideoListCard(
                        videos: todosLosVideos,
                        currentVideoId: idVideo,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Tarjeta grande para mostrar el video principal
class VideoPlayerCard extends StatelessWidget {
  final Video video;

  const VideoPlayerCard({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Miniatura del video grande
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.black,
              image: video.thumbnail != null
                  ? DecorationImage(
                      image: NetworkImage(video.thumbnail!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Center(
              child: Icon(
                Icons.play_circle_filled,
                size: 80,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
          // Información del video
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.topic ?? 'Sin título',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (video.duration != null)
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${video.duration!.toStringAsFixed(0)} min',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                if (video.description != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    video.description!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Tarjeta con la lista de todos los videos
class VideoListCard extends StatelessWidget {
  final List<Video> videos;
  final String currentVideoId;

  const VideoListCard({
    super.key,
    required this.videos,
    required this.currentVideoId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Todos los videos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: videos.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final video = videos[index];
                final isCurrentVideo = video.id == currentVideoId;

                return ListTile(
                  leading: Container(
                    width: 80,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[300],
                      image: video.thumbnail != null
                          ? DecorationImage(
                              image: NetworkImage(video.thumbnail!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: video.thumbnail == null
                        ? const Icon(Icons.videocam, color: Colors.grey)
                        : null,
                  ),
                  title: Text(
                    video.topic ?? 'Sin título',
                    style: TextStyle(
                      fontWeight: isCurrentVideo
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isCurrentVideo
                          ? Theme.of(context).primaryColor
                          : null,
                    ),
                  ),
                  subtitle: video.duration != null
                      ? Text('${video.duration!.toStringAsFixed(0)} min')
                      : null,
                  trailing: isCurrentVideo
                      ? const Icon(Icons.play_arrow, color: Colors.blue)
                      : const Icon(Icons.chevron_right),
                  onTap: isCurrentVideo
                      ? null
                      : () {
                          // Navegar al video seleccionado
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PlayScreen(idVideo: video.id),
                            ),
                          );
                        },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
