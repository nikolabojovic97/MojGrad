import 'package:Frontend/models/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Frontend/widgets/clap.dart';

class HomePostType extends StatelessWidget {
  const HomePostType({
    Key key,
    @required Post post,
  })  : _post = post,
        super(key: key);

  final Post _post;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (_post.isSolution)
      ? Clap()
      : Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.red[300],
            blurRadius: 5.0,
          ),
        ], color: Colors.white, shape: BoxShape.circle),
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Icon(
            Icons.warning,
            color: Colors.red,
            size: 20,
          ),
        ),
      )
    );
  }
}
