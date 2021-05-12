import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/providers/list.dart';
import 'package:tmdb/providers/search.dart';
import 'package:tmdb/screen/account_screen.dart';
import 'package:tmdb/screen/cinemas_screen.dart';
import 'package:tmdb/screen/movie/discover/discover_screen.dart';
import 'package:tmdb/screen/my_list_screen.dart';
import 'package:tmdb/screen/search/search_screen.dart';
import 'package:tmdb/widgets/bottom_tab.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main-page';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  PageController _pageController;
  int _selectedIndex = 0;

  @override
  initState() {
    super.initState();

    // load lists
    Future.delayed(Duration.zero).then((value) {
      Provider.of<Lists>(context, listen: false).loadMovieLists();
      Provider.of<Lists>(context, listen: false).loadTVLists();
      Provider.of<Search>(context, listen: false).loadTopMovieGenres();
      Provider.of<Search>(context, listen: false).loadTopTVGenres();
    });
    _tabController = TabController(
      vsync: this,
      length: 5,
      initialIndex: _selectedIndex,
    );
    _pageController =
        PageController(initialPage: _selectedIndex, keepPage: true);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildTabContent() {
    return Positioned.fill(
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        pageSnapping: false,
        children: <Widget>[
          DiscoverScreen(),
          SearchScreen(),
          MyListsScreen(),
          CinemasScreen(),
          AccountScreen(),
        ],
      ),
    );
  }

  void _onTap(int newIndex) {
    setState(() {
      _selectedIndex = newIndex;
      _pageController.jumpToPage(newIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = BottomTabs(
      currentIndex: _selectedIndex,
      onTap: _onTap,
    );

    final _content = Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          _buildTabContent(),
          currentPage,
        ],
      ),
    );
    return SafeArea(child: _content);
  }
}
