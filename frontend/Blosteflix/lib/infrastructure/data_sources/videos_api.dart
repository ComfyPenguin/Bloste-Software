// ============================================
// VIDEOS API - DATA SOURCE LAYER
// ============================================
// Handles all HTTP requests to the backend API
// Returns raw JSON data from the server
// Decodes responses and handles errors

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/**
 * VideosApi class - Interface to backend REST API
 * Makes HTTP requests and returns decoded JSON data
 */
class VideosApi {
  // ============================================
  // PROPERTIES
  // ============================================
  // URL base that gets provided during instantiation
  // Example: \"http://10.0.2.2:3000/api/videolist\"
  String baseURL;

  /**
   * Constructor - receives base URL
   * @param baseURL - Base API endpoint URL
   */
  VideosApi(this.baseURL);

  // ============================================
  // API METHODS
  // ============================================

  /**
   * Fetch all videos from the backend
   * @return List of video JSON objects
   * @throws Returns empty list on error
   */
  Future<List<dynamic>> getVideos() async {
    String url = baseURL;

    // Make GET request to fetch all videos
    http.Response data = await http.get(Uri.parse(url));

    // Check HTTP 200 OK status
    if (data.statusCode == HttpStatus.ok) {
      // Decode UTF-8 response body
      String body = utf8.decode(data.bodyBytes);
      // Parse JSON array
      final bodyJSON = jsonDecode(body) as List;

      return bodyJSON;
    } else {
      // Return empty list on error
      return [];
    }
  }

  /**
   * Fetch videos by specific topic/category
   * Example: getVideosByTopic(\"Hardware\") 
   *   → GET /api/videolist/topic/Hardware
   * 
   * @param topic - Video category to filter by
   * @return List of videos with that topic
   */
  Future<List<dynamic>> getVideosByTopic(String topic) async {
    String url = "$baseURL/topic/$topic";

    // Make GET request to fetch videos by topic
    http.Response data = await http.get(Uri.parse(url));

    if (data.statusCode == HttpStatus.ok) {
      String body = utf8.decode(data.bodyBytes);
      final bodyJSON = jsonDecode(body) as List;

      return bodyJSON;
    } else {
      return [];
    }
  }

  /**
   * Fetch a specific video by its ID
   * Example: getVideoById(\"video1\")
   *   → GET /api/videolist/id/video1
   * 
   * @param id - Video ID to fetch
   * @return Single video object with full details
   */
  Future<Map<String, dynamic>> getVideoById(String id) async {
    String url = "$baseURL/id/$id";

    // Make GET request to fetch single video
    http.Response data = await http.get(Uri.parse(url));

    if (data.statusCode == HttpStatus.ok) {
      String body = utf8.decode(data.bodyBytes);
      final bodyJSON = jsonDecode(body);

      return bodyJSON;
    } else {
      // Return empty map on error
      return {};
    }
  }
}
