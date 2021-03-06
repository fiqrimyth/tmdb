import 'package:flutter/material.dart';
import 'package:tmdb/const/constant.dart';
import 'package:tmdb/widgets/movie/movie_item.dart';

class Grid extends StatelessWidget {
  final items;
  final String storageKey;
  final bool isRound;
  Grid({this.items, this.storageKey, this.isRound = false});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: PageStorageKey(storageKey),

      padding: const EdgeInsets.only(
          left: DEFAULT_PADDING, right: 5), // fix mainAxisSpacing error
      itemCount: items.length > 20 ? 20 : items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
            // Padding set because error is thrown when mainAxisSpacing is set
            padding: const EdgeInsets.only(right: 10),
            child: MovieItem(item: item, isRound: isRound));
      },
      addAutomaticKeepAlives: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: isRound ? 2 / 3 : 1.5,
      ),
      scrollDirection: Axis.horizontal,
    );
  }
}
