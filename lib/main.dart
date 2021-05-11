import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/const/constant.dart';
import 'package:tmdb/providers/cast.dart';
import 'package:tmdb/providers/list.dart';
import 'package:tmdb/providers/movies.dart';
import 'package:tmdb/providers/search.dart';
import 'package:tmdb/providers/tv.dart';
import 'package:tmdb/screen/main_screen.dart';
import 'package:tmdb/screen/movie/cast/cast_detail.screen.dart'
    show CastDetails;
import 'package:tmdb/screen/movie/moviedetails/movie_details_screen.dart';
import 'package:tmdb/screen/movie/top_rated_screen.dart';
import 'package:tmdb/screen/movie/trending_movie_screen.dart';
import 'package:tmdb/screen/video_pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(BASELINE_COLOR);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Movies()),
        ChangeNotifierProvider.value(value: Cast()),
        ChangeNotifierProvider.value(value: TV()),
        ChangeNotifierProvider.value(value: Lists()),
        ChangeNotifierProvider.value(value: Search()),
      ],
      child: MaterialApp(
        title: "tmdb",
        theme: ThemeData(
          primaryColor: Colors.black,
          applyElevationOverlayColor: true,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          accentColor: Colors.pink,
          scaffoldBackgroundColor: BASELINE_COLOR,
          appBarTheme: AppBarTheme(elevation: 0, color: ONE_LEVEL_ELEVATION),
          errorColor: Hexcolor('#B00020'),
        ),
        home: MainScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          MainScreen.routeName: (ctx) => MainScreen(),
          MovieDetailsScreen.routeName: (ctx) => MovieDetailsScreen(),
          TrendingMoviesScreen.routeName: (ctx) => TrendingMoviesScreen(),
          TopRated.routeName: (ctx) => TopRated(),
          VideoPage.routeName: (ctx) => VideoPage(),
          CastDetails.routeName: (ctx) => CastDetails(),
        },
      ),
    );
  }
}
