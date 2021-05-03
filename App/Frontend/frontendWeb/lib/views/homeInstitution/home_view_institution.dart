import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/enums/confirm.dart';
import 'package:frontendWeb/responsive/screen_type_layout.dart';
import 'package:frontendWeb/services/userServices.dart';
import 'package:frontendWeb/src/pages/pageUnavailable.dart';
import 'package:frontendWeb/utils/app_routes.dart';
import 'package:provider/provider.dart';

import 'home_view_institution_desktop.dart';
import 'home_view_institution_mobile.dart';
import 'home_view_institution_tablet.dart';

class HomeViewInstitution extends StatelessWidget {
  final StatelessWidget view;
  HomeViewInstitution(this.view, {Key key}) : super(key: key);

  final String title = "Odjava";
  final String content = "Da li ste sigurni da želite da se odjavite?";

  @override
  Widget build(BuildContext context) {
    if (Provider.of<UserService>(context, listen: false).user == null)
      return Center(child: CircularProgressIndicator());
    else if (Provider.of<UserService>(context, listen: false).isAdmin)
      return PageUnavailable();

    void logout(context) async {
      Provider.of<UserService>(context, listen: false).logout();
      Navigator.pushReplacementNamed(context, AppRoutes.welcome);
    }

    Future<bool> _onBack() async {
      var res = await asyncConfirmDialog(context, title, content);

      if (res == ConfirmAction.ACCEPT) {
        logout(context);
        return true;
      }
      
      return false;
    }

    return WillPopScope(
      onWillPop: _onBack,
      child: ScreenTypeLayout(
        mobile: HomeInstitutionMobile(view),
        tablet: HomeInstitutionTablet(view),
        desktop: HomeInstitutionDesktop(view),
      ),
    );
  }

  Future<ConfirmAction> asyncConfirmDialog(BuildContext context, String title, String content) async {
    return showDialog<ConfirmAction> (
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titleTextStyle: alertTitle,
          contentTextStyle: alertContent,
          title: Text(
            title,
          ),
          content: Text(
            content,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          actions: [
            FlatButton(
              child: Text(
                "Da",
                style: alertOption,
              ),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            ),
            FlatButton(
              child: Text(
                "Ne",
                style: alertOption,
              ),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
          ],
        );
      }
    );
  }
}