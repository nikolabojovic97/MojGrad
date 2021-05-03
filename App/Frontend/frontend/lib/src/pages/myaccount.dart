import 'dart:io';
import 'dart:convert';

import 'package:Frontend/commons/theme.dart';
import 'package:Frontend/config/config.dart';
import 'package:Frontend/models/enums.dart';
import 'package:Frontend/models/user.dart';
import 'package:Frontend/models/uploadUserImage.dart';
import 'package:Frontend/services/userServices.dart';
import 'package:Frontend/src/pages/profilePage.dart';
import 'package:Frontend/widgets/closeIcon.dart';
import 'package:Frontend/widgets/entryAccountInfo.dart';
import 'package:Frontend/widgets/accountImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import '../../main.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  User _user;
  NetworkImage _image;

  List<String> cities = [
    "Beograd",
    "Kragujevac",
    "Niš",
    "Novi Sad",
    "Subotica",
    "Čačak"
  ];
  List<DropdownMenuItem<String>> _items = List<DropdownMenuItem<String>>();

  final _formKey = GlobalKey<FormState>();

  TextEditingController _username = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _bio = TextEditingController();
  TextEditingController _phone = TextEditingController();

  void init() {
    _username.text = _user.username;
    _name.text = _user.name;
    _email.text = _user.email;
    _bio.text = _user.bio != "" ? _user.bio : "_";
    _phone.text = _user.phone;
  }

  void changeImage(String imageName) {
    setState(() {
      _image = NetworkImage(getUserImageURL + imageName);
      _user.imgUrl = imageName;
    });
  }

  void initImage() {
    _image = NetworkImage(checkUserImgUrl(_user.imgUrl));
  }

  @override
  initState() {
    super.initState();
    _user = Provider.of<UserService>(context, listen: false).user;
    init();
    initImage();
    for (var city in cities)
      _items.add(DropdownMenuItem<String>(
        value: city,
        child: Container(
          child: Text(city),
        ),
      ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void logout(context) {
    Provider.of<UserService>(context, listen: false).logout();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
  }

  Future getNewImage(ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.lightGreen,
            toolbarTitle: "Isecite fotografiju",
            statusBarColor: Colors.lightGreen,
            backgroundColor: Colors.white,
            toolbarWidgetColor: Colors.white,
          ));

      if (image == null || cropped == null) return;

      List<int> imageData = await cropped.readAsBytes();
      var oldImageName = _user.imgUrl;
      if (_user.imgUrl == "no-image.png") oldImageName = "";
      var result = await Provider.of<UserService>(context, listen: false)
          .changeUserImage(
              UploadUserImage(_user.username, base64Encode(imageData)),
              oldImageName);

      if (result != "") {
        showDialog(
            context: context,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              title: Text(
                "Status izmene",
                style: alertTitle,
              ),
              content: Text(
                "Slika profila uspešno izmenjena.",
                style: alertContent,
              ),
            ));
        setState(() {
          changeImage(result);
        });
      } else {
        showDialog(
            context: context,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              title: Text(
                "Status izmene",
                style: alertTitle,
              ),
              content: Text(
                "Slika profila nije izmenjena.",
                style: alertContent,
              ),
            ));
      }
    }
  }

  Future<void> updateProfile(context) async {
    _user.isVerify = true;
    if (_formKey.currentState.validate()) {
      // name, bio, phone - optional
      if (_name.text != "")
        _user.name = _name.text;
      if (_bio.text != "")
        _user.bio = _bio.text;
      if (_phone.text != "")
        _user.phone = _phone.text;

      var updated = await Provider.of<UserService>(context, listen: false).updateUserAccount(_user);
      if (updated != null) {
        showDialog(
            context: context,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              title: Text(
                "Status izmene",
                style: alertTitle,
              ),
              content: Text(
                "Profil uspešno izmenjen.",
                style: alertContent,
              ),
            ));
        setState(() {
          _user = Provider.of<UserService>(context, listen: false).user;
          init();
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(username: _user.username)),
            (route) => false);
      } else
        showDialog(
            context: context,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              title: Text(
                "Status izmene",
                style: alertTitle,
              ),
              content: Text(
                "Profil nije izmenjen.",
                style: alertContent,
              ),
            ));
    }
  }

  Widget _saveIcon(context) {
    return GestureDetector(
      child: Container(
        child: Icon(
          Icons.check,
        ),
        padding:
            EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.1),
      ),
      onTap: () => updateProfile(context),
    );
  }

  Widget _customAppBar(context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      title: Text(
        "Izmena profila",
        style: appBarTitle,
      ),
      backgroundColor: Colors.lightGreen,
      leading: CloseIcon(),
      actions: <Widget>[_saveIcon(context)],
    );
  }

  Widget _changeProfileImage(context) {
    return GestureDetector(
      onTap: () async => getNewImage(ImageSource.gallery),
      child: Text(
        "Menjanje slike profila",
        style: mainAccountText,
      ),
    );
  }

  Widget _logoutButton(context) {
    return FlatButton(
      padding: null,
      child: Text(
        "Odjavite se",
        style: mainAccountText,
      ),
      onPressed: () => logout(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppBar(context),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              AccountImage(_image, 1),
              SizedBox(
                height: 10,
              ),
              _changeProfileImage(context),
              SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      /* title: ListTile(
            title: Text(
              "Institucija",
              style: infoFieldBold,
            ),
          ),*/
                      subtitle: SearchableDropdown.single(
                        style: infoField,
                        items: _items,
                        value: _user.city,
                        onChanged: (value) {
                          setState(() {
                            _user.city = value;
                          });
                        },
                        hint: "Izaberite",
                        isExpanded: true,
                        dialogBox: false,
                        menuConstraints:
                            BoxConstraints.tight(Size.fromHeight(300)),
                        iconSize: 30,
                        iconEnabledColor: Colors.lightGreen,
                        closeButton: "Zatvori",
                      ),
                    ),
                    EntryAccountInfo("Korisničko ime",
                        type: EntryAccountType.username, controller: _username),
                    EntryAccountInfo("Ime",
                        type: EntryAccountType.name, controller: _name),
                    EntryAccountInfo("Email",
                        type: EntryAccountType.email, controller: _email),
                    EntryAccountInfo("Bio",
                        type: EntryAccountType.bio, controller: _bio),
                    EntryAccountInfo("Broj telefona",
                        type: EntryAccountType.phone, controller: _phone),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _logoutButton(context),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
