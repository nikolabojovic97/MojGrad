import 'package:flutter/material.dart';
import 'package:frontendWeb/models/postComment.dart';
import 'package:frontendWeb/widgets/commentListItem.dart';

class CommentsPage extends StatefulWidget{
  final List<PostComment> comments;

  const CommentsPage(this.comments);

  @override
  State<StatefulWidget> createState() => _CommentsPageState(comments);
}

class _CommentsPageState extends State<CommentsPage> {
  List<PostComment> comments;
  Function(bool) changeCommentNumber;

  _CommentsPageState(this.comments);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      width: 400,
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: comments == null ? 0 : comments.length,
        itemBuilder: (BuildContext context, int index) {
          return CommentListItem(UniqueKey(), comments[index], null, null);
        },
        separatorBuilder: (ctx, i) {
          return Divider(endIndent: 0, indent: 0, height: 5, thickness: 0.3, color: Colors.grey);
        },
      ),
    );
  }
}