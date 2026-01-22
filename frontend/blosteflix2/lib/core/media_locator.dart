class MediaLocator {
  static final MediaLocator _instance = MediaLocator._internal();

  factory MediaLocator() {
    return _instance;
  }

  MediaLocator._internal();

  final String _mediaUrl = 'http://10.0.2.2:4000';

  String getRemoteURL() {
    return _mediaUrl;
  }
}