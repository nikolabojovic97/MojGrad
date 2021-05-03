import 'package:Frontend/commons/theme.dart';
import 'package:Frontend/models/post.dart';
import 'package:flutter/material.dart';

class HomePostDescription extends StatelessWidget {
  const HomePostDescription({
    Key key,
    @required Post post,
  }) : _post = post, super(key: key);

  final Post _post;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25.0),
          bottomRight: Radius.circular(25.0),
        ),
      ),
      child: ListTile(
        title: (_post.isSolution)
            ? Text(
                "Opis rešenja",
                style: postDescriptionTitle,
              )
            : Text(
                "Opis problema",
                style: postDescriptionTitle,
              ),
        subtitle: Text(
          _post.description,
          style: postDesc,
        ),
      ),
    );
  }
}