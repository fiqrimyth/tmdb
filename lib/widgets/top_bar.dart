import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tmdb/const/constant.dart';

class TopBar extends StatelessWidget {
  @required
  final String title;
  final bool opaque;

  TopBar({this.title, this.opaque = false});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: kToolbarHeight,
        decoration: BoxDecoration(color: ONE_LEVEL_ELEVATION),
        child: Row(
          children: [
            BackButton(color: Hexcolor('#DEDEDE')),
            Expanded(
              child: Align(
                alignment: Alignment.center - Alignment(0.2, 0),
                child: Padding(
                  padding: const EdgeInsets.only(right: 3.0),
                  child: Text(
                    title,
                    style: kTitleStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
