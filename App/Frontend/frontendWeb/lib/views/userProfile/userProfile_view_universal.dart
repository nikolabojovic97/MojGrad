import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/enums/confirm.dart';
import 'package:frontendWeb/enums/sort.dart';
import 'package:frontendWeb/models/post.dart';
import 'package:frontendWeb/models/user.dart';
import 'package:frontendWeb/services/postServices.dart';
import 'package:frontendWeb/services/userServices.dart';
import 'package:frontendWeb/utils/app_routes.dart';
import 'package:frontendWeb/widgets/alert.dart';
import 'package:frontendWeb/widgets/homePost.dart';
import 'package:provider/provider.dart';

class UserProfileUniversal extends StatefulWidget {
  final String username;

  UserProfileUniversal({Key key, this.username}) : super(key: key);

  @override
  _UserProfileUniversalState createState() => _UserProfileUniversalState(username);
}

class _UserProfileUniversalState extends State<UserProfileUniversal> {
  final String deleteAccountTitle = "Brisanje korisničkog naloga";
  final String deleteAccountContent = "Da li ste sigurni da želite da obrišete korisnički nalog?";

  List<Post> posts;
  User user;
  final String username;
  bool isLoading; 
  User loggedUser;

  _UserProfileUniversalState(this.username);

  Future<void> getAllPosts(String username) async {
    setState(() {
      isLoading = true;
    });

    var response = await PostServices.getPosts(username, loggedUser.token);
    response = PostServices.sortPosts(response, SortType.dates_desc);

    setState(() {
      posts = response;
      isLoading = false;
    });
  }

  Future<void> initUser() async {
    loggedUser = Provider.of<UserService>(context, listen: false).user;
    user = await Provider.of<UserService>(context, listen: false).getUser(username);
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

    if (username == null)
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushReplacementNamed(AppRoutes.users);
      });
    else {
      initUser();
      getAllPosts(username);
    } 
  }

  @override
  void dispose() { 
    super.dispose();
  } 

  Future<void> deletePost(int postId) async {
    bool deleted = await PostServices.deletePost(postId, loggedUser.token);

    if (deleted) {
      setState(() {
        posts.removeWhere((element) => element.id == postId);
      });

      showDialog(context: context, child: alert("Brisanje objave", "Objava je uspešno obrisana."));
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
            return HomePost(UniqueKey(), posts[i], deletePost);
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
            user.roleID == 2 ? "Institucija" : "Regularni korisnik",
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
              "Izbrišite nalog",
              style: saveChanges,
            ),
            color: Colors.red,
            onPressed: () async {
              var answer = await asyncConfirmDialog(context, deleteAccountTitle, deleteAccountContent);

              if (answer == ConfirmAction.ACCEPT) {
                await PostServices.deleteAllPostsByUser(user.username, loggedUser.token);
                Provider.of<UserService>(context, listen: false).deleteUserAccount(user.username);
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              }
            },
          ),
        ],
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