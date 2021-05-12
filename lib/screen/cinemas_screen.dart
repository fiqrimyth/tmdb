import 'package:flutter/material.dart';
import 'package:tmdb/const/constant.dart';

class CinemasScreen extends StatefulWidget {
  @override
  _CinemasScreenState createState() => _CinemasScreenState();
}

class _CinemasScreenState extends State<CinemasScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Coming soon...', style: kTitleStyle),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
