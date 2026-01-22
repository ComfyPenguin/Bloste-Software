import 'package:blosteflix2/core/catalogo_locator.dart';
import 'package:blosteflix2/domain/entities/video.dart';
import 'package:blosteflix2/presentation/widgets/grid_videos.dart';
import 'package:flutter/material.dart';

class MiniaturasScreen extends StatefulWidget {
  const MiniaturasScreen({super.key});

  @override
  State<MiniaturasScreen> createState() => _MiniaturasScreenState();
}

class _MiniaturasScreenState extends State<MiniaturasScreen> {
  
  final ScrollController _scrollController = ScrollController();

  final List<Video> _videos = [];

  static const int MAX_VIDEOS = 20;

  int _currentPage = 0;

  final int _sizeToLoad = 10;

  bool _isLoading = false;

  bool _hasMore = true;

  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadMoreVideos();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading) {
        _loadMoreVideos();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreVideos() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final paginatedResponse = await CatalogoLocator()
          .getVideosUseCase
          .execute(page: _currentPage, size: _sizeToLoad);
      
      setState(() {
        _videos.addAll(paginatedResponse.content);
        _currentPage++;
        _isLoading = false;
        if (paginatedResponse.content.length < _sizeToLoad) {
          _hasMore = false;
        }
        if(_videos.length >= MAX_VIDEOS){
          _hasMore = false;
          if(_videos.length >= MAX_VIDEOS){
            _videos.length = MAX_VIDEOS;
          }
        }

      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      debugPrint("Error loading videos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_videos.isEmpty && !_isLoading) {
      return Center(child: Column(
        children: [
          const Text("No videos available"),
          TextButton(onPressed: _loadMoreVideos, child: const Text("Retry"))
        ],
      ));    
    }

    if(_hasError){
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Error loading videos"),
            TextButton(
              onPressed: _loadMoreVideos,
              child: const Text("Retry"),
            )
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridVideos(scrollController: _scrollController, videos: _videos, isLoadingMore: _isLoading, hasMore: _hasMore,)
    );
  }
  
}