import 'package:flutter/material.dart';
import 'package:tmdb/const/constant.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Your Accout Info Here',
          style: kTitleStyle,
        ),
      ),
    );
  }
}
