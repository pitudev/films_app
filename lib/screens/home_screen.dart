import 'package:flutter/material.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:peliculas_app/search/search_delegate.dart';
import 'package:peliculas_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Películas en cines'),
        elevation: 0,
        actions: [
          IconButton(onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()), icon: Icon(Icons.search))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
        children: [
            
            CardSwiper( movies: moviesProvider.onDisplayMovies ),
            //TODO: horizontal list of films
            MovieSlider( movies: moviesProvider.mostPopularMovies, title: 'Lo + visto', onNextPage: () => moviesProvider.getMostPopularMovies()),
            
        ],),)
    );
  }
}