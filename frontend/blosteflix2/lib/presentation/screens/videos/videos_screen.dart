import 'package:blosteflix2/presentation/widgets/videos/video_grid.dart';
import 'package:flutter/material.dart';
import '../../../domain/usecases/videos/get_videos_usecase.dart';
import 'videos_controller.dart';
import 'package:provider/provider.dart';

class VideosScreen extends StatelessWidget {
  const VideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final controller = VideosController(
          context.read<GetVideosUseCase>(),
        );
        controller.loadNextPage();
        return controller;
      },
      child: const _VideosView(),
    );
  }
}

class _VideosView extends StatelessWidget {
  const _VideosView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<VideosController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Vídeos')),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll.metrics.pixels >=
              scroll.metrics.maxScrollExtent * 0.8) {
            controller.loadNextPage();
          }
          return false;
        },
        child: VideoGrid(videos: controller.videos),
      ),
    );
  }
}
