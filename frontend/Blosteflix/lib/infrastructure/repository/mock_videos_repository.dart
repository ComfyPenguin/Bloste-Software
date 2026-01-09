import 'package:frontend/domain/entities/video.dart';
import 'package:frontend/domain/repositories/video_repository.dart';

/// Mock Repository for Development
/// Provides sample video data without needing a backend
/// Use this when developing widgets and testing UI
class MockVideosRepository implements VideosRepository {
  // ============================================
  // MOCK DATA
  // ============================================
  static final List<Video> _mockVideos = [
    Video(
      id: 'intro-flutter',
      topic: 'Mobile Development',
      description: 'Introduction to Flutter framework and widget basics',
      duration: 45.5,
      thumbnail: 'flutter_intro.jpg',
    ),
    Video(
      id: 'dart-basics',
      topic: 'Programming',
      description: 'Learn Dart programming language fundamentals',
      duration: 62.0,
      thumbnail: 'dart_basics.jpg',
    ),
    Video(
      id: 'state-management',
      topic: 'Mobile Development',
      description: 'State management patterns in Flutter applications',
      duration: 55.3,
      thumbnail: 'state_mgmt.jpg',
    ),
    Video(
      id: 'api-integration',
      topic: 'Backend',
      description: 'Connecting Flutter apps to REST APIs',
      duration: 48.7,
      thumbnail: 'api_integration.jpg',
    ),
    Video(
      id: 'ui-design',
      topic: 'Design',
      description: 'Beautiful UI design principles for mobile apps',
      duration: 51.2,
      thumbnail: 'ui_design.jpg',
    ),
    Video(
      id: 'firebase-setup',
      topic: 'Backend',
      description: 'Firebase integration and authentication',
      duration: 39.5,
      thumbnail: 'firebase.jpg',
    ),
    Video(
      id: 'testing-widgets',
      topic: 'Testing',
      description: 'Unit and widget testing in Flutter',
      duration: 44.8,
      thumbnail: 'testing.jpg',
    ),
    Video(
      id: 'animation-advanced',
      topic: 'Mobile Development',
      description: 'Advanced animation techniques in Flutter',
      duration: 58.1,
      thumbnail: 'animation.jpg',
    ),
  ];

  @override
  Future<List<Video>> getVideos() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockVideos;
  }

  @override
  Future<List<Video>> getVideosByTopic(String topic) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockVideos
        .where((video) => video.topic?.toLowerCase() == topic.toLowerCase())
        .toList();
  }

  @override
  Future<Video?> getVideoById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockVideos.firstWhere((video) => video.id == id);
    } catch (e) {
      return null;
    }
  }
}
