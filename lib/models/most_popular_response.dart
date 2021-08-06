import 'dart:convert';

import 'package:peliculas_app/models/movies.dart';

class MostPopularResponse {
    MostPopularResponse({
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    int page;
    List<Movie> results;
    int totalPages;
    int totalResults;

    factory MostPopularResponse.fromJson(String str) => MostPopularResponse.fromMap(json.decode(str));

    factory MostPopularResponse.fromMap(Map<String, dynamic> json) => MostPopularResponse(
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );

}

