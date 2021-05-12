import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import './bottom_bar.dart';

class BottomTabs extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  BottomTabs({
    this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: BottomBar(
        currentIndex: currentIndex,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/home.svg',
                width: 25, height: 25, color: Colors.white.withOpacity(0.7)),
            activeIcon: SvgPicture.asset('assets/svg/Home_solid.svg',
                width: 25, height: 25, color: Theme.of(context).accentColor),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/Search.svg',
                width: 25, height: 25, color: Colors.white.withOpacity(0.7)),
            activeIcon: SvgPicture.asset('assets/svg/Search.svg',
                width: 25, height: 25, color: Theme.of(context).accentColor),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/list.svg',
                width: 25, height: 25, color: Colors.white.withOpacity(0.7)),
            activeIcon: SvgPicture.asset('assets/svg/list_solid.svg',
                width: 25, height: 25, color: Theme.of(context).accentColor),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.location),
            activeIcon: Icon(CupertinoIcons.location_solid),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/Profile.svg',
                width: 25, height: 25, color: Colors.white.withOpacity(0.7)),
            activeIcon: SvgPicture.asset('assets/svg/Profile.svg',
                width: 25, height: 25, color: Theme.of(context).accentColor),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
