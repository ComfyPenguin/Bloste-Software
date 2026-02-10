import 'package:blosteflix2/domain/entities/video.dart';
import 'package:blosteflix2/infrastructure/data_sources/catalogo_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final api = CatalogoApi('http://localhost:8080');

  test('Devuelve 1 video', () async {
    final result = await api.getVideosID(1);

    expect(result, isA<Video>());

    print('--- VIDEO RECIBIDO ---');
    print(result.toString());
  });
}