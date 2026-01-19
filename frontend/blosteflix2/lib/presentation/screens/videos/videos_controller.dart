import 'package:flutter/material.dart';
import '../../../domain/entities/video.dart';
import '../../../domain/usecases/videos/get_videos_usecase.dart';

class VideosController extends ChangeNotifier {
  
  final GetVideosUseCase getVideos;

  VideosController(this.getVideos);

  final List<Video> _videos = [];
  int _page = 0;
  final int _size = 10;
  bool _isLoading = false;
  bool _hasMore = true;

  List<Video> get videos => _videos;
  bool get isLoading => _isLoading;

  Future<void> loadNextPage() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    final result = await getVideos.execute(page: _page, size: _size);

    _videos.addAll(result.content);
    _hasMore = !result.last;
    _page++;

    _isLoading = false;
    notifyListeners();
  }
}
