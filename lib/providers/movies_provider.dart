import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/models/now_playing_response.dart';
import 'package:peliculas_app/models/most_popular_response.dart';

class MoviesProvider extends ChangeNotifier {
  String _baseUrl = 'api.themoviedb.org';
  String _apiKey = '41333e995120235be9a8b831f8ad3c5e';
  String _lang = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> mostPopularMovies = [];

  int _popularPage = 0;

  MoviesProvider() {
    print('MoviesProvider started');
    this.getOnDisplayMovies();
    this.getMostPopularMovies();
  }

  Future<String> _getRequest(String path, [int page = 1]) async {
    var url = Uri.https(_baseUrl, path,
        {'api_key': _apiKey, 'language': _lang, 'page': '$page'});

    final response = await http.get(url);

    return response.body;
  }

  getOnDisplayMovies() async {
    final response = await _getRequest('3/movie/now_playing');

    final nowPlayingResponse = NowPlayingResponse.fromJson(response);

    onDisplayMovies = nowPlayingResponse.results;

    notifyListeners();
  }

  getMostPopularMovies() async {

    _popularPage++;

    final response = await _getRequest('3/movie/popular', _popularPage);

    final mostPopularResponse = MostPopularResponse.fromJson(response);

    mostPopularMovies = mostPopularResponse.results;

    notifyListeners();
  }
}
