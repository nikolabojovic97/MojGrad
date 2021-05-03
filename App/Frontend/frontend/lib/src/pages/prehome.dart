import 'dart:ui';
import 'package:Frontend/commons/theme.dart';
import 'package:Frontend/src/pages/allPostsMap.dart';
import 'package:Frontend/src/pages/search.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../services/userServices.dart';
import 'camera.dart';
import 'gallery.dart';
import 'home.dart';
import 'profilePage.dart';
import 'search.dart';


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      title: "Moj grad",
      theme: ThemeData(
        primaryColor: Colors.lightGreen,
        accentColor: Colors.green,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey _bottomNavigationKey = GlobalKey();
  var _pageViewController = PageController();

  void openMap(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AllPostsMap()));
  }

  @override
  Widget build(BuildContext context) {
    var username = Provider.of<UserService>(context, listen: false).user.username;

    Alert alert = Alert(
      context: context,
      title: "Dodajte fotografiju",
      style: AlertStyle(
        titleStyle: addImage,
        isCloseButton: false,
      ),
      buttons: [
        DialogButton(
          height: 140.0,
          child: Icon(
            Icons.camera_alt,
            size: 100.0,
            color: Colors.lightGreen,
          ),
          color: Colors.white,
          onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Camera(PostType.POST))),
          width: 120,
        ),
        DialogButton(
          height: 140.0,
          child: Icon(
            Icons.insert_drive_file,
            size: 100.0,
            color: Colors.lightGreen,
          ),
          color: Colors.white,
          onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Gallery(PostType.POST))),
          width: 120,
        )
      ],
    );
    return Scaffold(
      backgroundColor:  Colors.grey[200],
      appBar: PreferredSize( 
        preferredSize: Size.fromHeight(50.0), // here the desired height
        child: AppBar(
          title: Text("Početna strana", style: appBarTitle),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
                      bottomLeft:  const  Radius.elliptical(50, 50),
                      bottomRight: const  Radius.elliptical(50, 50))
          ),
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
          elevation: 0,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 5),
              child: IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
                },
              ),  
            ),
          ],
        )
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: Colors.lightGreen,
        index: 0,
        height: 50.0,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.camera, size: 30),
          IconButton(icon: Icon(Icons.map, size: 30,), onPressed: (){
            openMap(context);
          },),
          IconButton(icon: Icon(Icons.person, size: 30,),onPressed: () {
            Navigator.push(
            context, MaterialPageRoute(builder: (context) =>  ProfilePage(username: username)));
          },),
        ],
        color: Colors.white,
          buttonBackgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          if(index == 0){
            HomePage();
          }
          else if(index == 1){
            alert.show();
          }
          else{
            ProfilePage(username: username);
          }
        },
      ),
      body: PageView(
        controller: _pageViewController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Home(),
          ProfilePage(username: username),
        ],
      ),       
    );
  }}

