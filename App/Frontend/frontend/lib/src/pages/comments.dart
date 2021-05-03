import 'package:Frontend/commons/theme.dart';
import 'package:Frontend/models/commentReport.dart';
import 'package:Frontend/models/postComment.dart';
import 'package:Frontend/models/user.dart';
import 'package:Frontend/services/commentReportServices.dart';
import 'package:Frontend/services/postCommentServices.dart';
import 'package:Frontend/services/userServices.dart';
import 'package:Frontend/widgets/commentListItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentsPage extends StatefulWidget {
  final List<PostComment> _comments;
  final Function(bool) _changeCommenNumber;
  final int _postId;
  final String _userName;
  final String _userImageUrl;

  CommentsPage(this._comments, this._postId, this._userName,
      this._changeCommenNumber, this._userImageUrl);
  @override
  createState() => new CommentsPageState(
      _comments, _postId, _userName, _changeCommenNumber, _userImageUrl);
}

String avatarImg;

class CommentsPageState extends State<CommentsPage> {
  List<PostComment> _comments;
  final int _postId;
  final String _userName;
  final Function(bool) _changeCommenNumber;
  final String _userImageUrl;
  User _user;

  CommentsPageState(this._comments, this._postId, this._userName,
      this._changeCommenNumber, this._userImageUrl);
  List<Widget> listTiles = [];
  TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    _user = Provider.of<UserService>(context, listen: false).user;
    super.initState();
  }

  Future<void> _addComment() async {
    PostComment newComment;
    newComment = PostComment(_userName, _postId, _commentController.text);
    newComment.userImgUrl = _userImageUrl;
    PostComment added =
        await PostCommentServices.addPostComment(newComment, _user.token);
    if (added != null) {
      setState(() {
        _comments.add(added);
      });
    }
  }

  Future<void> deleteComment(int commentId) async {
    bool deleted =
        await PostCommentServices.deletePostComment(commentId, _user.token);
    if (deleted) {
      setState(() {
        _comments.removeWhere((element) => element.id == commentId);
        _changeCommenNumber(false);
      });
    }
  }

  Future<void> reportComment(int commentID) async {
    String userName =
        Provider.of<UserService>(context, listen: false).user.username;
    bool reported = await CommentReportServices.reportComment(
        CommentReport(userName, commentID), _user.token);
    if (reported) {
      showDialog(
          context: context,
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            title: Text(
              "Status prijave",
              style: alertTitle,
            ),
            content: Text(
              "Vaša prijava je registrovana.",
              style: alertContent,
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(35.0),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: TextField(
            controller: _commentController,
            minLines: 1,
            maxLines: 10,
            style: addCommentText,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Dodajte komentar',
              hintStyle: new TextStyle(color: Colors.white),
              suffixIcon: IconButton(
                  icon: Icon(
                    Icons.add_circle,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (_commentController.text != "")
                      setState(() {
                        _addComment();
                        _changeCommenNumber(true);
                        _commentController.text = "";
                        FocusScope.of(context).requestFocus(FocusNode());
                      });
                  }),
            ),
          ),
          backgroundColor: Colors.lightGreen,
          centerTitle: true,
          elevation: 0,
        ),
        body: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: _comments == null ? 0 : _comments.length,
                shrinkWrap: true,
                itemBuilder: (ctx, i) {
                  return CommentListItem(
                      UniqueKey(), _comments[i], deleteComment, reportComment);
                })
          ],
        ),
      ),
    );
  }
}
