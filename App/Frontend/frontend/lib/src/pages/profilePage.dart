import 'package:Frontend/commons/theme.dart';
import 'package:Frontend/models/enums.dart';
import 'package:Frontend/models/post.dart';
import 'package:Frontend/models/postReport.dart';
import 'package:Frontend/models/user.dart';
import 'package:Frontend/services/postCommentServices.dart';
import 'package:Frontend/services/postReportServices.dart';
import 'package:Frontend/services/postServices.dart';
import 'package:Frontend/services/userServices.dart';
import 'package:Frontend/widgets/homePost.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../main.dart';
import 'allPostsMap.dart';
import 'camera.dart';
import 'gallery.dart';
import 'myaccount.dart';
import 'prehome.dart';

class ProfilePage extends StatefulWidget {
  String username;

  ProfilePage({Key key, @required this.username}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Post> _posts;
  User _owner;
  GlobalKey _bottomNavigationKey = GlobalKey();
  User _user;

  Future<void> getAllPosts() async {
    var response = await PostServices.getPostsForUser(widget.username, _user.token);

    for (var post in response) {
      post.postComments = await PostCommentServices.getPostComments(post.id, _user.token);
    }

    response = PostServices.postsByUser(response, widget.username);
    response = PostServices.sortPosts(response, SortType.dates_desc);

    if(this.mounted)
      setState(() {
        _posts = response;
      });
  }

  Future<void> reportPost(int postId) async {
    PostReport postReport = PostReport(Provider.of<UserService>(context).username, postId);
    bool reported = await PostReportServices.reportPost(postReport, _user.token);
    if (reported) {
      showDialog(
        context: context,
        child: 
          AlertDialog(
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

  Future<void> deletePost(int postId) async {
    bool deleted = await PostServices.deletePost(postId, _user.token);
    if (deleted) {
      setState(() {
        _posts.removeWhere((element) => element.id == postId);
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
          ),
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
                "Objava nije obrisana. Pokušajte ponovo.",
                style: alertContent,
              ),
            )
      );
  }

  Future<void> initOwner() async {
    var owner = await Provider.of<UserService>(context, listen: false).getUser(widget.username);

    if (this.mounted && owner != null) {
      setState(() {
        _owner = owner;
      });
    }
  }

  @override
  initState() {
    super.initState();
    initOwner();
    _user = Provider.of<UserService>(context, listen: false).user;
    getAllPosts();
  }

  void logout(context) {
    Provider.of<UserService>(context, listen: false).logout();
    //Navigator.pop(context);
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize( 
        preferredSize: Size.fromHeight(50.0),
        child: _customAppBar(context)
      ),
      bottomNavigationBar: _customNavBar(),
      body: _posts == null && _owner == null ? Center(child: CircularProgressIndicator(),) :  ListView(
        children: <Widget>[
           _buildInfo(context),
           _postsView()
        ],
      ),
    );
  }

  Widget _customAppBar(context) {
    return AppBar(
      automaticallyImplyLeading: false,
      //leading: BackButton(color: Colors.white),
      title: Padding(
        padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.username, 
            style: appBarTitle,
            textAlign: TextAlign.left,
          ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.only(
        bottomLeft:  const  Radius.elliptical(50, 50),
        bottomRight: const  Radius.elliptical(50, 50))
      ),
      centerTitle: false,
      backgroundColor: Colors.lightGreen,
      elevation: 0,
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
          icon: Icon(
            Icons.exit_to_app, 
            color: Colors.white,
          ),
          onPressed: (){
            logout(context);
          }, 
        ),
        ),
      ],
    );
  }

  Widget _postsView() {
    if(_posts != null && _posts.length != 0)
      return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: _posts.length == null ? 0 : _posts.length,
        shrinkWrap: true,
        itemBuilder: (ctx, i) {
          return HomePost(ValueKey(_posts[i].id), _posts[i],
              deletePost, reportPost);
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

  Widget _buildFullName() {
    if(_owner.name != "_")
    {
    return Text(
      _owner.name,
      style: fullName,
    );
    }
    else
    {
      return Text(
      _owner.username,
      style: fullName,
    );
    }
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

  Widget _buildEditProfile(BuildContext context) {
    if(_owner.name != "_")
    {
      return InkWell( 
        onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyAccount())),
        child: new Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
          height: 50.0,
          width: MediaQuery.of(context).size.width*0.8,
          decoration: new BoxDecoration(
            color: Colors.lightGreen,
            border: new Border.all(color: Colors.lightGreen),
            borderRadius: new BorderRadius.circular(500.0),
          ),
        child: new Center(
          child: Text(
            "Uredite svoj profil, ${_owner.name.split(" ")[0]}",
            style: editProfile,
          ),
        ),
        ),
      );
    }
    else
    {
      return InkWell( 
        onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyAccount())),
        child: new Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
          height: 50.0,
          width: MediaQuery.of(context).size.width*0.8,
          decoration: new BoxDecoration(
            color: Colors.lightGreen,
            border: new Border.all(color: Colors.lightGreen),
            borderRadius: new BorderRadius.circular(500.0),
          ),
        child: new Center(
          child: Text(
            "Uredite svoj profil, ${_owner.username.split(" ")[0]}",
            style: editProfile,
          ),
        ),
        ),
      );
    }
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
                _buildEditProfile(context),
              ],
            ),
          )
        ],
      ),
    );
  }
  
  Alert _alert(){
    return Alert(
      context: context,
      style: AlertStyle(
        titleStyle: alertTitle,
        isCloseButton: false,
      ),
      title: "Dodajte fotografiju",
      buttons: [
        DialogButton(
          height: 140.0,
          child: Icon(
            Icons.camera_alt,
            size: 100.0,
            color: Colors.lightGreen,
          ),
          color: Colors.white,
          onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Camera(PostType.POST))),
          width: 120,
        ),
        DialogButton(
          height: 140.0,
          child: Icon(
            Icons.insert_drive_file,
            size: 100.0,
            color: Colors.lightGreen,
          ),
          color: Colors.white,
          onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Gallery(PostType.POST))),
          width: 120,
        )
      ],
    );
  }

  Widget _customNavBar(){
    Alert alert = _alert();
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      backgroundColor: Colors.lightGreen,
      index: 3,
      height: 50.0,
      items: <Widget>[
        Icon(Icons.home, size: 30),
        Icon(Icons.camera, size: 30),
        Icon(Icons.map, size: 30),
        Icon(Icons.person, size: 30)
        ],
        buttonBackgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
      onTap: (index) {
        if(index == 0){
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomePage()));
        }
        else if(index == 1){
          alert.show();
        }
        else if(index == 2) {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => AllPostsMap()));
        }
        else {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => MyAccount()));
        }
      },
    );
  }
}
