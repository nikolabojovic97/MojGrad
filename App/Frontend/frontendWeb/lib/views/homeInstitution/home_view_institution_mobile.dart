import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/widgets/appbar.dart';
import 'package:frontendWeb/widgets/sidebar_menu_institution.dart';

class HomeInstitutionMobile extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final StatelessWidget view;
  HomeInstitutionMobile(this.view, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: SidebarMenuInstitution(),
      key: _scaffoldKey,
      appBar: appBarWidgetMobile(Icons.account_balance),
      body: Material(
        child: view
      ),
    );
  }
}