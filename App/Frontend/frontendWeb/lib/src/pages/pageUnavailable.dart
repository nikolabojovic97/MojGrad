import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';

class PageUnavailable extends StatelessWidget {
  const PageUnavailable({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Traženoj strani nije moguće pristupiti.",
          style: appBarTitle,
        ),
      ),
    );
  }
}