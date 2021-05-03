import 'package:Frontend/pages/newUserPage.dart';
import 'package:flutter/material.dart';

class FirstTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 30),
      child: Container(
        alignment: Alignment.topRight,
        height: 20,
        child: Row(
          children: <Widget>[
            Text(
              "Your first time?",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              )
            ),
            FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewUserPage()));
              },
              child: Text(
                "Sign up",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}