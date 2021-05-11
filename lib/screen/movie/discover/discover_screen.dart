import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/const/constant.dart';
import 'package:tmdb/providers/cast.dart' as castProv;
import 'package:tmdb/providers/movies.dart';
import 'package:tmdb/providers/tv.dart';
import 'package:tmdb/screen/movie/discover/widgets/dynamic_app_bar.dart';
import 'package:tmdb/screen/movie/discover/widgets/grid.dart';
import 'package:tmdb/screen/movie/discover/widgets/trending_actors.dart';
import 'package:tmdb/screen/movie/movie_genre_item_screen.dart';
import 'package:tmdb/screen/movie/top_rated_screen.dart';
import 'package:tmdb/screen/movie/trending_movie_screen.dart';
import 'package:tmdb/screen/movie/upcoming_screen.dart';
import 'package:tmdb/screen/tv/on_air_screen.dart';
import 'package:tmdb/screen/tv/popular_screen.dart';
import 'package:tmdb/screen/tv/top_rated_screen.dart';
import 'package:tmdb/widgets/loading_indicator.dart';
import 'package:tmdb/widgets/movie/in_theaters.dart';
import 'package:tmdb/widgets/section_title.dart';

class DiscoverScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<DiscoverScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  bool _initLoaded = true;
  bool _isLoading = true;
  TabController _tabController;

  static const SECTION_HEIGHT = 0.35;

  bool showTitle = false;

  ScrollController _scrollController;
  // double _scrollPosition = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    if (_initLoaded) {
      // Fetch movies
      Provider.of<Movies>(context, listen: false).fetchTrending(1);
      Provider.of<Movies>(context, listen: false).fetchUpcoming(1);
      Provider.of<Movies>(context, listen: false).fetchForKids(1);
      Provider.of<castProv.Cast>(context, listen: false).getPopularPeople(1);
      Provider.of<Movies>(context, listen: false)
          .fetchTopRated(1)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
      // Fetch TV shows
      Provider.of<TV>(context, listen: false).fetchPopular(1);
      Provider.of<TV>(context, listen: false).fetchOnAirToday(1);
      Provider.of<TV>(context, listen: false).fetchTopRated(1);
      Provider.of<TV>(context, listen: false).fetchForKids(1);
    }
    _initLoaded = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Route _buildRoute(Widget child) {
    return MaterialPageRoute(
      builder: (context) => child,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final trending = Provider.of<Movies>(context).trending;
    final upcoming = Provider.of<Movies>(context).upcoming;
    final topRated = Provider.of<Movies>(context).topRated;
    final forKids = Provider.of<Movies>(context).forKids;
    final trendingActors = Provider.of<castProv.Cast>(context).popularPeople;

    // Tv
    final tvPopular = Provider.of<TV>(context, listen: false).trending;
    final tvOnAirToday = Provider.of<TV>(context, listen: false).onAirToday;
    final tvTopRated = Provider.of<TV>(context, listen: false).topRated;
    final forKidsTV = Provider.of<TV>(context, listen: false).forKids;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: LayoutBuilder(
          builder: (ctx, constraints) {
            //  height of each section
            double sectionHeight = constraints.maxHeight * SECTION_HEIGHT;
            double inTheatersGridHeight = constraints.maxHeight * 0.3;
            double trendingActorsHeight = constraints.maxHeight * 0.15;
            double forKidsHeight = constraints.maxHeight * 0.2;
            return Stack(
              children: [
                ListView(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.only(bottom: kToolbarHeight, top: 20),
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: DEFAULT_PADDING),
                      child: Text('Discover',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.87),
                          )),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: inTheatersGridHeight,
                      child: InTheatersGrid(),
                    ),
                    SectionTitle(
                      title: 'Trending',
                      onTap: () {
                        Navigator.of(context)
                            .push(_buildRoute(TrendingMoviesScreen()));
                      },
                    ),
                    Container(
                        height: sectionHeight,
                        child: _isLoading
                            ? LoadingIndicator()
                            : Grid(
                                items: trending,
                                storageKey: 'Movie-Trending',
                              )),
                    SectionTitle(
                      title: 'Upcoming',
                      onTap: () {
                        Navigator.of(context)
                            .push(_buildRoute(UpcomingScreen()));
                      },
                    ),
                    Container(
                        height: sectionHeight,
                        child: _isLoading
                            ? LoadingIndicator()
                            : Grid(
                                items: upcoming,
                                storageKey: 'Movie-Upcoming',
                              )),

                    SectionTitle(
                      title: 'For Kids',
                      onTap: () {
                        Navigator.of(context)
                            .push(_buildRoute(MovieGenreItem(16)));
                      },
                    ),
                    Container(
                        height: forKidsHeight,
                        child: _isLoading
                            ? LoadingIndicator()
                            : Grid(
                                items: forKids,
                                storageKey: 'Movie-For_Kids',
                                isRound: true,
                              )),
                    SectionTitle(
                      title: 'Top Rated',
                      onTap: () {
                        Navigator.of(context).push(_buildRoute(TopRated()));
                      },
                    ),
                    Container(
                        height: sectionHeight,
                        child: _isLoading
                            ? LoadingIndicator()
                            : Grid(
                                items: topRated,
                                storageKey: 'Movie-Top_Rated',
                              )),

                    SectionTitle(
                      title: 'Trending Actors',
                      onTap: () {},
                      withSeeAll: false,
                    ),
                    Container(
                        height: trendingActorsHeight,
                        child: _isLoading
                            ? LoadingIndicator()
                            : TrendingActors(actors: trendingActors)),

                    // TV shows
                    SectionTitle(
                      title: 'Popular',
                      onTap: () {
                        Navigator.of(context)
                            .push(_buildRoute(TrendingTVScreen()));
                      },
                    ),
                    Container(
                        height: sectionHeight,
                        child: _isLoading
                            ? LoadingIndicator()
                            : Grid(
                                items: tvPopular,
                                storageKey: 'TV-Popular',
                              )),
                    SectionTitle(
                      title: 'On Air Today',
                      onTap: () {
                        Navigator.of(context).push(_buildRoute(OnAirScreen()));
                      },
                    ),
                    Container(
                        height: sectionHeight,
                        child: _isLoading
                            ? LoadingIndicator()
                            : Grid(
                                items: tvOnAirToday,
                                storageKey: 'TV-On-Air-Today',
                              )),
                    SectionTitle(
                      title: 'For Kids',
                      onTap: () {
                        Navigator.of(context)
                            .push(_buildRoute(MovieGenreItem(10762)));
                      },
                    ),
                    Container(
                        height: constraints.maxHeight * 0.2,
                        child: _isLoading
                            ? LoadingIndicator()
                            : Grid(
                                items: forKidsTV,
                                storageKey: 'TV-For_Kids',
                                isRound: true,
                              )),
                    SectionTitle(
                      title: 'Top Rated',
                      onTap: () {
                        Navigator.of(context)
                            .push(_buildRoute(TopRatedScreen()));
                      },
                    ),
                    Container(
                        height: sectionHeight,
                        child: _isLoading
                            ? LoadingIndicator()
                            : Grid(
                                items: tvTopRated, storageKey: 'TV-Top-Rated')),
                    // Text(_scrollController.position.pixels.toString(), style: kTitleStyle2,)
                  ],
                ),
                DynamicAppBar(
                    scrollController: _scrollController,
                    constraints: constraints)
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
