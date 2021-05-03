import 'package:Frontend/commons/theme.dart';
import 'package:Frontend/models/user.dart';
import 'package:Frontend/src/pages/addSolution.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/post.dart';
import '../../services/userServices.dart';
import '../../services/postServices.dart';
import 'camera.dart';
import 'newPost.dart';

class Gallery extends StatefulWidget {
  PostType _postType;
  int _postId;

  Gallery(this._postType);
  Gallery.fromSolution(this._postType, this._postId);
  @override
  _GalleryState createState() => new _GalleryState(_postType, _postId);
}

class _GalleryState extends State<Gallery> {
  List<Asset> images = [];
  List<Asset> resultList = List<Asset>();
 
  Post _postProblem;
  PostType _postType;
  int _postId;
  String _error;
  bool ind = false;
  User _user;

  _GalleryState(this._postType, this._postId);

  @override
  void initState() {
    loadAssets();
    _user = Provider.of<UserService>(context, listen: false).user;
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: false,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          statusBarColor: "#FF6E9C5E",
          actionBarColor: "#8bc34a",
          actionBarTitle: "Izaberi",
          allViewTitle: "Sve fotografije",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
          textOnNothingSelected: "Niste označili nijednu fotografiju",
          selectionLimitReachedText:
              "Nije dozvoljeno označiti više od 5 fotografija",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
      ind = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    ind == false ? loadAssets() : null;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0), // here the desired height
        child: AppBar(
          leading: BackButton(color: Colors.white),
          title: Text("Izaberite fotografije", style: appBarTitle),
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.only(
                  bottomLeft: const Radius.elliptical(50, 50),
                  bottomRight: const Radius.elliptical(50, 50))),
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
          elevation: 0,
        ),
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.75,
            child: buildGridView(),
          ),
          Container(
            //margin: EdgeInsets.only(left: 97.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  color: Colors.lightGreen,
                  textColor: Colors.white,
                  child: Text("+", style: plus),
                  onPressed: loadAssets,
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
                      var institutions =
                          await  Provider.of<UserService>(context, listen: false).getAllVerifyInstitutions();
                          
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewPost.fromGallery(
                                  ImageType.GALLERY,
                                  images,
                                  _postType,
                                  institutions)));
                    } else {
                      _postProblem = await PostServices.getPostById(_postId, _user.token);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddSolution.formGalery(
                                  ImageType.GALLERY, images, _postProblem)));
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
