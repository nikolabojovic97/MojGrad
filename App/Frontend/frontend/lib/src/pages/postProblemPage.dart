import 'package:Frontend/commons/theme.dart';
import 'package:Frontend/models/post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/userServices.dart';
import 'otherUsersProfile.dart';
import 'profilePage.dart';
import '../../widgets/homePost.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class PostProblemPage extends StatefulWidget {
  final Post _postSolution;
  final Function _reportPost;
  PostProblemPage(this._postSolution, this._reportPost);
  @override
  _PostProblemPageState createState() => _PostProblemPageState(_postSolution, _reportPost);
}

class _PostProblemPageState extends State<PostProblemPage> {
  final Post _postSolution;
  final Function _reportPost;

  _PostProblemPageState(this._postSolution, this._reportPost);

  @override
  initState() {
    super.initState();
  }

  Future<void> moveToProfilePage() async {
    if (Provider.of<UserService>(context, listen: false).username != _postSolution.userName) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OtherUser(username: _postSolution.userName)));
    }
    else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePage(username: _postSolution.userName)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(35.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Početni problem",
            style: appBarSolutionTitle,
          ),
          backgroundColor: Colors.lightGreen,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: SingleChildScrollView(
              child: HomePost.solution(_postSolution, _reportPost),
            )
          ),
        ),
      ),
    );
  }
}
