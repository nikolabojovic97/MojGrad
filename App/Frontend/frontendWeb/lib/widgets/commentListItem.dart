import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/enums/confirm.dart';
import 'package:frontendWeb/models/postComment.dart';
import 'package:frontendWeb/services/userServices.dart';
import 'package:provider/provider.dart';

class CommentListItem extends StatefulWidget {
  final PostComment comment;
  final Function deleteComment;
  final Function reportComment;

  CommentListItem(Key key, this.comment, this.deleteComment, this.reportComment) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CommentListItemState(comment, deleteComment, reportComment);
}

class _CommentListItemState extends State<CommentListItem> {
  PostComment comment;
  Function deleteComment;
  Function reportComment;

  String username;
  bool myComment;

  _CommentListItemState(this.comment, this.deleteComment, this.reportComment);

  @override
  void initState() {
    username = Provider.of<UserService>(context, listen: false).user.username;
    if (username == comment.userName)
      myComment = true;
    else
      myComment = false;
    super.initState();
  }

  String deleteCommentTitle = "Brisanje komentara";
  String deleteCommentContent = "Da li ste sigurni da želite da obrišete izabrani komentar?";

  String reportCommentTitle = "Prijavljivanje komentara";
  String reportCommentContent = "Da li ste sigurni da želite da prijavite izabrani komentar?";

  Widget pictureWidget() {
    return Container(
      width: 50,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              checkUserImgUrl(comment.userImgUrl),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: pictureWidget(),
      title: Text(
        comment.userName,
        style: usernameComment,
      ),
      subtitle: Text(
        comment.comment,
        style: contentComment,
      ),
      trailing: 
      deleteComment != null && reportComment != null ?
      IconButton(
        color: Colors.black,
        icon: myComment ? Icon(Icons.delete): Icon(Icons.report),
        iconSize: 25,
        onPressed: () async {
          if (myComment) {
            var res = await asyncConfirmDialog(context, deleteCommentTitle, deleteCommentContent);

            if (res == ConfirmAction.ACCEPT) {
              await deleteComment(comment.id);
            }
          }
          else {
            var res = await asyncConfirmDialog(context, reportCommentTitle, reportCommentContent);

            if (res == ConfirmAction.ACCEPT) {
              await reportComment(comment.id);
            }
          }
        },
      ) : Text("")
    );
  }

  Future<ConfirmAction> asyncConfirmDialog(BuildContext context, String title, String content) async {
    return showDialog<ConfirmAction> (
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titleTextStyle: alertTitle,
          contentTextStyle: alertContent,
          title: Text(
            title,
          ),
          content: Text(
            content,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          actions: [
            FlatButton(
              child: Text(
                "Da",
                style: alertOption,
              ),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            ),
            FlatButton(
              child: Text(
                "Ne",
                style: alertOption,
              ),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
          ],
        );
      }
    );
  }
}