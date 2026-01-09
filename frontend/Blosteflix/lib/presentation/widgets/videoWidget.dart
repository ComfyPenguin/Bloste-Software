// ============================================
// VIDEO WIDGET - HLS VIDEO PLAYER
// ============================================
// Displays an HLS video player for streaming video from the backend
// Supports HLS (HTTP Live Streaming) protocol for reliable playback
// Used on Android/iOS with ExoPlayer/AVPlayer

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

/// StatefulWidget for video playback
/// Receives videoId and streams HLS playlist from backend
class VideoWidget extends StatefulWidget {
  /// Video ID to fetch and play (e.g., \"video1\")
  final String videoId;

  const VideoWidget({super.key, required this.videoId});

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

/// State class managing video player lifecycle
class _VideoWidgetState extends State<VideoWidget> {
  /// Video player controller - null while initializing
  VideoPlayerController? _controller;

  /// Loading state - true while fetching and initializing
  bool _isLoading = true;

  /// Error message - null if no error
  String? _error;

  /// Controls visibility - true to show play/pause button
  bool _showControls = true;

  /// Timer to hide controls after inactivity
  Timer? _hideControlsTimer;

  /// Static map to store video states by videoId
  static final Map<String, _VideoState> _videoStates = {};

  /// Current video state
  _VideoState? _currentVideoState;

  @override
  void initState() {
    super.initState();
    // Get or create video state for this video
    _currentVideoState = _videoStates.putIfAbsent(
      widget.videoId,
      () => _VideoState(),
    );
    // Start initializing video when widget is created
    _initializeVideo();
  }

  /// Initialize video player with HLS stream
  ///
  /// Steps:
  /// 1. Build HLS playlist URL with .m3u8 extension
  /// 2. Validate playlist is accessible and valid
  /// 3. Create VideoPlayerController
  /// 4. Initialize controller (connect to backend)
  /// 5. Start playback
  Future<void> _initializeVideo() async {
    try {
      // ============================================
      // STEP 1: BUILD HLS PLAYLIST URL
      // ============================================
      // NOTE: 10.0.2.2 is special address in Android emulator
      // Maps to host machine's localhost (127.0.0.1)
      // .m3u8 extension is CRITICAL for ExoPlayer to recognize HLS
      final hlsUrl =
          'http://10.0.2.2:3000/api/videolist/videos/${widget.videoId}/index.m3u8';
      print('🎬 Initializing video with URL: $hlsUrl');

      // ============================================
      // STEP 2: VALIDATE PLAYLIST BEFORE INITIALIZING
      // ============================================
      // Pre-check: Verify playlist exists before creating player
      // Helps catch network/server errors early
      try {
        final response = await http.get(Uri.parse(hlsUrl));

        // Check HTTP status is 200 OK
        if (response.statusCode != 200) {
          throw Exception(
            'Server returned ${response.statusCode}: ${response.body}',
          );
        }

        // Validate it's actually an HLS playlist (starts with #EXTM3U)
        if (!response.body.contains('#EXTM3U')) {
          throw Exception('Response is not a valid m3u8 playlist');
        }
      } catch (e) {
        print('❌ Failed to fetch playlist: $e');
        throw Exception('Cannot reach server: $e');
      }

      // ============================================
      // STEP 3: CREATE VIDEO PLAYER CONTROLLER
      // ============================================
      // VideoPlayerController.networkUrl supports HLS (.m3u8) streams
      final controller = VideoPlayerController.networkUrl(Uri.parse(hlsUrl));

      // ============================================
      // STEP 4: INITIALIZE CONTROLLER
      // ============================================
      // Connects to backend and fetches playlist
      // Prepares the player for playback
      await controller.initialize();

      // ============================================
      // STEP 5: VALIDATE INITIALIZATION
      // ============================================
      if (!controller.value.isInitialized) {
        throw Exception('Failed to initialize video controller');
      }

      // ============================================
      // STEP 6: CHECK IF WIDGET STILL MOUNTED
      // ============================================
      // Important: Only update state if widget is still in the tree
      // Prevents memory leaks if user navigated away
      if (!mounted) {
        controller.dispose();
        return;
      }

      // ============================================
      // STEP 7: UPDATE UI STATE
      // ============================================
      setState(() {
        _controller = controller; // Store controller
        _isLoading = false; // Hide loading spinner
      });

      // ============================================
      // STEP 8: START PLAYBACK
      // ============================================
      // Restore saved position if exists
      if (_currentVideoState!.position.inSeconds > 0) {
        await _controller!.seekTo(_currentVideoState!.position);
        debugPrint('🔄 Restored position: ${_currentVideoState!.position}');
      }

      // Restore play/pause state
      if (_currentVideoState!.wasPlaying) {
        await _controller!.play();
      } else {
        await _controller!.pause();
        setState(() {
          _showControls = true;
        });
      }

      _controller!.setLooping(true);

      // Start timer to hide controls only if playing
      if (_currentVideoState!.wasPlaying) {
        _showControlsTemporarily();
      }

      print('✅ Video initialized successfully');
    } catch (error) {
      // ============================================
      // ERROR HANDLING
      // ============================================
      print('❌ Error initializing video: $error');
      if (!mounted) return;

      // Display error message to user
      setState(() {
        _isLoading = false;
        _error = error.toString();
      });
    }
  }

