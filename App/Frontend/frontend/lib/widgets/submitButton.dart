import 'package:Frontend/commons/theme.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String _text;
  final Function _onTap;
  SubmitButton(this._text, this._onTap);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () async {
        await _onTap();
      },
      child: new Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(500)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.green.shade700,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.lightGreen, Colors.green[300]])),
        child: Text(
          _text,
          style: loginButton,
        ),
      ),
    );
  }
}