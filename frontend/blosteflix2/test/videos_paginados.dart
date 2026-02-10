import 'package:blosteflix2/domain/entities/video.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blosteflix2/infrastructure/data_sources/catalogo_api.dart';

void main() {
  final api = CatalogoApi('http://10.0.2.2:8080');

  test('Devuelve videos paginados', () async {
    final result = await api.getVideos(page: 0, size: 10);

    expect(result.content.isNotEmpty, true);
    expect(result.page, 0);
    expect(result.size, 10);
    expect(result.content.first, isA<Video>());

    print('--- VIDEOS RECIBIDOS ---');
    for (final video in result.content) {
      print(video.toString());
    }
  });
}