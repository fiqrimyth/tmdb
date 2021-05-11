import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/const/constant.dart';
import 'package:tmdb/model/init_data.dart';
import 'package:tmdb/model/movie_model.dart';
import 'package:tmdb/providers/movies.dart';
import 'package:tmdb/screen/movie/moviedetails/widgets/background_and_title.dart';
import 'package:tmdb/screen/movie/moviedetails/widgets/bottomicons/bottom_icons.dart';
import 'package:tmdb/screen/movie/moviedetails/widgets/details.dart';
import 'package:tmdb/screen/movie/moviedetails/widgets/movie_cast.dart';
import 'package:tmdb/screen/movie/moviedetails/widgets/movie_images.dart';
import 'package:tmdb/screen/movie/moviedetails/widgets/overview.dart';
import 'package:tmdb/screen/movie/moviedetails/widgets/reviews.dart';
import 'package:tmdb/screen/movie/moviedetails/widgets/similiar_movies.dart';
import 'package:tmdb/widgets/back_button.dart';
import 'package:tmdb/widgets/loading_indicator.dart';
import 'package:tmdb/widgets/section_title.dart';

class MovieDetailsScreen extends StatefulWidget {
  static const routeName = '/details-screen-movies';
  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool _isInitLoaded = true;
  bool _isLoading = true;
  InitData initData;
  MovieModel film;

  TextEditingController _textEditingController;

  AnimationController _animationController;
  Animation<Offset> _animation;
  // ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..forward();
    _animation = Tween<Offset>(begin: Offset(1, 0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    Future.delayed(Duration.zero).then((value) {
      initData = ModalRoute.of(context).settings.arguments as InitData;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInitLoaded) {
      final initData = ModalRoute.of(context).settings.arguments as InitData;
      // print('movie----------> $initData');
      Provider.of<Movies>(context, listen: false)
          .getMovieDetails(initData.id)
          .then((value) {
        setState(() {
          // Get film item
          film = Provider.of<Movies>(context, listen: false).movieDetails;
          _isLoading = false;
          _isInitLoaded = false;
        });
      });
    }

    super.didChangeDependencies();
  }

  Widget _buildSimilarMovies(BoxConstraints constraints) {
    if (film.similar.isEmpty) {
      return Container();
    } else {
      return Container(
        height: constraints.maxHeight * 0.3,
        child: SimilarMovies(film),
      );
    }
  }

  List<Widget> _buildReviews() {
    if (film.reviews.isNotEmpty)
      return [
        SectionTitle(title: 'Reviews', withSeeAll: false, bottomPadding: 5),
        Reviews(film),
      ];
    return [Container(height: 0, width: 0)];
  }

  // Builds parts that needs detailed film to be fetched
  List<Widget> _buildOtherDetails(BoxConstraints constraints, int id) {
    // print('DetailsPage ---------------------> ${film.videos}');
    return [
      if (film.images != null && film.images.length > 0)
        Container(
            height: constraints.maxHeight * 0.20,
            child: MovieImages(movie: film)),
      SizedBox(height: 20),
      Details(movie: film),
      SizedBox(height: 30),
      MovieCast(movie: film),
      SizedBox(height: 30),
      _buildSimilarMovies(constraints),
      ..._buildReviews(),
      SizedBox(height: 10),
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    initData = ModalRoute.of(context).settings.arguments as InitData;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            LayoutBuilder(
              builder: (ctx, constraints) {
                return ListView(
                  children: [
                    BackgroundAndTitle(
                      initData: initData,
                      film: film,
                      constraints: constraints,
                      isLoading: _isLoading,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 5,
                        left: DEFAULT_PADDING,
                        right: DEFAULT_PADDING,
                      ),
                      child: Text('Storyline', style: kTitleStyle3),
                    ),
                    _isLoading
                        ? Container(
                            height: constraints.maxHeight * 0.3,
                            child: LoadingIndicator(),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                              // vertical: 10,
                              horizontal: DEFAULT_PADDING,
                            ),
                            child: Overview(
                                initData: film, constraints: constraints),
                          ),
                    if (initData != null)
                      Container(
                        height: constraints.maxHeight * 0.1,
                        child: BottomIcons(initData: initData),
                      ),
                    SizedBox(height: 20),
                    if (!_isLoading)
                      ..._buildOtherDetails(constraints, initData.id)
                    else
                      Padding(
                          padding: const EdgeInsets.only(
                              top:
                                  50), // so the loading indicator is at overview place
                          child: LoadingIndicator()),
                  ],
                );
              },
            ),
            // TopBar(title: 'title'),
            Positioned(
              top: 10,
              left: 0,
              child: CustomBackButton(),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
