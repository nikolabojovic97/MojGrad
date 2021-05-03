import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';

Widget appBarWidget(icon) {
  return AppBar(
    iconTheme: new IconThemeData(color: Colors.lightGreen),
    automaticallyImplyLeading: false,
    backgroundColor: contentBgColor,
    centerTitle: true,
    title: Text(
      'Moj grad',
      style: appBarTitle,
    ),
    actions: [
      Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          onTap: () {},
          child: Icon(
            icon,
            size: 26.0,
          ),
        )
      )
    ],
  );
}

Widget appBarWidgetMobile(icon) {
  return AppBar(
    iconTheme: new IconThemeData(color: Colors.lightGreen),
    automaticallyImplyLeading: true,
    backgroundColor: contentBgColor,
    centerTitle: true,
    title: Text(
      'Moj grad',
      style: appBarTitle,
    ),
    actions: [
      Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          onTap: () {},
          child: Icon(
            icon,
            size: 26.0,
          ),
        )
      )
    ],
  );
}