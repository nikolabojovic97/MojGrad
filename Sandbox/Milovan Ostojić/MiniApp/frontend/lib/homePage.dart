import 'package:flutter/material.dart';

import 'user.dart';

class HomePage extends StatefulWidget {
  final User user;
  HomePage(this.user);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState(user);
  }
}

class _HomePageState extends State<HomePage> {
  User user;
  int countMembers = 0;

  _HomePageState(this.user);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Home Page"),
      ),
      body: new Center(
        child: 
        Text("Welcome"),
        ),
    );
  }
  }

