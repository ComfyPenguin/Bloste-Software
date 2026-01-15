import 'package:flutter/material.dart';

class VideoCard extends StatelessWidget {
  final String id;
  final String topic;
  final String description;
  final double duration; // Asumiremos que esto son minutos para el ejemplo
  final String thumbnail;
  final VoidCallback? onTap;

  const VideoCard({
    super.key,
    required this.id,
    required this.topic,
    required this.description,
    required this.duration,
    required this.thumbnail,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        // YouTube suele usar elevación 0 en el feed, pero dejamos algo sutil
        elevation: 0,
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 10), // Separación entre videos
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // YouTube móvil suele ser cuadrado o con radio muy bajo
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. SECCIÓN DE MINIATURA (THUMBNAIL) ---
            Stack(
              children: [
                // Imagen con proporción 16:9
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).disabledColor,
                      image: DecorationImage(
                        image: NetworkImage(thumbnail),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Badge de Duración
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _formatDuration(duration),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // --- 2. SECCIÓN DE INFORMACIÓN ---
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Aquí iría el Avatar si lo tuvieras (CircleAvatar)
                  // Como no está en tus props, usamos el espacio para el texto directamente
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título del video (ID o Description)
                        Text(
                          description.isNotEmpty ? description : id, 
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500, // Semi-bold se ve mejor
                            fontFamily: 'Roboto',
                            color: Colors.black,
                            height: 1.2, // Mejor interlineado
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        
                        // Metadatos (Topic • Views • Time)
                        Text(
                          "$topic • $_viewsPlaceholder • $_timePlaceholder",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700], // Gris oscuro estilo YouTube
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  
                  // Icono de "Más opciones" (los tres puntos)
                  IconButton(
                    icon: const Icon(Icons.more_vert, size: 20),
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {}, // Acción vacía o pasada por parámetro
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helpers simples para simular datos reales de YouTube
  String get _viewsPlaceholder => "12k vistas";
  String get _timePlaceholder => "hace 2 horas";

  // Formateador simple de duración (Asumiendo que duration es un double de minutos.ej: 12.5)
  String _formatDuration(double duration) {
    int minutes = duration.floor();
    int seconds = ((duration - minutes) * 60).round();
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }
}