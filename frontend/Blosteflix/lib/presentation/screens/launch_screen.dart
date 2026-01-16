// ============================================
// LAUNCH SCREEN - MAIN APPLICATION UI
// ============================================
import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/video.dart';
import 'package:frontend/presentation/widgets/video_card.dart';
import 'package:frontend/presentation/widgets/videoWidget.dart';
import 'package:frontend/repo_singleton.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

enum MenuItem { item1, item2 }

class ItemPage extends StatelessWidget {
  const ItemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Item 1')));
  }
}

class _LaunchScreenState extends State<LaunchScreen> {
  // ============================================
  // STATE VARIABLES
  // ============================================

  final Future<List<Video>?> _listaVideosFuture = RepoSingleton().repo
      .getVideos();
  Video? currentVideo;

  // --- VARIABLES PARA EL BUSCADOR ---
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // Es buena práctica limpiar los controladores
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ============================================
  // BUILD METHOD
  // ============================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // INTERRUPTOR DE APPBAR:
      appBar: _isSearching ? _getSearchAppBar() : _getNormalAppBar(),

      // Body uses FutureBuilder to manage async video loading states
      body: FutureBuilder<List<Video>?>(
        future: _listaVideosFuture,
        builder: (context, asyncSnapshot) {
          // LOADING STATE
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ERROR STATE
          if (asyncSnapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "Se ha producido un error: ${asyncSnapshot.error}",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // SUCCESS STATE
          final lista = asyncSnapshot.data ?? const <Video>[];

          if (lista.isEmpty) {
            return const Center(child: Text("No se han encontrado vídeos"));
          }

          // Videos loaded successfully
          return LayoutBuilder(
            builder: (context, constraints) {
              final isLandscape =
                  MediaQuery.of(context).orientation == Orientation.landscape;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // VIDEO PLAYER SECTION
                      if (currentVideo != null) ...[
                        Container(
                          width: double.infinity,
                          constraints: BoxConstraints(
                            maxHeight: isLandscape
                                ? constraints.maxHeight * 0.7
                                : constraints.maxHeight * 0.4,
                          ),
                          child: VideoWidget(videoId: currentVideo!.id),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          currentVideo!.id,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // VIDEO LIST SECTION
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: lista.length,
                        itemBuilder: (context, i) {
                          final v = lista[i];
                          return VideoCard(
                            id: v.id,
                            topic: v.topic ?? 'Sin categoría',
                            description: v.description ?? 'Sin descripción',
                            duration: v.duration ?? 0.0,
                            thumbnail: 'http://localhost:4000/${v.thumbnail}',
                            author: v.author ?? 'Desconocido',
                            onTap: () {
                              setState(() {
                                currentVideo = v;
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ============================================
  // APPBAR HELPERS
  // ============================================

  /// 1. APPBAR NORMAL (Logo, Título y botón Lupa)
  AppBar _getNormalAppBar() {
    return AppBar(
      leading: const Icon(Icons.menu), // O tu logo aquí
      title: const Text('Blosteflix'),
      actions: [
        PopupMenuButton<MenuItem>(
          onSelected: (value) => {
            if (value == MenuItem.item1)
              {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ItemPage()),
                ),
              }
            else if (value == MenuItem.item1)
              {},
          },
          //Si se añade item: se añade enum y onselected(if)
          itemBuilder: (context) => const [
            PopupMenuItem(value: MenuItem.item1, child: Text('Categoría 1')),

            PopupMenuItem(value: MenuItem.item2, child: Text('Categoría 2')),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Al pulsar la lupa, cambiamos el estado a TRUE
            setState(() {
              _isSearching = true;
            });
          },
        ),
      ],
    );
  }

  /// 2. APPBAR DE BÚSQUEDA (Botón atrás, TextField)
  AppBar _getSearchAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      // Botón "X" o flecha atrás para cancelar búsqueda
      leading: IconButton(
        icon: const Icon(Icons.clear), // O Icons.arrow_back
        onPressed: () {
          // Al cancelar, borramos texto y volvemos al estado normal
          setState(() {
            _searchController.clear();
            _isSearching = false;
          });
        },
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 10),
        child: TextField(
          controller: _searchController,
          onEditingComplete: () {
            // Lógica cuando el usuario pulsa "Enter" en el teclado
            print("Buscando: ${_searchController.text}");
            // Aquí llamarías a tu lógica de filtrado
          },
          style: const TextStyle(color: Colors.white), // Texto blanco
          cursorColor: Colors.white,
          autofocus: true, // Teclado aparece automático
          decoration: const InputDecoration(
            hintText: "Buscar video...",
            hintStyle: TextStyle(color: Colors.white60),
            focusColor: Colors.white,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
