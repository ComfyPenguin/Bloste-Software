import 'package:flutter/material.dart';
import '../../../domain/entities/video.dart';
import 'package:blosteflix2/presentation/widgets/videos/video_info.dart';
import 'package:blosteflix2/presentation/widgets/videos/video_player_widget.dart';

class VideoPlayerScreen extends StatelessWidget {
  final Video video;
  const VideoPlayerScreen({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            VideoPlayerWidget(url: video.urlVideo),
            Expanded(
              child: ListView(
                children: [
                  VideoInfo(video: video),
                  const Divider(),
                  // Aquí puedes reutilizar el mismo controller o pasar sugeridos
                  // Placeholder
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
