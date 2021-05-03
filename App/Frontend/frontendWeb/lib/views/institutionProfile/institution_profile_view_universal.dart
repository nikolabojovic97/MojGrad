import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/enums/sort.dart';
import 'package:frontendWeb/models/post.dart';
import 'package:frontendWeb/models/user.dart';
import 'package:frontendWeb/services/postServices.dart';
import 'package:frontendWeb/services/userServices.dart';
import 'package:frontendWeb/utils/app_routes.dart';
import 'package:frontendWeb/widgets/alert.dart';
import 'package:frontendWeb/widgets/homePostInstitution.dart';
import 'package:provider/provider.dart';

class InstitutionProfileUniversal extends StatefulWidget {
  InstitutionProfileUniversal({Key key}) : super(key: key);

  @override
  _InstitutionProfileUniversalState createState() => _InstitutionProfileUniversalState();
}

class _InstitutionProfileUniversalState extends State<InstitutionProfileUniversal> {
  User user;
  List<Post> posts;
  bool isLoading;

  Future<void> getAllPosts(username) async {
    setState(() {
      isLoading = true;
    });

    var response = await PostServices.getPostsForUser(username, user.token);

    response = PostServices.postsByUser(response, username);
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
    user = Provider.of<UserService>(context, listen: false).user;
    getAllPosts(user.username);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> deletePost(int postId) async {
    bool deleted = await PostServices.deletePost(postId, user.token);

    if (deleted) {
      setState(() {
        posts.removeWhere((element) => element.id == postId);
      });

      showDialog(context: context, child: alert("Brisanje objave", "Vaša objava je uspešno obrisana."));
    }
    else {
      showDialog(context: context, child: alert("Brisanje objave", "Objava nije obrisana. Pokušajte ponovo."));
    }
  }

  @override
  Widget build(BuildContext context) {
    return user == null ? Center(child: CircularProgressIndicator()) : ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 10),
          child: profileMainDetails(),
        ),
        SizedBox(
          height: 20,
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
            return HomePostInstitution(UniqueKey(), posts[i], deletePost, null, null);
          },
          separatorBuilder: (ctx, i) {
            return SizedBox(height: 20);
          },
        )
      ],
    );
  }

  Widget profileMainDetails() {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Wrap(
        spacing: 30,
        alignment: WrapAlignment.center,
        direction: Axis.horizontal,
        children: [
          profilePicture(),
          profileMainInfo(),
        ],
      ),
    );
  }

  Widget profilePicture() {
    return Container(
      width: 200,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              checkUserImgUrl(user.imgUrl)
            ),
          ),
        ),
      ),
    );
  }

  Widget profileMainInfo() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 15),
      width: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.name,
            style: profileName,
          ),
          Text(
            user.username,
            style: profileUsername,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            user.email,
            style: profileInfoStyle,
          ),
          Text(
            "Institucija",
            style: profileInfoBold,
          ),
          SizedBox(
            height: 20,
          ),
          FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)
            ),
            child: Text(
              "Izmenite nalog",
              style: saveChanges,
            ),
            color: Colors.lightGreen,
            onPressed: () {
              Navigator.of(context).popAndPushNamed(AppRoutes.editInstitutionProfile);
            },
          ),
        ],
      ),
    );
  }
}