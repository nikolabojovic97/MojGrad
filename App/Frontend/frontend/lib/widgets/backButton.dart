import 'package:Frontend/commons/theme.dart';
import 'package:flutter/material.dart';

class BackButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                child:
                    Icon(Icons.keyboard_arrow_left, color: Colors.lightGreen),
              ),
              Text(
                'Nazad',
                style: alertLogin
              ),
            ],
          ),
        ),
      );
  }
}
