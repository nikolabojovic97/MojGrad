import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/widgets/appbar.dart';
import 'package:frontendWeb/widgets/sidebar_menu.dart';

class HomeMobile extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final StatelessWidget view;
  HomeMobile(this.view, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: SidebarMenu(),
      key: _scaffoldKey,
      appBar: appBarWidgetMobile(Icons.verified_user),
      body: Material(
        child: view
      ),
    );
  }
}
