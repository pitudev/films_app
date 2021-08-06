import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/providers/movies_provider.dart';

class MovieSlider extends StatefulWidget {

    final List<Movie> movies;
    final String? title;
    final Function onNextPage;

  const MovieSlider({Key? key, required this.movies, this.title, required this.onNextPage}) : super(key: key);

  @override
  _MovieSliderState createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

    final ScrollController scrollController = new ScrollController();

    @override
    void initState() {
      super.initState();

      scrollController.addListener(() { 
      
      if(scrollController.position.maxScrollExtent < scrollController.position.pixels + 500){
        widget.onNextPage();
      } });
    }

    @override
    void dispose(){

      super.dispose();
    }


  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      height: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text( this.widget.title! ,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
          Expanded(
            child: ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: widget.movies.length,
                itemBuilder: (_, int index) => _MoviePoster(widget.movies[index])),
          ),
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {

  final Movie movie;

  const _MoviePoster(this.movie);


  @override
  Widget build(BuildContext context) {


    movie.heroId = 'slider-${movie.id}';

    return Container(
      width: 130,
      height: 200,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(movie.fullPosterImg),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
