import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/config/config.dart';
import 'package:frontendWeb/enums/confirm.dart';
import 'package:frontendWeb/models/post.dart';
import 'package:frontendWeb/models/user.dart';
import 'package:frontendWeb/services/postCommentServices.dart';
import 'package:frontendWeb/services/postServices.dart';
import 'package:frontendWeb/services/userServices.dart';
import 'package:frontendWeb/widgets/commentsPage.dart';
import 'package:frontendWeb/widgets/homePostType.dart';
import 'package:frontendWeb/widgets/popupPost.dart';
import 'package:provider/provider.dart';

import 'alert.dart';

class HomePost extends StatefulWidget {
  final Post post;
  final Function deletePost;

  HomePost(Key key, this.post, this.deletePost) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePostState(post, deletePost);
}

class _HomePostState extends State<HomePost> {
  Post post;
  List<String> images = [];
  Function deletePost;

  _HomePostState(this.post, this.deletePost);

  @override
  void initState() {
    for (var image in post.imgUrl) {
      images.add(getPostImageURL + image);
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite),
                    iconSize: 25.0,
                    onPressed: () {},
                  ),
                  Text(
                    post.leafNumber.toString(),
                    style: postReportDetailsCardMain,
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.chat),
                    iconSize: 25.0,
                    onPressed: () async {
                      User user = Provider.of<UserService>(context, listen: false).user;
                      var comments = await PostCommentServices.getPostComments(post.id, user.token);

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            title: Container(
                              padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.lightGreen,
                              ),
                              child: Text(
                                "Komentari",
                                style: popupTitle,
                              ),
                            ),
                            content: CommentsPage(comments),
                          );
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
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.report),
                    iconSize: 25.0,
                    onPressed: () {},
                  ),
                  Text(
                    post.reportsNumber.toString(),
                    style: postReportDetailsCardMain,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(FontAwesomeIcons.recycle),
                    iconSize: 25.0,
                    onPressed: () async {
                      if (post.isSolution) {
                        User user = Provider.of<UserService>(context, listen: false).user;
                        Post postProblem = await PostServices.getPostProblemBySolutionId(post.userName, post.id, user.token);

                        List<String> problemImages = [];

                        for (var image in postProblem.imgUrl) {
                          problemImages.add(getPostImageURL + image);
                        }

                        showDialog(context: context, child: PopupProblem(key: UniqueKey(), post: postProblem, images: problemImages));
                      }
                      else {
                        showDialog(context: context, child: alert("Nerešeni problem", "Izabrani problem još uvek nije rešen."));
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
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
          ),
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
}
