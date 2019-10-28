import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {
  
  String _apiKey = '305aa7a9d3a51627ba9a672d87167914';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _loading = false;

  // BLOC
  List<Pelicula> _populares = new List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams(){
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  } 

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apiKey, 'language': _language});

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {

    if( _loading ) return [];
    _loading = true;

    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apiKey,
       'language': _language,
       'page': _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url); 

    _populares.addAll(resp);

    popularesSink( _populares );

    _loading = false;
    return resp;

  }

  // API para obtener los actores de la pelicula.
  Future<List<Actor>> getCast( String peliculaId ) async {

    final url = Uri.https(_url, '3/movie/$peliculaId/credits', {
      'api_key': _apiKey,
       'language': _language
    });

    final resp = await http.get(url);
    final decodedData = json.decode( resp.body );

    final cast = new Cast.fromJsonList(decodedData['cast']);
    return cast.actors;
  } 

  Future<List<Pelicula>> searchMovie( String query) async {
    
    final url = Uri.https(_url, '3/search/movie', {
          'api_key': _apiKey, 
          'language': _language,
          'query' : query
    });

    return await _procesarRespuesta(url);
  }

}