  /// Handle widget updates (parent rebuilds with new videoId)
  /// Disposes old player and initializes new one if videoId changes
  @override
  void didUpdateWidget(VideoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if videoId changed
    if (oldWidget.videoId != widget.videoId) {
      // Save current video state before switching
      _saveCurrentVideoState();

      // Cleanup old video player
      _controller?.pause();
      _controller?.dispose();

      // Get or create state for new video
      _currentVideoState = _videoStates.putIfAbsent(
        widget.videoId,
        () => _VideoState(),
      );

      // Reset state and reinitialize with new video
      setState(() {
        _controller = null;
        _isLoading = true;
        _error = null;
      });
      _initializeVideo();
    }
  }

  /// Cleanup when widget is destroyed
  /// Disposes video player resources to prevent memory leaks
  @override
  void dispose() {
    _saveCurrentVideoState();
    _hideControlsTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  /// Save current video playback state
  void _saveCurrentVideoState() {
    if (_controller != null &&
        _controller!.value.isInitialized &&
        _currentVideoState != null) {
      _currentVideoState!.position = _controller!.value.position;
      _currentVideoState!.wasPlaying = _controller!.value.isPlaying;
      debugPrint(
        '💾 Saved state for ${widget.videoId}: ${_currentVideoState!.position} - Playing: ${_currentVideoState!.wasPlaying}',
      );
    }
  }

  /// Show controls and start timer to hide them
  void _showControlsTemporarily() {
    setState(() {
      _showControls = true;
    });

    // Cancel any existing timer
    _hideControlsTimer?.cancel();

    // Start new timer to hide controls after 3 seconds
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _controller?.value.isPlaying == true) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  /// Toggle play/pause and show controls
  void _togglePlayPause() {
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _showControls = true; // Keep controls visible when paused
        _hideControlsTimer?.cancel();
      } else {
        _controller!.play();
        _showControlsTemporarily(); // Hide controls after delay when playing
      }
    });
  }

  /// Build video player UI with loading and error states
  ///
  /// Display hierarchy:
  /// 1. If error: Show error message with retry button
  /// 2. If loading: Show loading spinner
  /// 3. Otherwise: Show video player with controls
  @override
  Widget build(BuildContext context) {
    // ============================================
    // ERROR STATE UI
    // ============================================
    // Display error message with retry button
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              'Error al cargar el vídeo',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),
            // Retry button to reinitialize video
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _error = null;
                  _isLoading = true;
                });
                _initializeVideo();
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    // ============================================
    // LOADING STATE UI
    // ============================================
    // Display spinner while fetching and initializing
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando vídeo...'),
          ],
        ),
      );
    }

    // ============================================
    // FALLBACK: Still loading
    // ============================================
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    // ============================================
    // SUCCESS STATE: VIDEO PLAYER UI
    // ============================================
    // Display video with controls and progress bar
    return GestureDetector(
      onTap: _showControlsTemporarily,
      child: AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: Stack(
          children: [
            // Video player (displays the actual video content)
            VideoPlayer(_controller!),

            // Play/Pause button centered on video (with fade animation)
            AnimatedOpacity(
              opacity: _showControls ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Center(
                child: GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Icon(
                      _controller!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ),

            // Progress bar at bottom (allows seeking/scrubbing)
            Align(
              alignment: Alignment.bottomCenter,
              child: VideoProgressIndicator(
                _controller!,
                allowScrubbing: true, // User can drag to seek
                padding: const EdgeInsets.all(8.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Class to store video playback state
class _VideoState {
  Duration position = Duration.zero;
  bool wasPlaying = true; // Default to auto-play for first time
}
