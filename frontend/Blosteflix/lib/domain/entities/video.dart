class Video {
  String id;
  String? topic;
  String? description;
  double? duration;
  String? urlVideo;
  String? thumbnail;
  String? author;

  /// Constructor with named parameters
  /// @param id - Required: unique video identifier
  /// @param topic - Optional: video category
  /// @param description - Optional: video description
  /// @param duration - Optional: video length
  /// @param thumbnail - Optional: thumbnail image
  Video({
    required this.id,
    this.topic,
    this.description,
    this.duration,
    this.urlVideo,
    this.thumbnail,
    this.author,
  });

  /// String representation for debugging
  /// Displays all video properties with colored output
  @override
  String toString() {
    return '''\x1B[34mId:\t\t\x1B[36m$id\n\x1B[0m
\x1B[34mTopic:\t\x1B[36m$topic\n\x1B[0m
\x1B[34mDescription:\t\x1B[36m${description.toString()}\n\x1B[0m
\x1B[34mDuration:\t\t\x1B[36m$duration\n\x1B[0m
\x1B[34mThumbnail:\t\x1B[36m$thumbnail\n\x1B[0m''';
  }
}
