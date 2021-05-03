import 'package:Frontend/commons/theme.dart';
import 'package:Frontend/models/post.dart';
import 'package:Frontend/models/postReport.dart';
import 'package:Frontend/models/user.dart';
import 'package:Frontend/services/postCommentServices.dart';
import 'package:Frontend/services/postReportServices.dart';
import 'package:Frontend/services/postServices.dart';
import 'package:Frontend/services/userServices.dart';
import 'package:Frontend/widgets/homePost.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _controller = TextEditingController();
  User _user;
  List<Post> posts;

  @override
  initState() {
    super.initState();
    _user = Provider.of<UserService>(context, listen: false).user;
    posts = null;
  }

  Future<void> reportPost(int postId) async {
    PostReport postReport = PostReport(_user.username, postId);
    bool reported = await PostReportServices.reportPost(postReport, _user.token);
    if (reported) {
      showDialog(
          context: context,
          child: AlertDialog(title: Text("Vaša prijava je registrovana.")));
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
        child: 
          AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            title: Text(
              "Brisanje objave",
              style: alertTitle,
            ),
            content: Text(
              "Vaša objava je uspešno obrisana.",
              style: alertContent,
            )
          )
        );
    } else
      showDialog(
        context: context,
        child: 
          AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            title: Text(
              "Brisanje objave",
              style: alertTitle,
            ),
            content: Text(
              "Objava nije izbrisana. Pokušajte ponovo.",
              style: alertContent,
            )
          )
        );
  }

  Future<void> searchPosts(context, String value) async {
    if (value.isEmpty) {
      setState(() {
        posts = null;
      });
      return null;
    }
    var response = await PostServices.getSearchedPosts(value, _user.username, _user.token);

    for (var post in response) {
      post.postComments = await PostCommentServices.getPostComments(post.id, _user.token);
    }

    setState(() {
      posts = response;
    });

    FocusScope.of(context).requestFocus(FocusNode());
  }

  Widget _textFormField(context) {
    return TextFormField(
      controller: _controller,
      decoration: new InputDecoration(
        labelText: "Pretražite po korisniku, opisu, gradu ili datumu",
        labelStyle: searchFieldPlaceholder,
        suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () => searchPosts(context, _controller.text)),
        fillColor: Colors.lightGreen,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(500),
          borderSide: new BorderSide(),
        ),
      ),
      style: searchField,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0), // here the desired height
          child: AppBar(
            leading: BackButton(color: Colors.white),
            title:
                Text("Pretraga objava", style: appBarTitle),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.only(
                    bottomLeft: const Radius.elliptical(50, 50),
                    bottomRight: const Radius.elliptical(50, 50))),
            centerTitle: true,
            backgroundColor: Colors.lightGreen,
            elevation: 0,
          )),
      backgroundColor: Colors.grey[200],
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 16.0, bottom: 40.0),
            child: _textFormField(context),
          ),
          posts == null
              ? Center(
                  child: Text(
                    "Nema objava.",
                    style: noPosts,
                  ),
                )
              : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: posts == null ? 0 : posts.length,
                  shrinkWrap: true,
                  itemBuilder: (ctx, i) {
                    return HomePost(ValueKey(posts[i].id), posts[i], deletePost,
                        reportPost);
                  }),
        ],
      ),
    );
  }
}
