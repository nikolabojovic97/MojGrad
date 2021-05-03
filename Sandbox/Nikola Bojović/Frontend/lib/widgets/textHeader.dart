import 'package:flutter/material.dart';

class TextHeader extends StatelessWidget {
  final String _text;

  TextHeader(this._text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 10),
      child: Container(
        height: 200,
        width: 200,
        child: Column(
          children: <Widget>[
            Container(height: 60,),
            Center(
              child: Text(
                _text,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}