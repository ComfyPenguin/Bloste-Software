import 'package:blosteflix2/domain/entities/video.dart';
import 'package:flutter/material.dart';

class MiniaturasCard extends StatelessWidget {
  const MiniaturasCard({
    super.key,
    required this.thumbnailUrl,
    required this.video,
    this.authToken,
  });

  final String thumbnailUrl;
  final Video video;
  final String? authToken;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(
        4.0,
      ), // opcional: pequeño margen externo si lo usas en GridView
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              thumbnailUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              headers: authToken != null
                  ? {'Authorization': 'Bearer $authToken'}
                  : {},
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.error, color: Colors.red),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
            child: Text(
              video.title,
              style: theme.textTheme.bodyLarge,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
