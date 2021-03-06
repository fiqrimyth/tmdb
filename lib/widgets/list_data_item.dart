import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tmdb/const/constant.dart';
import 'package:tmdb/model/init_data.dart';
import 'package:tmdb/screen/movie/moviedetails/movie_details_screen.dart';
import 'package:tmdb/screen/my_list_screen.dart';
import 'package:tmdb/screen/tv/tv_details_screen.dart';
import 'package:tmdb/widgets/placeholder_image.dart';

class ListDataItem extends StatelessWidget {
  final InitData initData;
  ListDataItem(this.initData);

  Route _buildRoute() {
    return MaterialPageRoute(
        builder: (context) => initData.mediaType == MediaType.Movie
            ? MovieDetailsScreen()
            : TVDetailsScreen(),
        settings: RouteSettings(arguments: initData));
  }

  String _getGenres(List<dynamic> genreIDs) {
    String str = '';

    if (genreIDs == null || genreIDs.length == 0)
      str = 'N/A';
    else {
      if (initData.mediaType == MediaType.Movie)
        str += MOVIE_GENRES[genreIDs[0]];
      else
        str += TV_GENRES[genreIDs[0]];
    }
    return str;
  }

  @override
  Widget build(BuildContext context) {
    // print(data);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(_buildRoute());
      },
      highlightColor: Colors.black,
      splashColor: Colors.black,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 80,
          child: initData.posterUrl == null
              ? PlaceHolderImage(initData.title)
              : CachedNetworkImage(
                  imageUrl: initData.posterUrl,
                  fit: BoxFit.cover,
                ),
        ),
        title: Text(
          initData.title,
          style: TextStyle(
            fontSize: 16,
            // fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.87),
          ),
        ),
        subtitle: Text(
          initData.genreIDs == null ? 'N/A' : _getGenres(initData.genreIDs),
          style: kSubtitle1,
        ),
        trailing: Text(
          '${initData.releaseDate.year}',
          style: kSubtitle1,
        ),
      ),
    );
  }
}
