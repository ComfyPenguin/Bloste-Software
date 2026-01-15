// ============================================
// VIDEOS FAKE DATASOURCE
// Fuente de datos "de mentira" que imita la API REST
// Devuelve JSON compatible con `VideoMapper.fromJson`
// Útil para desarrollo local, tests y previews sin backend.
// ============================================

import 'dart:async';

/// Clase que simula respuestas HTTP en JSON para la lista de vídeos
class VideosFakeDatasource {
  /// Delay simulado en las respuestas (por defecto 600ms)
  final Duration delay;

  VideosFakeDatasource({this.delay = const Duration(milliseconds: 600)});

  // Datos JSON de ejemplo; claves coinciden con VideoMapper.fromJson
  static final List<Map<String, dynamic>> _mockJson = [
    {
      'id': 'intro-flutter',
      'topic': 'Mobile Development',
      'description': 'Introduction to Flutter framework and widget basics',
      'duration': 45.5,
      'thumbnail': 'flutter_intro.jpg',
    },
    {
      'id': 'dart-basics',
      'topic': 'Programming',
      'description': 'Learn Dart programming language fundamentals',
      'duration': 62.0,
      'thumbnail': 'dart_basics.jpg',
    },
    {
      'id': 'state-management',
      'topic': 'Mobile Development',
      'description': 'State management patterns in Flutter applications',
      'duration': 55.3,
      'thumbnail': 'state_mgmt.jpg',
    },
    {
      'id': 'api-integration',
      'topic': 'Backend',
      'description': 'Connecting Flutter apps to REST APIs',
      'duration': 48.7,
      'thumbnail': 'api_integration.jpg',
    },
    {
      'id': 'ui-design',
      'topic': 'Design',
      'description': 'Beautiful UI design principles for mobile apps',
      'duration': 51.2,
      'thumbnail': 'ui_design.jpg',
    },
    {
      'id': 'firebase-setup',
      'topic': 'Backend',
      'description': 'Firebase integration and authentication',
      'duration': 39.5,
      'thumbnail': 'firebase.jpg',
    },
    {
      'id': 'testing-widgets',
      'topic': 'Testing',
      'description': 'Unit and widget testing in Flutter',
      'duration': 44.8,
      'thumbnail': 'testing.jpg',
    },
    {
      'id': 'animation-advanced',
      'topic': 'Mobile Development',
      'description': 'Advanced animation techniques in Flutter',
      'duration': 58.1,
      'thumbnail': 'animation.jpg',
    },
  ];

  /// Devuelve la lista completa de vídeos (JSON)
  Future<List<dynamic>> getVideos() async {
    await Future.delayed(delay);
    // devolvemos una copia para evitar mutaciones accidentales
    return List<Map<String, dynamic>>.from(_mockJson);
  }

  /// Devuelve vídeos filtrados por topic (case-insensitive)
  Future<List<dynamic>> getVideosByTopic(String topic) async {
    await Future.delayed(delay);
    final lower = topic.toLowerCase();
    final filtered = _mockJson
        .where((m) => (m['topic'] ?? '').toString().toLowerCase() == lower)
        .toList();
    return List<Map<String, dynamic>>.from(filtered);
  }

  /// Devuelve un único vídeo por id; si no existe, devuelve mapa vacío
  Future<Map<String, dynamic>> getVideoById(String id) async {
    await Future.delayed(delay);
    try {
      final map = _mockJson.firstWhere((m) => m['id'] == id);
      return Map<String, dynamic>.from(map);
    } catch (e) {
      return <String, dynamic>{};
    }
  }
}
