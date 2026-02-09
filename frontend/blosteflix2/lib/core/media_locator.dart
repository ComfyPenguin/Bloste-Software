import 'package:flutter_dotenv/flutter_dotenv.dart';

class MediaLocator {
  static final MediaLocator _instance = MediaLocator._internal();

  factory MediaLocator() {
    return _instance;
  }

  MediaLocator._internal();

  late final String _mediaUrl;

  String getRemoteURL() {
    _mediaUrl = dotenv.env['MEDIA_URL'] ?? 'http://localhost:4000';
    return _mediaUrl;
  }
}
