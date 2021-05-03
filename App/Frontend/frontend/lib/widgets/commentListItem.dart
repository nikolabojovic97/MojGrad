import 'package:Frontend/commons/theme.dart';
import 'package:Frontend/models/postComment.dart';
import 'package:Frontend/services/userServices.dart';
import 'package:Frontend/widgets/homePost.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentListItem extends StatefulWidget {
  PostComment _comment;
  Function _deleteComment;
  Function _reportComment;
  CommentListItem(
      Key key, this._comment, this._deleteComment, this._reportComment)
      : super(key: key);
  @override
  _CommentListItemState createState() =>
      _CommentListItemState(_comment, _deleteComment, _reportComment);
}

class _CommentListItemState extends State<CommentListItem> {
  PostComment _comment;
  Function _deleteComment;
  Function _reportComment;
  List<Widget> listTiles;
  bool _myComment;
  String _userName;
  _CommentListItemState(
      this._comment, this._deleteComment, this._reportComment);

  @override
  void initState() {
    _userName = Provider.of<UserService>(context, listen: false).user.username;
    if (_userName == _comment.userName)
      _myComment = true;
    else
      _myComment = false;
    super.initState();
  }

  Widget _userAvatar(String imgUrl) {
    return CircleAvatar(
      child: ClipOval(
        child: Image(
          height: 50.0,
          width: 50.0,
          image: NetworkImage(checkUserImgUrl(imgUrl)),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  String _deleteCommentDescription =
      'Prihvatanjem opcije "NASTAVITE", Vaš komentar će biti trajno obrisan. ' +
          'Da li ste sigurni da želite da nastavite?';
  String _deleteCommentTitle = 'Brisanje komentara';

  String _reportCommentDescription =
      'Prihvatanjem opcije "NASTAVITE", potvrđujete prijavu komentara. ' +
          'Svaka lažna prijava može biti sankcionisana. Da li ste sigurni da želite da nastavite?';
  String _reportCommentTitle = 'Prijavi komentar?';

  Future<ConfirmAction> _asyncConfirmDialog(
      BuildContext context, String _title, String _description) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: Text(_title, style: alertTitle),
          content: Text(_description, style: alertContent),
          actions: <Widget>[
            FlatButton(
              child: Text('ODUSTANITE', style: alertOption),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: Text('NASTAVITE', style: alertOption),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _userAvatar(checkUserImgUrl(_comment.userImgUrl)),
      title: Text(_comment.userName, style: usernameComment),
      subtitle: Text(_comment.comment, style: comment),
      trailing: IconButton(
        icon: (_myComment) ? Icon(Icons.delete) : Icon(Icons.report),
        iconSize: 20.0,
        onPressed: () async {
          if (_myComment) {
            var res = await _asyncConfirmDialog(
                context, _deleteCommentTitle, _deleteCommentDescription);
            if (res == ConfirmAction.ACCEPT) {
              await _deleteComment(_comment.id);
            }
          } else {
            var res = await _asyncConfirmDialog(
                context, _reportCommentTitle, _reportCommentDescription);
            if (res == ConfirmAction.ACCEPT) {
              _reportComment(_comment.id);
            }
          }
        },
      ),
    );
  }
}
