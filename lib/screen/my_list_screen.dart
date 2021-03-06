import 'package:flutter/material.dart';
import 'package:tmdb/const/constant.dart';
import 'package:tmdb/screen/movies_list.dart';
import 'package:tmdb/screen/search/tabs.dart';
import 'package:tmdb/screen/tv_list.dart';

enum MediaType {
  TV,
  Movie,
}

class MyListsScreen extends StatefulWidget {
  @override
  _MyListsScreenState createState() => _MyListsScreenState();
}

class _MyListsScreenState extends State<MyListsScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // ignore: unused_field
  bool _isEditing = false;

  TabController _tabController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _changeTab(int newIndex) {
    setState(() {
      currentIndex = newIndex;
      _tabController.index = newIndex;
    });
  }

  List<Widget> _getTabs() {
    return [
      Tab(child: Text('Movies')),
      Tab(icon: Text('TV Shows')),
    ];
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        MoviesLists(),
        TVshowsLists(),
      ],
    );
  }

  Widget _buildTabBar() {
    return Tabs(
      tabs: _getTabs(),
      controller: _tabController,
      onTap: _changeTab,
      isScrollable: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: NestedScrollView(
          headerSliverBuilder: (ctx, _) {
            return [
              SliverAppBar(
                backgroundColor: BASELINE_COLOR,
                centerTitle: false,
                title: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    'My Lists',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.87)),
                  ),
                ),
                pinned: false,
              ),
              SliverAppBar(
                // elevation: 10,

                backgroundColor: BASELINE_COLOR,
                expandedHeight: 70,
                pinned: true,
                title: Container(
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          width: 300,
                          child: _buildTabBar(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: _buildTabContent(),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
