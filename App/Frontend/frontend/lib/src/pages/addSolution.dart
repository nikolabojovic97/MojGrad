import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:Frontend/commons/messages.dart';
import 'package:Frontend/models/PostSolution.dart';
import 'package:Frontend/models/post.dart';
import 'package:Frontend/models/uploadPostImage.dart';
import 'package:Frontend/models/user.dart';
import 'package:Frontend/services/postServices.dart';
import 'package:Frontend/services/userServices.dart';
import 'package:Frontend/src/pages/newPost.dart';
import 'package:Frontend/src/pages/prehome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import '../../commons/theme.dart';

class AddSolution extends StatefulWidget {
  File _image;
  List<Asset> images = [];
  ImageType _imageType;
  Post _postProblem;
  AddSolution(this._imageType, this._image, this._postProblem);
  AddSolution.formGalery(this._imageType, this.images, this._postProblem);
  @override
  _AddSolutionState createState() =>
      new _AddSolutionState(_imageType, _image, images, _postProblem);
}

class _AddSolutionState extends State<AddSolution> {
  File _image;
  List<Asset> images = [];
  ImageType _imageType;
  User _user;
  Post _post;
  Post _postProblem;
  bool _isLoading;

  _AddSolutionState(
      this._imageType, this._image, this.images, this._postProblem);
  TextEditingController _solutionDescription = TextEditingController();

  initState() {
    super.initState();
    _user = Provider.of<UserService>(context, listen: false).user;
    _isLoading = false;
  }

  Future<bool> createPost(context) async {
    if (_image == null) return false;
    if (_postProblem == null) {
      print("Doslo je do greske prilikom dodavanja resenja");
      return false;
    }
    _post = Post(_user.username, _solutionDescription.text, _user.city,
        _postProblem.latLng, _postProblem.address);
    Post added = await PostServices.addPost(_post, _user.token);
    PostSolution postSolution = PostSolution(_postProblem.id, added.id);
    PostServices.addSolutionOnProblem(postSolution, _user.token);

    if (added != null) {
      String base64Image = "" + base64Encode(_image.readAsBytesSync());
      String name = DateTime.now().millisecondsSinceEpoch.toString() +
          _user.username +
          ".jpg";
      List<String> images = [];
      images.add(base64Image);
      UploadPostImage postImage = UploadPostImage(added.id, name, images);
      var isAddedImg = await PostServices.addPostImage(postImage, _user.token);

      return isAddedImg;
    } else
      print("Došlo je do greške prilikom dodavanja objave.");
    return false;
  }

  Future<bool> createPostFromGallery(context) async {
    if (_postProblem == null) {
      print("Doslo je do greske prilikom dodavanja resenja");
      return false;
    }
    _post = Post(_user.username, _solutionDescription.text, _user.city,
        _postProblem.latLng, _postProblem.address);
    Post added = await PostServices.addPost(_post, _user.token);
    PostSolution postSolution = PostSolution(_postProblem.id, added.id);
    bool isAddedSolution =
        await PostServices.addSolutionOnProblem(postSolution, _user.token);

    if (isAddedSolution == false) return false;

    if (added != null) {
      print("dodao sam post");
      for (var image in images) {
        print(images.length);
        ByteData byteData = await image.getByteData();
        Uint8List byteUint8List = byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
        String base64Image = "" + base64Encode(byteUint8List);
        String name = DateTime.now().millisecondsSinceEpoch.toString() +
            _user.username +
            ".jpg";
        List<String> imgs = [];
        imgs.add(base64Image);
        UploadPostImage postImage = UploadPostImage(added.id, name, imgs);
        bool isAddedImg = await PostServices.addPostImage(postImage, _user.token);
        if (isAddedImg == false) {
          return false;
        }
      }
      return true;
    } else {
      print("Došlo je do greške prilikom dodavanja objave.");
      return false;
    }
  }

  Widget _description() {
    return ListTile(
      title: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
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
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(checkUserImgUrl(_user.imgUrl)),
            ),
            title: Text(
              _user.username,
              style: postUsername,
            ),
          ),
        ),
      ),
      trailing: Icon(
        Icons.edit,
        size: 30,
      ),
      subtitle: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
          ),
        ),
        child: ListTile(
          title: Text(
            "Opis rešenja",
            style: infoFieldBold,
          ),
          subtitle: TextField(
            controller: _solutionDescription,
            decoration: new InputDecoration.collapsed(
                hintText: 'Unesite opis...', hintStyle: infoField),
            autofocus: false,
            maxLines: null,
            keyboardType: TextInputType.text,
          ),
        ),
      ),
    );
  }

  Widget _problemLocation() {
    return ListTile(
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
          title: ListTile(
            title: Text(
              "Lokacija problema",
              style: infoFieldBold,
            ),
          ),
          subtitle: Column(
            children: <Widget>[
              (_postProblem.latLng != null)
                  ? ListTile(
                      title: Text("Koordinate"),
                      subtitle: Text((_postProblem.latLng != null)
                          ? _postProblem.latLng.toString()
                          : ""),
                    )
                  : Text("Koordinate nisu poznate"),
              (_postProblem.address != null)
                  ? ListTile(
                      title: Text("Adresa"),
                      subtitle: Text((_postProblem.address != null)
                          ? _postProblem.address.toString()
                          : ""),
                    )
                  : Text("Adresa nije poznata"),
            ],
          ),
        ),
      ),
      trailing: Icon(
        Icons.location_on,
        size: 30,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          leading: BackButton(color: Colors.white),
          title: Text("Dodajte rešenje", style: appBarTitle),
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.only(
                  bottomLeft: const Radius.elliptical(50, 50),
                  bottomRight: const Radius.elliptical(50, 50))),
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: postIcon,
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                bool created;
                if (_imageType == ImageType.CAMERA) {
                  created = await createPost(context);
                } else {
                  created = await createPostFromGallery(context);
                }
                if (created) {
                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                      (route) => false);
                } else {
                  setState(() {
                    _isLoading = false;
                  });
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          title: ListTile(
                            title: Text(
                              "Greska",
                              style: alertOption,
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(addSoulutionFailed),
                            ),
                          ),
                          children: <Widget>[
                            SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Row(children: <Widget>[
                                Icon(
                                  Icons.refresh,
                                  color: Colors.lightGreen,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Pokušajte ponovo"),
                                ),
                              ]),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                    (route) => false);
                              },
                              child: Row(children: <Widget>[
                                Icon(
                                  Icons.home,
                                  color: Colors.lightGreen,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Vratite se na početnu"),
                                ),
                              ]),
                            )
                          ],
                        );
                      });
                }
              }, //OBJAVI
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Builder(
          builder: (context) => Stack(children: [
            Column(
              children: <Widget>[
                (_isLoading)
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : SizedBox.shrink(),
                _description(),
                _problemLocation(),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
