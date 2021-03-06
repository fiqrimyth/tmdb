import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';
import 'package:tmdb/providers/tv.dart';
import 'package:tmdb/widgets/loading_indicator.dart';
import 'package:tmdb/widgets/top_bar.dart';
import 'package:tmdb/widgets/tv/tv_item.dart' as wid;

class Genre extends StatefulWidget {
  final int id;
  Genre(this.id);
  @override
  _GenreState createState() => _GenreState();
}

enum MovieLoaderStatus {
  STABLE,
  LOADING,
}

class _GenreState extends State<Genre> {
  bool _initLoaded = true;
  bool _isLoading = false;
  bool _isFetching = true;
  ScrollController scrollController;
  MovieLoaderStatus loaderStatus = MovieLoaderStatus.STABLE;
  CancelableOperation movieOperation;
  int curPage = 1;

  var movies = [];
  int genreId;

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

  Widget _buildLoadingIndicator(BuildContext context) {
    return Center(
      child: LoadingIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print('------------> length: ${movies.length}');
    final items = Provider.of<TV>(context).genre;
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          child: TopBar(
            title: 'Action',
          ),
          preferredSize: Size.fromHeight(kToolbarHeight),
        ),
        body: _isFetching
            ? _buildLoadingIndicator(context)
            : Column(
                children: [
                  Flexible(
                    child: NotificationListener(
                      onNotification: onNotification,
                      child: RefreshIndicator(
                        // ignore: missing_return
                        onRefresh: () {},
                        // onRefresh: () => _refreshMovies(movies.length == 0),
                        backgroundColor: Theme.of(context).primaryColor,
                        child: GridView.builder(
                          controller: scrollController,
                          // key: PageStorageKey('GenreItem'),
                          cacheExtent: 12,
                          itemCount: items.length,
                          itemBuilder: (ctx, i) {
                            return wid.TVItem(
                              item: items[i],
                              // tappable: true,
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1 / 2,
                            // crossAxisSpacing: 5,
                            // mainAxisSpacing: 5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_isLoading) _buildLoadingIndicator(context),
                ],
              ),
      ),
    );
  }
}
