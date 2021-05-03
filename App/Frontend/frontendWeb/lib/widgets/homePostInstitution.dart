import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/config/config.dart';
import 'package:frontendWeb/enums/confirm.dart';
import 'package:frontendWeb/models/post.dart';
import 'package:frontendWeb/models/postLike.dart';
import 'package:frontendWeb/models/user.dart';
import 'package:frontendWeb/services/postCommentServices.dart';
import 'package:frontendWeb/services/postServices.dart';
import 'package:frontendWeb/services/userServices.dart';
import 'package:frontendWeb/widgets/addSolution.dart';
import 'package:frontendWeb/widgets/commentPage.dart';
import 'package:frontendWeb/widgets/popupPost.dart';
import 'package:provider/provider.dart';

import 'homePostType.dart';

class HomePostInstitution extends StatefulWidget {
  final Post post;
  final Function deletePost;
  final Function reportPost;
  final Function refreshPage;

  HomePostInstitution(Key key, this.post, this.deletePost, this.reportPost, this.refreshPage) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePostInstitutionState(post, deletePost, reportPost, refreshPage);
}

class _HomePostInstitutionState extends State<HomePostInstitution> {
  Post post;
  User user;
  List<String> images = [];
  Function deletePost;
  Function reportPost;
  Function refreshPage;

  _HomePostInstitutionState(this.post, this.deletePost, this.reportPost, this.refreshPage);

  @override
  void initState() {
    for (var image in post.imgUrl) {
      images.add(getPostImageURL + image);
    }

    user = Provider.of<UserService>(context, listen: false).user;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> changeLikeState() async {
    if (post.isLiked) {
      bool deleted = await PostServices.deletePostLike(PostLike(post.id, user.username), user.token);
      if (deleted) {
        setState(() {
          post.leafNumber = post.leafNumber - 1;
          post.isLiked = false;
        });
      }
    } 
    else {
      bool added = await PostServices.addPostLike(PostLike(post.id, user.username), user.token);
      if (added) {
        setState(() {
          post.leafNumber = post.leafNumber + 1;
          post.isLiked = true;
        });
      }
    }
  }

  void changeCommentNumber(bool added) {
    setState(() {
      if (added)
        post.commentsNumber++;
      else
        post.commentsNumber--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          child: ListTile(
            dense: true,
            isThreeLine: true,
            title: postHeader(), 
            subtitle: Column(
              children: [
                postSwiper(context),
                postDetails(context),
                homePostDescription(),
              ],
            ),
          ),
        ),
        Positioned(
          child: HomePostType(post: post),
        ),
      ],
      overflow: Overflow.visible,
    );
  }

  Widget postSwiper(context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Swiper(
        itemCount: images == null ? 0 : images.length,
        itemBuilder: (ctx, i) {
          return Image.network(images[i], fit: BoxFit.fitHeight);
        },
        control: SwiperControl(),
      ),
    );
  }

  Widget postHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 10.0,
          ),
        ],
      ),
      child: ListTile(
        leading: GestureDetector(
          child: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(checkUserImgUrl(post.userImageUrl)),
          ),
          onTap: () { /* owner's profile */ },
        ),
        title: Text(
          post.userName,
          style: postReportDetailsCardMain,
        ),
        subtitle: Text(
          post.address.split(",").elementAt(0),
          style: postReportDetailsCardInfo,
        ),
        trailing: Text(
          post.dateCreatedToString(),
          style: postReportDetailsCardMain,
        ),
      ),
    );
  }

  Widget postDetails(context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: (post.isLiked)
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                    color: (post.isLiked) ? Colors.lightGreen : Colors.grey,
                    iconSize: 25.0,
                    onPressed: () {
                      changeLikeState();
                    },
                  ),
                  Text(
                    post.leafNumber.toString(),
                    style: postReportDetailsCardMain,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.chat),
                    iconSize: 25.0,
                    onPressed: () async {
                      var comments = await PostCommentServices.getPostComments(post.id, user.token);

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CommentPage(comments, changeCommentNumber, post.id, user.username, user.imgUrl);
                        }
                      );
                    },
                  ),
                  Text(
                    post.commentsNumber.toString(),
                    style: postReportDetailsCardMain,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(FontAwesomeIcons.recycle),
                    iconSize: 25.0,
                    onPressed: () async {
                      if (post.isSolution) {
                        Post postProblem = await PostServices.getPostProblemBySolutionId(post.userName, post.id, user.token);

                        List<String> problemImages = [];

                        for (var image in postProblem.imgUrl) {
                          problemImages.add(getPostImageURL + image);
                        }

                        showDialog(context: context, child: PopupProblem(key: UniqueKey(), post: postProblem, images: problemImages));
                      }
                      else {
                        var result = await asyncConfirmAddSolution(context);

                        if (result == ConfirmAction.ACCEPT) {
                          refreshPage(post.id);
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          user.username == post.userName ?
          IconButton(
            icon: Icon(Icons.delete),
            iconSize: 25.0,
            onPressed: () async {
              var result = await asyncConfirmDialog(context, "Brisanje objave", "Da li ste sigurni da želite da obrišete izabranu objavu?");

              if (result == ConfirmAction.ACCEPT) {
                await deletePost(post.id);
              }
            },
            tooltip: "Izbrišite objavu",
          ) :
          IconButton(
            icon: Icon(Icons.report),
            iconSize: 25.0,
            onPressed: () async {
              var result = await asyncConfirmDialog(context, "Prijava objave", "Da li ste sigurni da želite da prijavite izabranu objavu?");

              if (result == ConfirmAction.ACCEPT) {
                await reportPost(post.id);
              }
            },
            tooltip: "Prijavite objavu",
          )
        ],
      ),
    );
  }

  Widget homePostDescription() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
        )
      ),
      child: ListTile(
        title: (post.isSolution) ?
          Text("Opis rešenja", style: usernameComment) :
          Text("Opis problema", style: usernameComment),
        subtitle: Text(
          post.description,
          style: content,
        ),
      ),
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

  Future<ConfirmAction> asyncConfirmAddSolution(BuildContext context) async {
    return showDialog<ConfirmAction> (
      context: context,
      builder: (BuildContext context) {
        return AddSolution(key: UniqueKey(), problem: post, user: user);
      }
    );
  }
}
