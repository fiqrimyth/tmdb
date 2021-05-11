import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tmdb/const/constant.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  LoadingIndicator({
    this.size = LOADING_INDICATOR_SIZE,
  });
  @override
  Widget build(BuildContext context) {
    return SpinKitCircle(
      color: Theme.of(context).accentColor,
      size: size,
    );
  }
}
