import 'dart:async';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:peliculas_app/helpers/debouncer.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/models/now_playing_response.dart';
import 'package:peliculas_app/models/most_popular_response.dart';

class MoviesProvider extends ChangeNotifier {
  String _baseUrl = 'api.themoviedb.org';
  String _apiKey = '41333e995120235be9a8b831f8ad3c5e';
  String _lang = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> mostPopularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(duration: Duration(milliseconds: 500),);

  final StreamController<List<Movie>> _suggestionsStreamController = new StreamController.broadcast();

  Stream<List<Movie>> get suggestionsStream => this._suggestionsStreamController.stream;

  MoviesProvider() {
    print('MoviesProvider started');
    this.getOnDisplayMovies();
    this.getMostPopularMovies();
  }

  Future<String> _getRequest(String path, [int page = 1]) async {
    final url = Uri.https(_baseUrl, path,
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

  Future<List<Cast>> getMovieCast( int movieId ) async {

    if (moviesCast.containsKey(movieId)){
      return moviesCast[movieId]!;
    } 

    final response = await _getRequest('3/movie/$movieId/credits');

    final creditsResponse = CreditsResponse.fromJson(response);

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;

  }

  Future<List<Movie>> searchMovies( String query ) async {

    final url = Uri.https(_baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _lang, 'query':query});

    final response = await http.get(url);

    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;

  }

  void getSuggestionsByQuery( String searchTerm ){
    debouncer.value = '';
    debouncer.onValue = ( value ) async {
      final results = await this.searchMovies(value);
      this._suggestionsStreamController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), ( _ ) { 
      debouncer.value = searchTerm;
    });

    Future.delayed(Duration(milliseconds: 301)).then(( _ ) => timer.cancel());
  }
}
