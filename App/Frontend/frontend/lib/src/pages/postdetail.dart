import 'package:Frontend/commons/theme.dart';
import 'package:Frontend/config/config.dart';
import 'package:Frontend/models/post.dart';
import 'package:Frontend/models/postLike.dart';
import 'package:Frontend/models/user.dart';
import 'package:Frontend/services/postServices.dart';
import 'package:Frontend/services/userServices.dart';
import 'package:Frontend/src/pages/profilePage.dart';
import 'package:Frontend/widgets/homePostSwiper.dart';
import 'package:Frontend/widgets/map.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'otherUsersProfile.dart';

class PostDetail extends StatefulWidget {
  final Post _post;
  final User _institution;
  PostDetail(this._post, this._institution);
  @override
  _PostDetailState createState() => _PostDetailState(_post, _institution);
}

class _PostDetailState extends State<PostDetail> {
  Post post;
  List<String> images = [];
  List<Post> list = List<Post>();
  User _user;
  User _institution;

  _PostDetailState(this.post, this._institution);

  @override
  initState() {
    super.initState();
    _user = Provider.of<UserService>(context, listen: false).user;
    for (var image in post.imgUrl) {
      images.add(postImageURL + image);
    }
    list.add(post);
  }

  Future<void> moveToProfilePage() async {
    if (Provider.of<UserService>(context, listen: false).username != post.userName) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OtherUser(username: post.userName)
        )
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage(username: post.userName))
      );
    }
  }

  Future<void> _changeLikeState() async {
    if (post.isLiked) {
      bool deleted =
          await PostServices.deletePostLike(PostLike(post.id, _user.username), _user.token);
      if (deleted) {
        setState(() {
          post.leafNumber = post.leafNumber - 1;
          post.isLiked = false;
        });
      }
    } 
    else {
      bool added = await PostServices.addPostLike(PostLike(post.id, _user.username), _user.token);
      if (added) {
        setState(() {
          post.leafNumber = post.leafNumber + 1;
          post.isLiked = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: ListView(
        children: [
          Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0.6, 2.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Container(
                      child: HomePostSwiper(
                        post: post,
                        images: images,
                      ),
                    )
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          iconSize: 30.0,
                          color: Colors.white,
                          onPressed: () => Navigator.pop(context),
                        ),
                        /*Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.save),
                      iconSize: 30.0,
                      color: Colors.lightGreen,
                      onPressed: () => Navigator.pop(context),//ovde save treba
                    ), //ovo cemo dodati ako se dogovorimo za save da bude ovde  
                  ],
                ),*/
                      ],
                    ),
                  ),
                  Positioned(
                    left: 20.0,
                    bottom: 25.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.locationArrow,
                              size: 15.0,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              post.address.split(",").elementAt(0), //lokacija
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Positioned(
                  //   right: 20.0,
                  //   bottom: 20.0,
                  //   child: IconButton(
                  //     icon: (post.isLiked)
                  //         ? Icon(Icons.favorite)
                  //         : Icon(Icons.favorite_border),
                  //     color: (post.isLiked) ? Colors.lightGreen : Colors.grey,
                  //     iconSize: 30.0,
                  //     onPressed: () {
                  //       setState(() {
                  //         _changeLikeState();
                  //       });
                  //     },
                  //   ),
                  // ),
                ],
              ),
              Column(
                children: <Widget>[
                  ListTile(
                    title: Container(
                      // height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(25.0),
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
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: GestureDetector(
                                onTap: () => moveToProfilePage(),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                      checkUserImgUrl(post.userImageUrl)),
                                ),
                              ),
                              title: Text(
                                post.userName,
                                style: postUsername,
                              ),
                              trailing: Text(
                                post.dateCreatedToString(),
                                style: postDate,
                              ),
                            ),
                            ListTile(
                              title: (post.isSolution)
                                  ? Text(
                                      "Opis rešenja",
                                      style: postDescriptionTitle,
                                    )
                                  : Text(
                                      "Opis problema",
                                      style: postDescriptionTitle,
                                    ),
                              subtitle: Text(
                                post.description,
                                style: postDesc,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  (_institution != null) ? ListTile(
                      title: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300],
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Container(
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          "Problem upućen",
                          style: postDescriptionTitle,
                        ),
                      ),
                      subtitle: ListTile(
                        leading: GestureDetector(
                          onTap: () => moveToProfilePage(),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                                checkUserImgUrl(_institution.imgUrl)),
                          ),
                        ),
                        title: ListTile(
                          title: Text(post.institutionUserName),
                          subtitle: Text(_institution.city),
                        ),
                      ),
                    ),
                  )) : SizedBox.shrink(),
                  ListTile(
                    title: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(25.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[300],
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                      child: Map(MapSize.small, list),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
