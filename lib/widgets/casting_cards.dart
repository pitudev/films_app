import 'package:flutter/material.dart';

class CastingCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 30),
        width: double.infinity,
        height: 200,
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (_, int index) => _CastCard(),
          scrollDirection: Axis.horizontal,
        ));
  }
}

class _CastCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'),
                image: NetworkImage('https://via.placeholder.com/250x300'),
                height: 140,
                width: 100,
                fit: BoxFit.cover,),
          ),

          SizedBox(height: 5,),

          Text('actor.name',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,)
        ],
      ),
    );
  }
}
