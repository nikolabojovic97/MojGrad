import 'package:flutter/material.dart';

class Forgot extends StatelessWidget {
  static String tag = 'home-page';

  @override
  Widget build(BuildContext context) {
   /* final alucard = Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.all(16.0),
       // child: CircleAvatar(
         // radius: 72.0,
          //backgroundColor: Colors.white,
         // backgroundImage: AssetImage('assets/fox.jpg'),
      //  ),
      ),
    );*/

    final welcome = Padding(
      padding: EdgeInsets.all(72.0),
      child: Text(
        'Sorry',
        style: TextStyle(fontSize: 64.0, color: Colors.white),
      ),
    );

    final lorem = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '',
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
    );

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.red,
          Colors.orangeAccent,
        ]),
      ),
      child: Column(
        children: <Widget>[welcome, lorem],
      ),
    );

    return Scaffold(
      body: body,
    );
  }
}