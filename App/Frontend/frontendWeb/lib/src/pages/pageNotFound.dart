import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Tražena strana ne postoji.",
          style: appBarTitle,
        ),
      ),
    );
  }
}