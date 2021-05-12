import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/providers/tv.dart';
import 'package:tmdb/widgets/back_button.dart';
import 'package:tmdb/widgets/loading_indicator.dart';
import 'package:tmdb/widgets/movie/movie_item.dart';
import 'package:async/async.dart';

enum MovieLoaderStatus {
  STABLE,
  LOADING,
}

class OnAirScreen extends StatefulWidget {
  static const routeName = '/onAirScreen';

  OnAirScreen({
    Key key,
  }) : super(key: key);

  @override
  _AllMoviesState createState() => _AllMoviesState();
}

class _AllMoviesState extends State<OnAirScreen> {
  bool _initLoaded = true;
  bool _isFetching = false;
  ScrollController scrollController;
  MovieLoaderStatus loaderStatus = MovieLoaderStatus.STABLE;
  CancelableOperation movieOperation;
  int curPage = 1;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initLoaded) {
      Provider.of<TV>(context, listen: false).fetchOnAirToday(1);
    }
    _initLoaded = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
        if (loaderStatus != null && loaderStatus == MovieLoaderStatus.STABLE) {
          loaderStatus = MovieLoaderStatus.LOADING;
          setState(() {
            _isFetching = true;
          });
          movieOperation = CancelableOperation.fromFuture(
                  Provider.of<TV>(context, listen: false)
                      .fetchOnAirToday(curPage + 1))
              .then(
            (_) {
              loaderStatus = MovieLoaderStatus.STABLE;
              setState(() {
                curPage = curPage + 1;
                _isFetching = false;
              });
            },
          );
        }
      }
    }
    return true;
  }

  // ignore: unused_element
  Future<void> _refreshMovies(bool refresh) async {
    if (refresh)
      await Provider.of<TV>(context, listen: false).fetchOnAirToday(1);
  }

  @override
  Widget build(BuildContext context) {
    var movies = Provider.of<TV>(context).onAirToday;
    // print('------------> length: ${movies.length}');
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
                itemCount: movies.length,
                itemBuilder: (ctx, i) {
                  return MovieItem(
                    item: movies[i],
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 3.5,
                  // mainAxisSpacing: 5,
                  // crossAxisSpacing: 5,
                ),
              ),
              Positioned(
                top: 10,
                left: 0,
                child: CustomBackButton(text: 'On Air Today'),
              ),
              if (_isFetching)
                Positioned.fill(
                  bottom: 10,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: LoadingIndicator(size: 30),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
