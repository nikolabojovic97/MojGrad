import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/models/commentReport.dart';
import 'package:frontendWeb/models/postComment.dart';
import 'package:frontendWeb/models/user.dart';
import 'package:frontendWeb/services/commentReportServices.dart';
import 'package:frontendWeb/services/postCommentServices.dart';
import 'package:frontendWeb/services/userServices.dart';
import 'package:provider/provider.dart';

import 'alert.dart';
import 'commentListItem.dart';

class CommentPage extends StatefulWidget {
  final List<PostComment> comments;
  final Function(bool) changeCommentNumber;
  final int postId;
  final String username;
  final String userImgUrl;

  CommentPage(this.comments, this.changeCommentNumber, this.postId, this.username, this.userImgUrl);

  @override
  _CommentPageState createState() => _CommentPageState(comments, changeCommentNumber, postId, username, userImgUrl);
}

class _CommentPageState extends State<CommentPage> {
  final List<PostComment> comments;
  final Function(bool) changeCommentNumber;
  final int postId;
  final String username;
  final String userImgUrl;

  _CommentPageState(this.comments, this.changeCommentNumber, this.postId, this.username, this.userImgUrl);

  TextEditingController commentCtrl = TextEditingController();

  Future<void> addComment() async {
    PostComment newComment;
    newComment = PostComment(username, postId, commentCtrl.text);
    newComment.userImgUrl = userImgUrl;

    User user = Provider.of<UserService>(context, listen: false).user;
    PostComment added = await PostCommentServices.addPostComment(newComment, user.token);

    if (added != null) {
      setState(() {
        comments.add(added);
      });
    }
  }

  Future<void> deleteComment(int commentId) async {
    User user = Provider.of<UserService>(context, listen: false).user;
    bool deleted = await PostCommentServices.deletePostComment(commentId, user.token);
    if (deleted) {
      setState(() {
        comments.removeWhere((element) => element.id == commentId);
        changeCommentNumber(false);
      });
    }
  }

  Future<void> reportComment(int commentID) async {
    String userName = Provider.of<UserService>(context, listen: false).user.username;
    User user = Provider.of<UserService>(context, listen: false).user;
    bool reported = await CommentReportServices.addCommentReport(CommentReport(userName, commentID), user.token);
    if(reported) {
      showDialog(
      context: context,
      child: 
        alert("Status prijave", "Vaša prijava je registrovana.")
      );
    }
    else {
      showDialog(context: context, child: alert("Status prijave", "Prijava nije registrovana. Pokušajte ponovo."));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Container(
        width: 400,
        padding: EdgeInsets.only(left: 10, right: 10, top: 5),
        decoration: BoxDecoration(
          color: Colors.lightGreen,
        ),
        child: TextField(
          controller: commentCtrl,
          minLines: 1,
          maxLines: 5,
          maxLength: 500,
          cursorColor: Colors.white,
          expands: false,
          style: inputComment,
          decoration: InputDecoration(
            counterText: '',
            border: InputBorder.none,
            hintText: "Dodajte komentar",
            hintStyle: inputComment,
            suffixIcon: IconButton(
              icon: Icon(Icons.add_circle),
              color: Colors.white,
              onPressed: () async {
                if (commentCtrl.text != "") {
                  setState(() {
                    addComment();
                    changeCommentNumber(true);
                    commentCtrl.text = "";
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                }
              },
            ),
          ),
        ),
      ),
      content: Container(
        height: 450,
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: comments == null ? 0 : comments.length,
          itemBuilder: (BuildContext context, int index) {
            return CommentListItem(UniqueKey(), comments[index], deleteComment, reportComment);
          },
          separatorBuilder: (ctx, i) {
            return Divider(endIndent: 0, indent: 0, height: 5, thickness: 0.3, color: Colors.grey);
          },
        ),
      ),
      titlePadding: EdgeInsets.zero,
    );
  }
}