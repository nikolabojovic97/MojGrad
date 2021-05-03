import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/models/post.dart';
import 'package:frontendWeb/services/userServices.dart';

class PopupProblem extends StatelessWidget {
  final Post post;
  final List<String> images;

  PopupProblem({Key key, @required this.post, @required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: popupProblemTitle,
      title: Container(
        decoration: BoxDecoration(
          color: Colors.lightGreen,
        ),
        padding: EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
        child: Text(
          "Početni problem",
        ),
      ),
      content: Container(
        width: 600,
        child: Column(
          children: [
            postHeader(),
            postSwiper(context),
            homePostDescription(),
          ],
        ),
      ),
    );
  }

  Widget postHeader() {
    return Container(
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
          style: popupMain,
        ),
        subtitle: Text(
          post.address.split(",").elementAt(0),
          style: popupDetails,
        ),
      ),
    );
  }

  Widget postSwiper(context) {
    return Container(
      height: 300,
      child: Swiper(
        itemCount: images == null ? 0 : images.length,
        itemBuilder: (ctx, i) {
          return Image.network(images[i], fit: BoxFit.fitHeight);
        },
        control: SwiperControl(),
      ),
    );
  }

  Widget homePostDescription() {
    return Container(
      child: ListTile(
        title: (post.isSolution) ?
          Text("Opis rešenja", style: usernameComment) :
          Text("Opis problema", style: usernameComment),
        subtitle: Text(
          post.description,
          style: contentComment,
        ),
      ),
    );
  }
}