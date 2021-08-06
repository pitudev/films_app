import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  String? get searchFieldLabel => 'Buscar película';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(onPressed: () => query = '', icon: Icon(Icons.clear))];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('Build Results');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptyContainer();
    }

    print('HTTP request');

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return StreamBuilder(
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData){
          return _emptyContainer();
        }

        final movies = snapshot.data!;

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: ( _ , int index) => _MovieResultItem(movies[index])
        );
      },
      stream: moviesProvider.suggestionsStream,
    );
  }


  Widget _emptyContainer(){
      return Container(
          child: Center(
        child: Icon(
          Icons.movie_creation_outlined,
          color: Colors.red,
          size: 100,
        ),
      ));
  }
}

class _MovieResultItem extends StatelessWidget {

    final Movie movie;

    const _MovieResultItem(this.movie);

    @override
    Widget build(BuildContext context) {

      movie.heroId = 'search-${movie.id}';

      return ListTile(
        leading: Hero(
          tag: movie.heroId!,
          child: FadeInImage(
            placeholder: AssetImage('assets/no-image.jpg'),
            image: NetworkImage(movie.fullPosterImg), 
            width: 50, 
            fit: BoxFit.contain
          ),
        ),

        title: Text(movie.title),
        subtitle: Text(movie.originalTitle),
        onTap: () => {
          Navigator.pushNamed(context, 'details', arguments: movie)
        },
      );
    }
  }
