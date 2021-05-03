import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:Frontend/commons/messages.dart';
import 'package:Frontend/commons/theme.dart';
import 'package:Frontend/config/config.dart';
import 'package:Frontend/models/imagePredictionResult.dart';
import 'package:Frontend/services/mapServices.dart';
import 'package:Frontend/services/tfliteImageService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import '../../models/post.dart';
import '../../models/uploadPostImage.dart';
import '../../models/user.dart';
import '../../services/postServices.dart';
import '../../services/userServices.dart';
import 'package:Frontend/models/postProblemType.dart';
import 'prehome.dart';
import 'camera.dart';

enum ImageType { CAMERA, GALLERY }

class NewPost extends StatefulWidget {
  File _image;
  List<Asset> images = [];
  ImageType _imageType;
  PostType _postType;
  List<User> institutions = [];
  NewPost(this._imageType, this._image, this._postType, this.institutions);
  NewPost.fromGallery(
      this._imageType, this.images, this._postType, this.institutions);
  @override
  _NewPostState createState() =>
      new _NewPostState(_imageType, _image, images, _postType, institutions);
}

class _NewPostState extends State<NewPost> {
  bool isChecked = false;
  File _image;
  List<Asset> images = [];
  ImageType _imageType;
  User _user;
  String _selectedInstitution;
  Post _post;
  PostType _postType;
  ImagePredictionResult _ipResult;
  final List<DropdownMenuItem> items = [];
  List<User> institutions = [];
  bool _isLoading;

  _NewPostState(this._imageType, this._image, this.images, this._postType,
      this.institutions);

  LocationResult _pickedLocation;
  TextEditingController _description = TextEditingController();

  void initTFLite() async {
    var result;
    TFLiteImageService.loadModel();
    if (_imageType == ImageType.CAMERA)
      result = await TFLiteImageService.classifyImage(_image.path);
    else if (_imageType == ImageType.GALLERY)
      result = await TFLiteImageService.classifyImage(
          await FlutterAbsolutePath.getAbsolutePath(images.first.identifier));

    setState(() {
      _ipResult = result;
    });
  }

