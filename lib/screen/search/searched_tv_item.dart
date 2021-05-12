import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/const/constant.dart';
import 'package:tmdb/model/init_data.dart';
import 'package:tmdb/model/tv_model.dart';
import 'package:tmdb/providers/search.dart';
import 'package:tmdb/screen/tv/tv_details_screen.dart';
import 'package:tmdb/widgets/placeholder_image.dart';

class SearchedTVItem extends StatelessWidget {
  final TVModel item;
  SearchedTVItem(this.item);

  // ignore: unused_element
  Route _buildRoute([bool searchHistoryItem = false]) {
    final initData = InitData.formObject(item);
    return MaterialPageRoute(
        builder: (context) => TVDetailsScreen(),
        settings: RouteSettings(arguments: initData));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.black,
      splashColor: Colors.transparent,
      onTap: () {
        Provider.of<Search>(context, listen: false).addToSearchHistory(item);
        Navigator.of(context).push(_buildRoute());
      },
      child: ListTile(
        isThreeLine: false,
        leading: Container(
          height: 65,
          width: 50,
          child: item.posterUrl == null
              ? PlaceHolderImage(item.title)
              : CachedNetworkImage(
                  imageUrl: item.posterUrl,
                  fit: BoxFit.cover,
                ),
        ),
        title: Text(
          item.title ?? 'N/A',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white.withOpacity(0.87),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: <Widget>[
            Text(item.voteAverage == null ? 'N/A' : item.voteAverage.toString(),
                style: kSubtitle1),
            SizedBox(width: 5),
            Icon(Icons.favorite_border, color: Theme.of(context).accentColor)
          ],
        ),
        trailing: Text(item.date == null ? 'N/A' : item.date.year.toString(),
            style: kSubtitle1),
      ),
    );
  }
}
