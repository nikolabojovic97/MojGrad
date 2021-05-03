import 'package:flutter/material.dart';
import 'package:Frontend/services/postServices.dart';
import 'package:Frontend/services/postCommentServices.dart';
import 'package:provider/provider.dart';

import '../../commons/theme.dart';
import '../../models/enums.dart';
import '../../models/post.dart';
import '../../models/postReport.dart';
import '../../models/user.dart';
import '../../services/postReportServices.dart';
import '../../services/userServices.dart';

import 'package:Frontend/commons/theme.dart';
import 'package:Frontend/models/enums.dart';
import 'package:Frontend/models/post.dart';
import 'package:Frontend/models/user.dart';
import 'package:Frontend/services/userServices.dart';

import '../../widgets/homePost.dart';

class OtherUser extends StatefulWidget {
  
  String username;
  OtherUser({Key key, @required this.username}) : super(key: key);

  @override
  _OtherUserState createState() => _OtherUserState();
}


class _OtherUserState extends State<OtherUser> {
  List<Post> _posts;
  User _owner;
  User _user;

  Future<void> getAllPosts() async {
    var response = await PostServices.getPostsForUser(_user.username, _user.token);

    for (var post in response) {
      post.postComments = await PostCommentServices.getPostComments(post.id, _user.token);
    }

    response = PostServices.postsByUser(response, widget.username);
    response = PostServices.sortPosts(response, SortType.dates_desc);

    setState(() {
      _posts = response;
    });
  }

  Future<void> initOwner() async {
    var owner = await Provider.of<UserService>(context, listen: false).getUser(widget.username);

    if (this.mounted && owner != null) {
      setState(() {
        _owner = owner;
      });
    }
  }

  Future<void> reportPost(int postId) async {
    // PostReport postReport = PostReport(_owner.username, postId); 
    // bool reported = await PostReportServices.reportPost(postReport, _owner.token);
    PostReport postReport = PostReport(_user.username, postId); 
    bool reported = await PostReportServices.reportPost(postReport, _user.token);
    if(reported) {
      showDialog(
        context: context,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
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
  
   @override
  initState() {
    super.initState();
    initOwner();
    _user = Provider.of<UserService>(context, listen: false).user;
    getAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize( 
        preferredSize: Size.fromHeight(50.0),
        child: _customAppBar(context)
      ),
      body: _posts == null || _owner == null ? Center(child: CircularProgressIndicator(),) :  ListView(
        children: <Widget>[
           _buildInfo(context),
           _postsView()
        ],
      ),
    );
  }

  Widget _customAppBar(context) {
    return AppBar(
      leading: BackButton(color: Colors.white),
      title: Text(
        widget.username, 
        style: appBarTitle,
        textAlign: TextAlign.left,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.only(
        bottomLeft:  const  Radius.elliptical(50, 50),
        bottomRight: const  Radius.elliptical(50, 50))
      ),
      centerTitle: false,
      backgroundColor: Colors.lightGreen,
      elevation: 0,
    );
  }

  Widget _postsView() {
    if(_posts.length != null)
      return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: _posts.length == null ? 0 : _posts.length,
                shrinkWrap: true,
                itemBuilder: (ctx, i) {
                  return HomePost(ValueKey(_posts[i].id), _posts[i],
                      null, reportPost);
                });


    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 35.0),
        child: Text(
          "Korisnik nema objave.",
          style: noPosts,
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        padding: EdgeInsets.symmetric(vertical: 6.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              checkUserImgUrl(_owner.imgUrl),
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 5.0,
          ),
        ),
      ),
    );
  }

  Widget _buildBio(BuildContext context) {
    return Container(
      //color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.only(top: 10.0),
      child: Text(
        _owner.bio,
        textAlign: TextAlign.center,
        style: userBio,
      ),
    );
  }

   Widget _buildFullName() {
    return Text(
      _owner.name,
      style: fullName,
    );
  }

    Widget _buildCity(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        _owner.city,
        style: cityName,
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 15.0, top: 15.0),
            child: SingleChildScrollView(
              child: Row(
                children: <Widget>[
                  _buildProfileImage(),
                  SizedBox(width: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                        _buildFullName(),
                        _buildCity(context),
                      ], ),
                  SizedBox(height: 10.0)
                ],
              ),
            ),   
          ),
          Container(
            child: Column(
              children: <Widget>[
                _buildBio(context),
              ],
            ),
          )
        ],
      ),
    );
  }
}