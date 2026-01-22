import 'package:blosteflix2/domain/entities/video.dart';
import 'package:flutter/material.dart';

class MiniaturasCard extends StatelessWidget {
  const MiniaturasCard({
    super.key,
    required this.thumbnailUrl,
    required this.video,
  });

  final String thumbnailUrl;
  final Video video;

  @override
  Widget build(BuildContext context) {
    return Card(
    child: Column(
      children: [
        Expanded(
          child: Image.network(
            thumbnailUrl,
            fit: BoxFit.cover,
            width: double.infinity,
             errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            video.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
    );
  }
}
