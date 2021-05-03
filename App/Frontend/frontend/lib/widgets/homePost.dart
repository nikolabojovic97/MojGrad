import 'package:Frontend/commons/messages.dart';
import 'package:Frontend/commons/theme.dart';
import 'package:Frontend/models/postLike.dart';
import 'package:Frontend/services/postCommentServices.dart';
import 'package:Frontend/src/pages/camera.dart';
import 'package:Frontend/src/pages/editPost.dart';
import 'package:Frontend/src/pages/gallery.dart';
import 'package:Frontend/src/pages/postdetail.dart';
import 'package:Frontend/src/pages/profilePage.dart';
import 'package:Frontend/src/pages/postProblemPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../commons/theme.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/postServices.dart';
import '../services/userServices.dart';

import '../src/pages/comments.dart';
import '../src/pages/comments_popup.dart';
import '../config/config.dart';
import '../src/pages/otherUsersProfile.dart';
import '../src/pages/profilePage.dart';
import 'homePostDescription.dart';
import 'homePostSwiper.dart';
import 'homePostType.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class HomePost extends StatefulWidget {
  final Post _post;
  Function deletePost;
  Function reportPost;
  HomePost(Key key, this._post, this.deletePost, this.reportPost)
      : super(key: key);
  HomePost.solution(this._post, this.reportPost);

  @override
  _HomePostState createState() => _HomePostState(_post, deletePost, reportPost);
}

class _HomePostState extends State<HomePost> {
  Post _post;
  User _user;
  int _commentNumber = 0;
  bool _myPost;
  Function deletePost;
  Function reportPost;
  List<String> images = [];
  _HomePostState(this._post, this.deletePost, this.reportPost);

  @override
  initState() {
    _user = Provider.of<UserService>(context, listen: false).user;
    if (_user.username == _post.userName)
      _myPost = true;
    else
      _myPost = false;

    for (var image in _post.imgUrl) {
      images.add(postImageURL + image);
    }

    _commentNumber = _post.postComments.length;
    super.initState();
  }

  Future<void> _changeLikeState() async {
    if (_post.isLiked) {
      bool deleted =
          await PostServices.deletePostLike(PostLike(_post.id, _user.username), _user.token);
      if (deleted) {
        setState(() {
          _post.leafNumber = _post.leafNumber - 1;
          _post.isLiked = false;
        });
      }
    } else {
      bool added =
          await PostServices.addPostLike(PostLike(_post.id, _user.username), _user.token);
      if (added) {
        setState(() {
          _post.leafNumber = _post.leafNumber + 1;
          _post.isLiked = true;
        });
      }
    }
  }

  void _changeCommentNumber(bool added) {
    setState(() {
      if (added)
        _commentNumber++;
      else
        _commentNumber--;
    });
  }

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

