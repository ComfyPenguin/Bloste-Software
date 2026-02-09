import 'dart:convert';
import 'dart:io';
import 'package:blosteflix2/domain/entities/categoria.dart';
import 'package:blosteflix2/domain/entities/video.dart';
import 'package:blosteflix2/infrastructure/dtos/extra/paginated.dart';
import 'package:blosteflix2/infrastructure/mappers/categoria_mapper.dart';
import 'package:blosteflix2/infrastructure/mappers/video_mapper.dart';
import 'package:http/http.dart' as http;

// Faltan comprobaciones de errores HTTP TO-DO
class CatalogoApi {
  String urlBase;

  //Constructor 
  CatalogoApi(this.urlBase);

  Future<Paginated<Video>> getVideos(
    {required int page, required int size, int? categoriaId}
  ) async {
    // Construir query params
    final queryParams = <String, String>{
      'page': page.toString(),
      'size': size.toString(),
    };
    if (categoriaId != null) {
      queryParams['categoriaId'] = categoriaId.toString();
    }
    final uri = Uri.parse('$urlBase/api/catalogo').replace(queryParameters: queryParams);
    // Hacer la peticion
    http.Response data = await http.get(uri);

    if (data.statusCode == HttpStatus.ok) {
      final body = utf8.decode(data.bodyBytes);
      final jsonData = jsonDecode(body) as Map<String, dynamic>;
      //Dto paginated es la clase que he creado para que dart pueda manejar el paginated de springboot, util para el scroll infinito
      return Paginated.fromJson(
        jsonData,
        (json) => VideoMapper.fromJson(json), //VideoMapper devuelve un objeto Video
      );
    } else {
      // Devuelve paginación vacía si falla
      return Paginated<Video>(
        content: [],
        page: 0,
        size: size,
        totalPages: 0,
        last: true,
      );
    }
  }

  Future<Video> getVideosID(int id) async {
    final uri = Uri.parse('$urlBase/api/catalogo/$id');
    http.Response data = await http.get(uri);

    if (data.statusCode == HttpStatus.ok) {
      final body = utf8.decode(data.bodyBytes);
      final jsonData = jsonDecode(body) as Map<String, dynamic>;
      return VideoMapper.fromJson(jsonData);
    } else {
      return Video(
        id: 0,
        idVideo: 'ERROR',
        title: '',
        categories: [],
        description: '',
        duration: 0,
        urlVideo: '',
        urlthumbnail: '',
        author: '',
        fechaSubida: DateTime.now(),
        fechaActualizacion: DateTime.now(),
      );
    }
  }

  Future <Paginated<Categoria>> getCategorias(
    {required int page, required int size}
  ) async {
    final uri = Uri.parse('$urlBase/api/categorias')
        .replace(queryParameters: {
      'page': page.toString(),
      'size': size.toString(),
    });
    http.Response data = await http.get(uri);

    if (data.statusCode == HttpStatus.ok) {
      final body = utf8.decode(data.bodyBytes);
      final jsonData = jsonDecode(body) as Map<String, dynamic>;
      return Paginated.fromJson(
        jsonData,
        (json) => CategoriaMapper.fromJson(json),
      );
    } else {
      return Paginated<Categoria>(
        content: [],
        page: 0,
        size: size,
        totalPages: 0,
        last: true,
      );
    }
  }

  Future<Categoria> getCategoriaById(int id) async {
    final uri = Uri.parse('$urlBase/api/categorias/$id');
    http.Response data = await http.get(uri);

    if (data.statusCode == HttpStatus.ok) {
      final body = utf8.decode(data.bodyBytes);
      final jsonData = jsonDecode(body) as Map<String, dynamic>;
      return CategoriaMapper.fromJson(jsonData);
    } else {
      return Categoria(
        id: 0,
        nombre: '',
      );
    }
  }
}