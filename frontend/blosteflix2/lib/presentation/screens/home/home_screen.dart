import 'package:blosteflix2/presentation/screens/videos/videos_controller.dart';
import 'package:blosteflix2/presentation/widgets/videos/video_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeView();
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Aquí usamos el controller que viene del provider
    final controller = context.watch<VideosController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('BlosteFlix'),
        centerTitle: true,
      ),
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
