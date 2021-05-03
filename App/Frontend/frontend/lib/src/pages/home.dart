import 'package:Frontend/commons/theme.dart';
import 'package:Frontend/models/enums.dart';
import 'package:Frontend/models/post.dart';
import 'package:Frontend/models/postReport.dart';
import 'package:Frontend/models/user.dart';
import 'package:Frontend/services/postCommentServices.dart';
import 'package:Frontend/services/postReportServices.dart';
import 'package:Frontend/services/postServices.dart';
import 'package:Frontend/services/userServices.dart';
import 'package:Frontend/src/pages/postdetail.dart';
import 'package:Frontend/widgets/homePost.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../config/config.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Post> posts;
  List<Post> popularPosts;
  User _user;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    getAllPosts(_user);
    _refreshController.refreshCompleted();
  }

  Future<void> getAllPosts(User user) async {
    var response = await PostServices.getPostsForUser(user.username, _user.token);
    var popular =
        await PostServices.getSortedPosts(SortType.leaves_desc, _user.token, number: 5);

    for (var post in response) {
      post.postComments = await PostCommentServices.getPostComments(post.id, _user.token);
    }

    response = PostServices.sortPosts(response, SortType.dates_desc);
    if (this.mounted)
      setState(() {
        posts = response;
        popularPosts = popular;
      });
  }

  Future<void> reportPost(int postId) async {
    PostReport postReport = PostReport(_user.username, postId);
    bool reported = await PostReportServices.reportPost(postReport, _user.token);
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
        ),
      );
    }
  }

  Future<void> deletePost(int postId) async {
    bool deleted = await PostServices.deletePost(postId, _user.token);
    if (deleted) {
      setState(() {
        posts.removeWhere((element) => element.id == postId);
      });
      showDialog(
          context: context,
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            title: Text(
              "Brisanje objave",
              style: alertTitle,
            ),
            content: Text(
              "Vaša objava je uspešno obrisana.",
              style: alertContent,
            ),
          ));
    } else
      showDialog(
          context: context,
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            title: Text(
              "Brisanje objave",
              style: alertTitle,
            ),
            content: Text(
              "Objava nije obrisana. Pokušajte ponovo.",
              style: alertContent,
            ),
          ));
  }

  @override
  initState() {
    super.initState();
    _user = Provider.of<UserService>(context, listen: false).user;
    getAllPosts(_user);
  }

  @override
  dispose() {
    super.dispose();
  }

  void sortPosts(SortType type) {
    var postsTmp = posts;

    setState(() {
      posts = null;
    });

    if (type == SortType.dates_asc)
      setState(() {
        posts = PostServices.sortPosts(postsTmp, type);
      });
    else if (type == SortType.dates_desc)
      setState(() {
        posts = PostServices.sortPosts(postsTmp, type);
      });
    else if (type == SortType.leaves_asc)
      setState(() {
        posts = PostServices.sortPosts(postsTmp, type);
      });
    else if (type == SortType.leaves_desc)
      setState(() {
        posts = PostServices.sortPosts(postsTmp, type);
      });
    else if (type == SortType.comments_asc)
      setState(() {
        posts = PostServices.sortPosts(postsTmp, type);
      });
    else if (type == SortType.comments_desc)
      setState(() {
        posts = PostServices.sortPosts(postsTmp, type);
      });
    else
      setState(() {
        posts = postsTmp;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SmartRefresher(
        onRefresh: _onRefresh,
        enablePullDown: true,
        controller: _refreshController,
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            _layout(),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: posts == null ? 0 : posts.length,
                shrinkWrap: true,
                itemBuilder: (ctx, i) {
                  return HomePost(
                      ValueKey(posts[i].id), posts[i], deletePost, reportPost);
                })
          ],
        ),
      ),
    );
  }

  Widget _layout() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(color: Colors.grey[200], height: 10),
          Divider(),
          _buildTrendingSlider(),
          SizedBox(
            height: 1,
          ),
          Divider(),
          Container(
            //margin: EdgeInsets.only(left: 10, right: 10),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "    " + "Problemi",
                  style: homeInfo,
                ),
                PopupMenuButton<SortType>(
                    icon: Icon(FontAwesomeIcons.filter),
                    onSelected: sortPosts,
                    itemBuilder: (BuildContext context) {
                      List<PopupMenuItem<SortType>> list =
                          List<PopupMenuItem<SortType>>();
                      sortOptions.forEach((key, value) {
                        list.add(PopupMenuItem<SortType>(
                          value: key,
                          child: Text(value, style: homeInfo),
                        ));
                      });

                      return list;
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingSlider() {
    return popularPosts == null || posts == null
        ? CircularProgressIndicator()
        : CarouselSlider(
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            pauseAutoPlayOnTouch: Duration(seconds: 5),
            height: 200,
            items: popularPosts.map((i) {
              //povezati sa metodom koja izvlaci postove sa najvise lajkova
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: GestureDetector(
                      onTap: () async {
                        var institution;
                        if (i.institutionUserName != null) {
                          institution = await Provider.of<UserService>(context,
                                  listen: false)
                              .getUser(i.institutionUserName);
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostDetail(i, institution),
                          ),
                        );
                      },
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: FadeInImage(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              fit: BoxFit.cover,
                              placeholder: AssetImage("assets/placeholder.jpg"),
                              image: NetworkImage(postImageURL + i.imgUrl[0]),
                            ),
                          ),
                          ListTile(
                            leading: Container(
                              margin: EdgeInsets.only(
                                top: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.lightGreen,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: CircleAvatar(
                                  radius: 22,
                                  backgroundImage: NetworkImage(
                                      checkUserImgUrl(i.userImageUrl)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
  }
}
