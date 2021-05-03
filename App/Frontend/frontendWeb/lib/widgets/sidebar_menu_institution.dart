import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/main.dart';
import 'package:frontendWeb/models/user.dart';
import 'package:frontendWeb/services/userServices.dart';
import 'package:frontendWeb/utils/app_routes.dart';
import 'package:provider/provider.dart';

class SidebarMenuInstitution extends StatefulWidget {
  SidebarMenuInstitution({Key key}) : super(key: key);

  @override
  _SidebarMenuInstitutionState createState() => _SidebarMenuInstitutionState();
}

class _SidebarMenuInstitutionState extends State<SidebarMenuInstitution> with RouteAware {
  User _user;
  String _activeRoute;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    routeObserver.subscribe(
      this, 
      ModalRoute.of(context)
    );
  }

  @override
  void didPush() {
    _activeRoute = ModalRoute.of(context).settings.name;
  }

  @override
  void initState() {
    super.initState();
    _user = Provider.of<UserService>(context, listen: false).user;
  }

  void logout(context) async {
    Provider.of<UserService>(context, listen: false).logout();
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.welcome, (route) => false);
  }

  void navigateToPage(routeName) {
    Navigator.popAndPushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          createHeader(),
          dividerLine(0.3),
          createDrawerItem(Icons.home, "Preporučeni problemi", AppRoutes.home),
          dividerLine(0.3),
          createDrawerItem(Icons.account_balance, "Profil institucije", AppRoutes.profile),
          dividerLine(0.3),
          createDrawerItem(Icons.edit, "Izmena profila", AppRoutes.editInstitutionProfile),
          dividerLine(0.3),
          createDrawerItem(FontAwesomeIcons.signOutAlt, "Odjavite se", null),
        ],
      ),
    );
  }

  Widget createHeader() {
    return _user == null ? Center(child: CircularProgressIndicator()) : DrawerHeader(
      padding: EdgeInsets.zero,
      child: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(left: 25, top: 30),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.white24, spreadRadius: 2),
          ], 
          color: contentBgColor
        ),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.lightGreen,
                    child: CircleAvatar(
                      backgroundImage:
                        NetworkImage(checkUserImgUrl(_user.imgUrl)),
                      backgroundColor: drawerBgColor,
                      radius: 37,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _user.name,
                          style: sideBarName,
                          softWrap: true,
                        ),    
                        Text(
                          _user.email,
                          style: sideBarEmail,
                          softWrap: true,
                        ),             
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget createDrawerItem(icon, title, routeName) {
    return Ink(
      color: _activeRoute == routeName ? Colors.lightGreen : Colors.transparent,
      child: ListTile(
        hoverColor: Colors.lightGreen,
        selected: _activeRoute == routeName,
        contentPadding: EdgeInsets.all(5),
        leading: Padding(
          padding: EdgeInsets.only(left: 8),
          child: Icon(
            icon,
            color: drawerBgColor,
          ),   
        ),
        title: Text(
          title,
          style: sideBarItem,
        ),         
        onTap: () {
          if (routeName != null)
            navigateToPage(routeName);
          else
            logout(context);
        },     
      ),
    );
  }
}

Widget dividerLine(height) {
  return Padding(
    padding: EdgeInsets.only(left: 10, right: 10),
    child: Divider(
      color: Colors.black,
      thickness: height,
    ),
  );
}
