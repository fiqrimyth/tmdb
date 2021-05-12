import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/const/constant.dart';
import 'package:tmdb/providers/tv.dart';
import 'package:tmdb/widgets/back_button.dart';
import 'package:tmdb/widgets/loading_indicator.dart';
import 'package:tmdb/widgets/movie/movie_item.dart';
import 'package:async/async.dart';

class TVGenreItemScreen extends StatefulWidget {
  final int id;
  TVGenreItemScreen(this.id);
  @override
  _TVGenreItemScreenState createState() => _TVGenreItemScreenState();
}

enum MovieLoaderStatus {
  STABLE,
  LOADING,
}

class _TVGenreItemScreenState extends State<TVGenreItemScreen> {
  bool _initLoaded = true;
  // ignore: unused_field
  bool _isLoading = false;
  bool _isFetching = true;
  ScrollController scrollController;
  MovieLoaderStatus loaderStatus = MovieLoaderStatus.STABLE;
  CancelableOperation movieOperation;
  int curPage = 1;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    _initLoaded = true;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_initLoaded) {
      Provider.of<TV>(context, listen: false).clearGenre();
      Provider.of<TV>(context, listen: false)
          .getGenre(widget.id, 1)
          .then((value) {
        setState(() {
          _isFetching = false;
          _initLoaded = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
        if (loaderStatus != null && loaderStatus == MovieLoaderStatus.STABLE) {
          loaderStatus = MovieLoaderStatus.LOADING;
          setState(() {
            _isLoading = true;
          });
          movieOperation = CancelableOperation.fromFuture(
                  Provider.of<TV>(context, listen: false)
                      .getGenre(widget.id, curPage + 1))
              .then(
            (_) {
              loaderStatus = MovieLoaderStatus.STABLE;
              setState(() {
                curPage = curPage + 1;
                _isLoading = false;
              });
            },
          );
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // print('------------> length: ${movies.length}');
    final items = Provider.of<TV>(context).genre;
    return SafeArea(
      child: Scaffold(
        body: NotificationListener(
          onNotification: onNotification,
          child: Stack(
            children: [
              GridView.builder(
                // padding: const EdgeInsets.only(bottom: APP_BAR_HEIGHT),

                controller: scrollController,
                key: const PageStorageKey('UpcomingScreen'),
                cacheExtent: 12,
                itemCount: items.length,
                itemBuilder: (ctx, i) {
                  return MovieItem(
                    item: items[i],
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 3.5,
                  // mainAxisSpacing: 5,
                  // crossAxisSpacing: 5,
                ),
              ),
              if (_isFetching)
                Positioned.fill(
                  bottom: 10,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: LoadingIndicator(),
                  ),
                ),
              Positioned(
                top: 10,
                left: 0,
                child: CustomBackButton(text: TV_GENRES[widget.id]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
