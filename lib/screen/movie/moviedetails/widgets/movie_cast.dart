import 'package:flutter/material.dart';
import 'package:tmdb/const/constant.dart';
import 'package:tmdb/model/cast_model.dart';
import 'package:tmdb/model/movie_model.dart';
import 'package:tmdb/screen/search/cast_detail_screen.dart';
import 'package:tmdb/widgets/movie/cast_item.dart';
import 'package:tmdb/widgets/section_title.dart';

class MovieCast extends StatelessWidget {
  final MovieModel movie;
  MovieCast({this.movie});

  List<CastModel> extractCast() {
    List<CastModel> cast = [];
    if (movie.cast != null) {
      movie.cast.forEach((element) {
        cast.add(CastModel(
          id: element['id'],
          name: element['name'],
          character: element['character'],
          imageUrl: element['profile_path'],
          job: element['job'],
        ));
      });
    }
    return cast;
  }

  Route _buildRoute(Widget toPage, [dynamic args]) {
    return MaterialPageRoute(
      builder: (context) => toPage,
      settings: RouteSettings(arguments: args),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cast = extractCast();
    return Column(
      children: [
        SectionTitle(
          title: 'Cast',
          onTap: () {
            Navigator.of(context).push(_buildRoute(CastDetailsScreen(cast)));
          },
          topPadding: 0,
          bottomPadding: 0,
        ),
        Container(
          color: ONE_LEVEL_ELEVATION,
          height: 110,
          child: GridView.builder(
            itemCount: cast.length,
            itemBuilder: (context, i) => CastItem(cast[i]),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              // mainAxisSpacing: 5,
            ),
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );
  }
}
