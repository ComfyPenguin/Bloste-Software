import 'package:flutter/material.dart';
import '../../../domain/entities/video.dart';
import 'video_card.dart';

class VideoGrid extends StatelessWidget {
  final List<Video> videos;
  const VideoGrid({super.key, required this.videos});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width < 600 ? 1 : width < 900 ? 2 : 3;

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: videos.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: columns == 1 ? 16 / 9 : 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (_, i) => VideoCard(video: videos[i]),
        );
      },
    );
  }
}
