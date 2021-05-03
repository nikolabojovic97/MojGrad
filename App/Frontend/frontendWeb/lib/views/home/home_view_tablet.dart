import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/widgets/appbar.dart';
import 'package:frontendWeb/widgets/sidebar_menu.dart';

class HomeTablet extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final StatelessWidget view;
  HomeTablet(this.view, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      key: _scaffoldKey,
      body: Material(
        child: Row(
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
              child: SidebarMenu(),
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
                    child: appBarWidget(Icons.verified_user),
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
      ),
    );
  }
}
