import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/providers/search.dart';
import 'package:tmdb/screen/search/searched_tv_item.dart';
import 'package:tmdb/widgets/loading_indicator.dart';
import 'package:async/async.dart';

enum LoaderStatus {
  STABLE,
  LOADING,
}

class TVShowsResult extends StatefulWidget {
  final bool isLoading;
  final TextEditingController searchController;
  TVShowsResult({this.searchController, this.isLoading});

  @override
  _TVShowsResultState createState() => _TVShowsResultState();
}

class _TVShowsResultState extends State<TVShowsResult> {
  int curPage = 1;
  CancelableOperation _operation;
  LoaderStatus _loaderStatus = LoaderStatus.STABLE;
  bool _isFetchingNewData = false;

  void didChangeDependencies() {
    // clear searched movies list if use not searhing
    // if (widget.searchController.text.isEmpty)
    //   Provider.of<Search>(context, listen: false).clearSeries();
    super.didChangeDependencies();
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Center(
      child: widget.searchController.text.isEmpty ? null : LoadingIndicator(),
    );
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
        if (_loaderStatus != null && _loaderStatus == LoaderStatus.STABLE) {
          _loaderStatus = LoaderStatus.LOADING;
          setState(() {
            _isFetchingNewData = true;
          });
          _operation = CancelableOperation.fromFuture(
                  Provider.of<Search>(context, listen: false)
                      .searchMovies(widget.searchController.text, curPage + 1))
              .then(
            (_) {
              _loaderStatus = LoaderStatus.STABLE;
              setState(() {
                curPage = curPage + 1;
                _isFetchingNewData = false;
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
    print('tv result build------------->');
    final tvShows = Provider.of<Search>(context).tvShows;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      // show recent search history when not searching
      child: widget.isLoading // Show loading indicator when fetching data
          ? _buildLoadingIndicator(context)
          : NotificationListener(
              onNotification: onNotification,
              child: ListView.builder(
                key: PageStorageKey('TVShowResults'),
                // controller: _scrollController,
                padding: const EdgeInsets.only(
                    bottom: kToolbarHeight, left: 10, right: 10, top: 10),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: tvShows.length,
                itemBuilder: (ctx, i) {
                  var item = tvShows[i];
                  return SearchedTVItem(item);
                },
              ),
            ),
    );
  }
}
