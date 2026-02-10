import 'package:blosteflix2/domain/entities/video.dart';
import 'package:flutter/material.dart';

class MiniaturasCard extends StatelessWidget {
  const MiniaturasCard({
    super.key,
    required this.thumbnailUrl,
    required this.video,
    this.authToken,
    this.durationText,
  });

  final String thumbnailUrl;
  final Video video;
  final String? authToken;
  final String? durationText;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasAuthToken = authToken != null && authToken!.isNotEmpty;
    final showDuration = durationText != null && durationText!.isNotEmpty;
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
            child: Stack(
              fit: StackFit.expand,
              children: [
                hasAuthToken
                    ? Image.network(
                        thumbnailUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        headers: {'Authorization': 'Bearer $authToken'},
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[300],
                            child:
                                const Center(child: CircularProgressIndicator()),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.error, color: Colors.red),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[300],
                        child:
                            const Center(child: CircularProgressIndicator()),
                      ),
                if (showDuration)
                  Positioned(
                    right: 8.0,
                    bottom: 8.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        durationText!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
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
