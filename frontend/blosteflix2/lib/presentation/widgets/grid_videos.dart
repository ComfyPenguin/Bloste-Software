import 'package:blosteflix2/core/media_locator.dart';
import 'package:blosteflix2/domain/entities/video.dart';
import 'package:blosteflix2/presentation/screens/videos/video_player_screen.dart';
import 'package:blosteflix2/presentation/widgets/miniaturas_card.dart';
import 'package:flutter/material.dart';

class GridVideos extends StatelessWidget {
  const GridVideos({
    super.key,
    required ScrollController scrollController,
    required List<Video> videos,
    required bool hasMore, 
    required bool isLoadingMore,
  }) : _scrollController = scrollController, _videos = videos, _hasMore = hasMore;

  final ScrollController _scrollController;
  final List<Video> _videos;
  final bool _hasMore;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = (constraints.maxWidth > 600) ? 4 : 1;
        return GridView.builder(
          controller: _scrollController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: _videos.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _videos.length) {
              return const Center(child: CircularProgressIndicator());
            }
            final video = _videos[index];
            final remoteUrl = MediaLocator().getRemoteURL();
            final thumbnailUrl = '$remoteUrl${video.urlthumbnail}';
            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoPlayerScreen(video: video)));
              },
              child: MiniaturasCard(thumbnailUrl: thumbnailUrl, video: video)
            );
          },
        );
      },
    );
  }
}
