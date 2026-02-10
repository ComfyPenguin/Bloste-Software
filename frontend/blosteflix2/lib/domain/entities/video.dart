import 'package:blosteflix2/domain/entities/categoria.dart';

class Video {
  int id;
  String idVideo;
  String title;
  List<Categoria> categories;
  String description;
  int? duration;
  String urlVideo;
  String urlthumbnail;
  String author;
  DateTime fechaSubida;
  DateTime? fechaActualizacion;

  /// Constructor with named parameters
  /// @param id - Required: unique video identifier
  /// @param topic - Optional: video category
  /// @param description - Optional: video description
  /// @param duration - Optional: video length
  /// @param thumbnail - Optional: thumbnail image
  Video({
    required this.id,
    required this.idVideo,
    required this.title,
    this.categories = const [],
    required this.description,
    this.duration,
    required this.urlVideo,
    required this.urlthumbnail,
    required this.author, 
    required this.fechaSubida,
    this.fechaActualizacion,
  });

  /// String representation for debugging
  /// Displays all video properties with colored output
  @override
  String toString() {
    return '''\x1B[34mId:\t\t\x1B[36m$id\n\x1B[0m
\x1B[34mIdVideo:\t\x1B[36m$idVideo\n\x1B[0m
\x1B[34mTitle:\t\t\x1B[36m$title\n\x1B[0m
\x1B[34mCategories:\t\x1B[36m$categories\n\x1B[0m
\x1B[34mDescription:\t\x1B[36m${description.toString()}\n\x1B[0m
\x1B[34mDuration:\t\t\x1B[36m$duration\n\x1B[0m
\x1B[34mUrlVideo:\t\t\x1B[36m$urlVideo\n\x1B[0m
\x1B[34mThumbnail:\t\t\x1B[36m$urlthumbnail\n\x1B[0m''';
  }
}
