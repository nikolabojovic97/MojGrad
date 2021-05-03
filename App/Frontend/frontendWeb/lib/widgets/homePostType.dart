import 'package:flutter/material.dart';
import 'package:frontendWeb/models/post.dart';

class HomePostType extends StatelessWidget {
  final Post post;

  const HomePostType({Key key, @required Post post,}) : this.post = post, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (post.isSolution)
        ? Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300],
                blurRadius: 5.0,
              ),
            ], 
            color: Colors.white, 
            shape: BoxShape.circle
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.sentiment_satisfied,
              color: Colors.lightGreen,
              size: 30,
            ),
          ),
        )
      : Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300],
                blurRadius: 5.0,
              ),
            ], 
            color: Colors.white, 
            shape: BoxShape.circle
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.sentiment_dissatisfied,
              color: Colors.red,
              size: 30,
            ),
          ),
        )
    );
  }
}