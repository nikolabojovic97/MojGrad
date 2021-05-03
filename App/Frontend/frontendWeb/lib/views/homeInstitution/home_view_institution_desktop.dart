import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/widgets/appbar.dart';
import 'package:frontendWeb/widgets/sidebar_menu_institution.dart';

class HomeInstitutionDesktop extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final StatelessWidget view;
  HomeInstitutionDesktop(this.view, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      key: _scaffoldKey,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5
                ),
              ] 
            ),
            child: SidebarMenuInstitution(),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  child: appBarWidget(Icons.account_balance),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: view,
                ),
              ],
            ),
          ),
        ],
      ),
      
    );
  }
}