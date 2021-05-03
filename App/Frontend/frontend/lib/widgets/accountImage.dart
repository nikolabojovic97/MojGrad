import 'package:flutter/material.dart';

class AccountImage extends StatefulWidget {
  NetworkImage _image;
  double factor = 1;

  AccountImage(NetworkImage image, this.factor){
    this._image = image;
  }
  @override
  _AccountImageState createState() => _AccountImageState();
}

class _AccountImageState extends State<AccountImage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(      
        width: 150.0 * widget.factor,
        height: 150.0 * widget.factor,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: widget._image,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(100.0 * widget.factor),
          border: Border.all(
            color: Colors.lightGreen,
            width: 3.0,
          ),
        ),
      ),
    );
  }
}