  initState() {
    super.initState();
    _user = Provider.of<UserService>(context, listen: false).user;
    initTFLite();
    for (var item in institutions) {
      items.add(DropdownMenuItem(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(checkUserImgUrl(item.imgUrl)),
          ),
          title: Text(item.username),
          subtitle: Text(item.city),
        ),
        value: item.username,
      ));
    }
    _isLoading = false;
  }

  Future<bool> createPost(context) async {
    if (_image == null) return false;

    _post = Post(
        _user.username,
        _description.text,
        _user.city,
        "${_pickedLocation.latLng.latitude},${_pickedLocation.latLng.longitude}",
        _pickedLocation.address);
    if (_selectedInstitution != null) {
      _post.institutionUserName = _selectedInstitution;
    }
    Post added = await PostServices.addPost(_post, _user.token);

    if (added != null) {
      String base64Image = "" + base64Encode(_image.readAsBytesSync());
      String name = DateTime.now().millisecondsSinceEpoch.toString() +
          _user.username +
          ".jpg";
      List<String> images = [];
      images.add(base64Image);
      UploadPostImage postImage = UploadPostImage(added.id, name, images);
      bool isAddedImg = await PostServices.addPostImage(postImage, _user.token);
      if (isAddedImg) {
        sendPostProblemType(added);
        return true;
      } else {
        return false;
      }
    } else {
      print("Došlo je do greške prilikom dodavanja objave.");
      return false;
    }
  }

  Future<bool> createPostFromGallery() async {
    _post = Post(
        _user.username,
        _description.text,
        _user.city,
        "${_pickedLocation.latLng.latitude},${_pickedLocation.latLng.longitude}",
        _pickedLocation.address);
    if (_selectedInstitution != null) {
      _post.institutionUserName = _selectedInstitution;
    }
    Post added = await PostServices.addPost(_post, _user.token);

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
        bool isAddedImg =
            await PostServices.addPostImage(postImage, _user.token);
        if (isAddedImg == false) {
          return false;
        }
      }
      sendPostProblemType(added);
      return true;
    } else {
      print("Došlo je do greške prilikom dodavanja objave.");
      return false;
    }
  }

  Future<void> sendPostProblemType(post) async {
    var ppType = PostProblemType(post.id, _ipResult.id);
    await TFLiteImageService.addResult(ppType, Provider.of<UserService>(context, listen: false).user.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          leading: BackButton(color: Colors.white),
          title: Text("Kreirajte objavu", style: appBarTitle),
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.only(
                  bottomLeft: const Radius.elliptical(50, 50),
                  bottomRight: const Radius.elliptical(50, 50))),
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
          elevation: 0,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: IconButton(
                icon: Icon(
                  Icons.done,
                  color: Colors.white,
                ),
                onPressed: () async {
                  if (_isLoading == false) {
                    Future.delayed(const Duration(seconds: 10));
                    setState(() {
                      _isLoading = true;
                    });
                    bool created;
                    if (_imageType == ImageType.CAMERA) {
                      created = await createPost(context);
                    } else {
                      created = await createPostFromGallery();
                    }
                    if (created) {
                      setState(() {
                        _isLoading = false;
                      });
                      TFLiteImageService.dispose();
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
                                child: Text(addNewPostFailed),
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
                        },
                      );
                    }
                  }
                  else 
                    showDialog(context: context, child: AlertDialog(content: Text("Objavljivanje u toku.", style: alertContent), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))));
                }, //OBJAVI
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(children: [
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
              _descrtiption(context),
              _institutionsDropDown(),
              _location(),
            ],
          ),
        ]),
      ),
    );
  }

  Widget _descrtiption(context) {
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
            "Opis problema",
            style: infoFieldBold,
          ),
          subtitle: TextField(
            controller: _description,
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

  Widget _institutionsDropDown() {
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
              "Institucija",
              style: infoFieldBold,
            ),
          ),
          subtitle: SearchableDropdown.single(
            style: infoField,
            items: items,
            value: _selectedInstitution,
            onChanged: (value) {
              setState(() {
                _selectedInstitution = value;
              });
            },
            hint: "Izaberite",
            isExpanded: true,
            dialogBox: false,
            menuConstraints: BoxConstraints.tight(Size.fromHeight(400)),
            iconSize: 30,
            iconEnabledColor: Colors.lightGreen,
            closeButton: "Zatvori",
          ),
        ),
      ),
      trailing: Icon(
        Icons.account_balance,
        size: 30,
      ),
    );
  }

  void getLocationFromMap(context) async {
    var initLocation = await MapServices.getCityLatLng(_user.city);

    LocationResult result = await showLocationPicker(
      context,
      apiKey,
      myLocationButtonEnabled: true,
      layersButtonEnabled: true,
      initialCenter: initLocation,
    );

    if (result.address == null) result.address = "Adresa ne postoji";

    setState(() {
      _pickedLocation = result;
    });
  }

  void getLocationFromDevice() async {
    LatLng location = await MapServices.getDeviceLocation();
    var address = await MapServices.getAddress(location);

    if (address == null) address = "Adresa ne postoji";

    setState(() {
      _pickedLocation = LocationResult(latLng: location, address: address);
    });
  }

  Widget _location() {
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
              "Lokacija",
              style: infoFieldBold,
            ),
          ),
          subtitle: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      RaisedButton(
                          color: Colors.lightGreen,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Row(
                            children: <Widget>[
                              Text("Mapa", style: locationOption),
                              Icon(Icons.map, size: 33),
                            ],
                          ),
                          onPressed: () {
                            getLocationFromMap(context);
                          }),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      RaisedButton(
                          color: Colors.lightGreen,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Row(
                            children: <Widget>[
                              Text("Telefon", style: locationOption),
                              Icon(Icons.location_searching, size: 33),
                            ],
                          ),
                          onPressed: () {
                            getLocationFromDevice();
                          }),
                    ],
                  ),
                ],
              ),
              (_pickedLocation != null)
                  ? ListTile(
                      title: Text("Koordinate"),
                      subtitle: Text((_pickedLocation != null)
                          ? _pickedLocation.latLng.toString()
                          : ""),
                    )
                  : Text(""),
              (_pickedLocation != null)
                  ? ListTile(
                      title: Text("Adresa"),
                      subtitle: Text((_pickedLocation != null)
                          ? _pickedLocation.address.toString()
                          : ""),
                    )
                  : Text(""),
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
}
