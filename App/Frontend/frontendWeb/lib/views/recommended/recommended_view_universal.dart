import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/enums/sort.dart';
import 'package:frontendWeb/models/post.dart';
import 'package:frontendWeb/models/postReport.dart';
import 'package:frontendWeb/models/user.dart';
import 'package:frontendWeb/services/postReportServices.dart';
import 'package:frontendWeb/services/postServices.dart';
import 'package:frontendWeb/services/userServices.dart';
import 'package:frontendWeb/widgets/alert.dart';
import 'package:frontendWeb/widgets/homePostInstitution.dart';
import 'package:provider/provider.dart';

class RecommendedUniversal extends StatefulWidget {
  RecommendedUniversal({Key key}) : super(key: key);

  @override
  _RecommendedUniversalState createState() => _RecommendedUniversalState();
}

class _RecommendedUniversalState extends State<RecommendedUniversal> {
  User user;
  List<Post> posts;

  bool isLoading;

  Future<void> getAllPosts(username) async {
    setState(() {
      isLoading = true;
    });

    var response = await PostServices.getPostsForUser(username, user.token);

    response = PostServices.recommendedPosts(response, username);
    response = PostServices.sortPosts(response, SortType.dates_desc);

    setState(() {
      posts = response;
      isLoading = false;
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserService>(context, listen: false).user;
    getAllPosts(user.username);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refreshPage(int postId) {
    setState(() {
      posts.removeWhere((element) => element.id == postId);
    });
  }

  Future<void> reportPost(int postId) async {
    PostReport postReport = PostReport(user.username, postId);
    bool reported = await PostReportServices.addPostReport(postReport, user.token);

    if (reported) {
      showDialog(context: context, child: alert("Status prijave", "Vaša prijava je registrovana."));
    }
    else {
      showDialog(context: context, child: alert("Status prijave", "Došlo je do greške prilikom prijavljivanja objave. Pokušajte ponovo."));
    }
  }

  void sortPosts(SortType type) {
    var postsTmp = posts;

    setState(() {
      posts = null;
    });

    if (type == SortType.dates_asc) {
      setState(() {
        posts = PostServices.sortPosts(postsTmp, type);
      });
    }
    else if (type == SortType.dates_desc) {
      setState(() {
        posts = PostServices.sortPosts(postsTmp, type);
      });
    }
    else if (type == SortType.leaves_asc) {
      setState(() {
        posts = PostServices.sortPosts(postsTmp, type);
      });
    }
    else if (type == SortType.leaves_desc) {
      setState(() {
        posts = PostServices.sortPosts(postsTmp, type);
      });
    }
    else if (type == SortType.comments_asc) {
      setState(() {
        posts = PostServices.sortPosts(postsTmp, type);
      });
    }
    else if (type == SortType.comments_desc) {
      setState(() {
        posts = PostServices.sortPosts(postsTmp, type);
      });
    }
    else {
      setState(() {
        posts = postsTmp;
      });
    } 
  }

  @override
  Widget build(BuildContext context) {
    return user == null ? Center(child: CircularProgressIndicator()) : ListView(
      shrinkWrap: true,
      children: [
        Container(
          padding: EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          child: PopupMenuButton<SortType>(
            onSelected: posts == null ? null : sortPosts,
            icon: Icon(FontAwesomeIcons.filter),
            itemBuilder: (BuildContext context) {
              List<PopupMenuItem<SortType>> list = List<PopupMenuItem<SortType>>();
              sortOptions.forEach((key, value) {
                list.add(PopupMenuItem<SortType>(
                  value: key,
                  child: Text(value, style: userRowContent),
                ));
              });
              return list;
            }
          ),  
        ),
        isLoading ? Center(child: CircularProgressIndicator()) :
        !isLoading && posts == null ?
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: 50),
            child: Text(
              "Nema objava za prikaz", 
              style: appBarTitle
            )
          )
        ) :
        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          itemCount: posts == null ? 0 : posts.length,
          shrinkWrap: true,
          itemBuilder: (ctx, i) {
            return HomePostInstitution(UniqueKey(), posts[i], null, reportPost, refreshPage);
          },
          separatorBuilder: (ctx, i) {
            return SizedBox(height: 20);
          },
        )
      ],
    );
  }
}
