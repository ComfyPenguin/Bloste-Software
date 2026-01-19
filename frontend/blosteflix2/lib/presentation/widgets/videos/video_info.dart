import 'package:flutter/material.dart';
import '../../../domain/entities/video.dart';

class VideoInfo extends StatelessWidget {
  final Video video;
  const VideoInfo({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(video.title,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(video.description),
        ],
      ),
    );
  }
}