  Future<void> moveToProfilePage() async {
    if (Provider.of<UserService>(context, listen: false).username !=
        _post.userName) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtherUser(username: _post.userName)));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePage(username: _post.userName)));
    }
  }

  Widget postHeader() {
    return Container(
      // height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: GestureDetector(
            onTap: () => moveToProfilePage(),
            child: CircleAvatar(
              radius: 30,
              backgroundImage:
                  NetworkImage(checkUserImgUrl(_post.userImageUrl)),
            ),
          ),
          title: Text(
            _post.userName,
            style: postUsername,
          ),
          subtitle: Text(
            _post.address.split(",").elementAt(0),
            style: postLocation,
          ),
          trailing: Text(
            _post.dateCreatedToString(),
            style: postDate,
          ),
        ),
      ),
    );
  }

  Widget postDetails(context) {
    Alert alert = Alert(
      context: context,
      title: "Dodajte fotografiju",
      style: AlertStyle(
        titleStyle: addImage,
        isCloseButton: false,
      ),
      buttons: [
        DialogButton(
          height: 140.0,
          child: Icon(
            Icons.camera_alt,
            size: 100.0,
            color: Colors.lightGreen,
          ),
          color: Colors.white,
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Camera.fromSolution(PostType.SOLUTION, _post.id))),
          width: 120,
        ),
        DialogButton(
          height: 140.0,
          child: Icon(
            Icons.insert_drive_file,
            size: 100.0,
            color: Colors.lightGreen,
          ),
          color: Colors.white,
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Gallery.fromSolution(PostType.SOLUTION, _post.id))),
          width: 120,
        )
      ],
    );
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: (_post.isLiked)
                          ? Icon(Icons.favorite)
                          : Icon(Icons.favorite_border),
                      color: (_post.isLiked) ? Colors.lightGreen : Colors.grey,
                      iconSize: 30.0,
                      onPressed: () {
                        setState(() {
                          _changeLikeState();
                        });
                      },
                    ),
                    Text(
                      _post.leafNumber.toString(),
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.chat),
                      iconSize: 30.0,
                      onPressed: () {
                        Navigator.push(
                          context,
                          PopupLayout(
                            top: 170,
                            left: 30,
                            right: 30,
                            bottom: 50,
                            child: CommentsPage(
                                _post.postComments,
                                _post.id,
                                _user.username,
                                _changeCommentNumber,
                                checkUserImgUrl(_user.imgUrl)),
                          ),
                        );
                      },
                    ),
                    Text(
                      _commentNumber.toString(),
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    (_post.isSolution == false && _post.isSolved == true) ? SizedBox.shrink() :
                    IconButton(
                      icon: Icon(FontAwesomeIcons.recycle),
                      iconSize: 25.0,
                      onPressed: () async {
                        if (_post.isSolution) {
                          Post postProblem =
                              await PostServices.getPostProblemBySolutionId(
                                  _user.username, _post.id, _user.token);

                          if (postProblem.postComments == null) {
                            postProblem.postComments =
                                await PostCommentServices.getPostComments(
                                    postProblem.id, _user.token);
                          }

                          Navigator.push(
                            context,
                            PopupLayout(
                              top: 170,
                              left: 30,
                              right: 30,
                              bottom: 50,
                              child: PostProblemPage(postProblem, reportPost),
                            ),
                          );
                        } else {
                          var res = await _asyncConfirmDialog(
                              context, solutionTitle, solutionDescription);
                          if (res == ConfirmAction.ACCEPT) {
                            alert.show();
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            // IconButton(
            //   icon: (_myPost) ? Icon(Icons.delete) : Icon(Icons.report),
            //   iconSize: 30.0,
            //   onPressed: () async {
            //     if (_myPost) {
            //       var res = await _asyncConfirmDialog(
            //           context, deletePostTitle, deletePostDescription);
            //       if (res == ConfirmAction.ACCEPT) {
            //         await deletePost(_post.id);
            //       }
            //     } else {
            //       var res = await _asyncConfirmDialog(
            //           context, reportPostTitle, reportPostDescription);
            //       if (res == ConfirmAction.ACCEPT) {
            //         reportPost(_post.id);
            //       }
            //     }
            //   },
            // ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () => {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        title: Text(
                          "Opcije",
                          style: alertOption,
                        ),
                        children: <Widget>[
                          SimpleDialogOption(
                            onPressed: () async {
                              //Navigator.pop(context);
                              User institution;
                              if (_post.institutionUserName != null) {
                                institution = await Provider.of<UserService>(
                                        context,
                                        listen: false)
                                    .getUser(_post.institutionUserName);
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PostDetail(_post, institution),
                                ),
                              );
                            },
                            child: Row(children: <Widget>[
                              Icon(
                                Icons.description,
                                color: Colors.lightGreen,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Detalji objave"),
                              ),
                            ]),
                          ),
                          (_myPost)
                              ? SimpleDialogOption(
                                  onPressed: () async {
                                    var institutions = await Provider.of<UserService>(context, listen: false)
                                        .getAllVerifyInstitutions();
                                    print(institutions.length);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditPost(_post, institutions),
                                      ),
                                    );
                                  },
                                  child: Row(children: [
                                    Icon(
                                      Icons.mode_edit,
                                      color: Colors.lightGreen,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Izmena objave"),
                                    ),
                                  ]),
                                )
                              : SizedBox.shrink(),
                          (_myPost)
                              ? SimpleDialogOption(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    var res = await _asyncConfirmDialog(context,
                                        deletePostTitle, deletePostDescription);
                                    if (res == ConfirmAction.ACCEPT) {
                                      await deletePost(_post.id);
                                    }
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.delete,
                                        color: Colors.lightGreen,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Brisanje"),
                                      ),
                                    ],
                                  ),
                                )
                              : SimpleDialogOption(
                                  onPressed: () async {

                                    var res = await _asyncConfirmDialog(context,
                                        reportPostTitle, reportPostDescription);
                                    if (res == ConfirmAction.ACCEPT) {
                                      reportPost(_post.id);
                                    }
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.report,
                                        color: Colors.lightGreen,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Prijava"),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      );
                    })
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20),
          child: ListTile(
            dense: true,
            isThreeLine: true,
            title: postHeader(),
            subtitle: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    User institution;
                    if (_post.institutionUserName != null) {
                      institution =
                          await Provider.of<UserService>(context, listen: false)
                              .getUser(_post.institutionUserName);
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetail(_post, institution),
                      ),
                    );
                  },
                  child: HomePostSwiper(post: _post, images: images),
                ),
                postDetails(context),
                HomePostDescription(post: _post)
              ],
            ),
          ),
        ),
        Positioned(
          child: HomePostType(post: _post),
        ),
      ],
      overflow: Overflow.visible,
    );
  }
}
