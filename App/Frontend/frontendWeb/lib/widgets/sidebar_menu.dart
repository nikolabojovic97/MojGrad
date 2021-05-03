import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/main.dart';
import 'package:frontendWeb/models/user.dart';
import 'package:frontendWeb/services/userServices.dart';
import 'package:frontendWeb/utils/app_routes.dart';
import 'package:provider/provider.dart';

class SidebarMenu extends StatefulWidget {
  SidebarMenu({Key key}) : super(key: key);

  @override
  _SidebarMenuState createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> with RouteAware {
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
    Navigator.pushReplacementNamed(context, AppRoutes.welcome);
  }

  void navigateToPage(routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          createHeader(),
          dividerLine(0.3),
          createDrawerItem(Icons.dashboard, "Komandna tabla", AppRoutes.dashboard),
          dividerLine(0.3),
          createUsersExpansionTile(),
          dividerLine(0.3),
          createReportsExpansionTile(),
          dividerLine(0.3),
          createDrawerItem(Icons.account_balance, "Verifikacija institucija", AppRoutes.verification),
          dividerLine(0.3),
          createDrawerItem(Icons.edit, "Izmena profila", AppRoutes.editProfile),
          dividerLine(0.3),
          createDrawerItem(Icons.person_add, "Dodavanje naloga", AppRoutes.addAdmin),
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
            BoxShadow(
              blurRadius: 10, 
              color: Colors.white24, 
              spreadRadius: 2
            ),
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
        contentPadding: EdgeInsets.only(left: 5, right: 5),
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

  Widget createReportsExpansionTile() {
    return ExpansionTile(
      initiallyExpanded: _activeRoute == AppRoutes.postReports || _activeRoute == AppRoutes.postReportDetails || _activeRoute == AppRoutes.commentReports || _activeRoute == AppRoutes.commentReportDetails ? true : false,
      backgroundColor: Colors.transparent,
      tilePadding: EdgeInsets.only(left: 5, right: 5),
      leading: Padding(
        padding: EdgeInsets.only(left: 8),
        child: Icon(
          Icons.report,
          color: drawerBgColor,
        ),  
      ),
      title: Text(
        "Prijave",
        style: sideBarItem,
      ),  
      children: [
        Ink(
          color: _activeRoute == AppRoutes.postReports || _activeRoute == AppRoutes.postReportDetails ? Colors.lightGreen : Colors.transparent,
          child: ListTile(
            selected: _activeRoute == AppRoutes.postReports,
            hoverColor: Colors.lightGreen,
            leading: Icon(
              Icons.remove,
              color: Colors.transparent,
            ),
            title: Text(
              "Prijave objava",
              style: sideBarItem,
            ), 
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.postReports);
            },  
          ),
        ),
        Ink(
          color: _activeRoute == AppRoutes.commentReports || _activeRoute == AppRoutes.commentReportDetails ? Colors.lightGreen : Colors.transparent,
          child: ListTile(
          selected: _activeRoute == AppRoutes.commentReports,
          hoverColor: Colors.lightGreen,
          leading: Icon(
            Icons.remove,
            color: Colors.transparent,
          ),
          title: Text(
            "Prijave komentara",
            style: sideBarItem,
          ), 
          onTap: () {
            Navigator.pushReplacementNamed(context, AppRoutes.commentReports);
          },  
        ),
        ),
      ],
    );
  }

  Widget createUsersExpansionTile() {
    return ExpansionTile(
      initiallyExpanded: _activeRoute == AppRoutes.users || _activeRoute == AppRoutes.userDetails || _activeRoute == AppRoutes.institutionUsers || _activeRoute == AppRoutes.institutionDetails ? true :  false,
      backgroundColor: Colors.transparent,
      tilePadding: EdgeInsets.only(left: 5, right: 5),
      leading: Padding(
        padding: EdgeInsets.only(left: 8),
        child: Icon(
          Icons.supervised_user_circle,
          color: drawerBgColor,
        ),  
      ),
      title: Text(
        "Upravljanje nalozima",
        style: sideBarItem,
      ),  
      children: [
        Ink(
          color: _activeRoute == AppRoutes.users || _activeRoute == AppRoutes.userDetails ? Colors.lightGreen : Colors.transparent,
          child: ListTile(
            selected: _activeRoute == AppRoutes.postReports,
            hoverColor: Colors.lightGreen,
            leading: Icon(
              Icons.remove,
              color: Colors.transparent,
            ),
            title: Text(
              "Korisnički nalozi",
              style: sideBarItem,
            ), 
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.users);
            },  
          ),
        ),
        Ink(
          color: _activeRoute == AppRoutes.institutionUsers || _activeRoute == AppRoutes.institutionDetails ? Colors.lightGreen : Colors.transparent,
          child: ListTile(
          selected: _activeRoute == AppRoutes.commentReports,
          hoverColor: Colors.lightGreen,
          leading: Icon(
            Icons.remove,
            color: Colors.transparent,
          ),
          title: Text(
            "Nalozi institucija",
            style: sideBarItem,
          ), 
          onTap: () {
            Navigator.pushReplacementNamed(context, AppRoutes.institutionUsers);
          },  
        ),
        ),
      ],
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
