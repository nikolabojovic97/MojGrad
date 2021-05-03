import 'package:Frontend/commons/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../models/post.dart';
import '../../models/user.dart';
import '../../services/userServices.dart';
import '../../services/postServices.dart';
import 'addSolution.dart';
import 'newPost.dart';

import 'package:image_picker/image_picker.dart';

enum PostType { POST, SOLUTION }

class Camera extends StatefulWidget {
  Post post;
  PostType _postType;
  int _postId;

  Camera(this._postType);
  Camera.fromSolution(this._postType, this._postId);

  @override
  _CameraState createState() => _CameraState(_postType, _postId);
}

class _CameraState extends State<Camera> {
  File _image;
  bool ind = true;
  PostType _postType;
  int _postId;
  Post _postProblem;
  User _user;
  _CameraState(this._postType, this._postId);

  Future getImage() async {
    File image;

    image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  void init() {
    if (ind == true) {
      ind = false;
      getImage();
    }
  }

  @override
  void initState() {
    _user = Provider.of<UserService>(context, listen: false).user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    init();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Izaberite fotografije", style: appBarTitle),
          backgroundColor: Colors.lightGreen,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  _image == null
                      ? Container()
                      : ClipRect(
                          child: Image.file(
                            _image,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.6,
                            fit: BoxFit.cover,
                          ),
                        ),
                  SizedBox(
                    height: 50.0,
                  ),
                  _image == null
                      ? Column()
                      : Container(
                          margin: EdgeInsets.only(left: 100.0),
                          child: Row(
                            children: <Widget>[
                              RaisedButton(
                                color: Colors.lightGreen,
                                textColor: Colors.white,
                                child: Text("Ponovo", style: again),
                                padding: EdgeInsets.symmetric(vertical: 19),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Camera(_postType)));
                                },
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                              RaisedButton(
                                color: Colors.lightGreen,
                                textColor: Colors.white,
                                child: Text("Dalje", style: next),
                                padding: EdgeInsets.symmetric(vertical: 19),
                                onPressed: () async {
                                  if (_postType == PostType.POST) {
                                    var institutions = await  Provider.of<UserService>(context, listen: false)
                                        .getAllVerifyInstitutions();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NewPost(
                                                ImageType.CAMERA,
                                                _image,
                                                _postType,
                                                institutions)));
                                  } else {
                                    _postProblem =
                                        await PostServices.getPostById(_postId, _user.token);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddSolution(
                                            ImageType.CAMERA,
                                            _image,
                                            _postProblem),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
