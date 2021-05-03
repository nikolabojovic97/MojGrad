import 'dart:convert';

import 'package:frontendWeb/models/uploadUserImage.dart';
import 'package:frontendWeb/utils/app_routes.dart';
import 'package:image_picker_web/image_picker_web.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/enums/entry.dart';
import 'package:frontendWeb/models/user.dart';
import 'package:frontendWeb/services/userServices.dart';
import 'package:frontendWeb/widgets/alert.dart';
import 'package:frontendWeb/widgets/profileInfoEntry.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  User user;
  NetworkImage image;

  final _formKey = GlobalKey<FormState>();

  // controllers for input fields
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController bioCtrl = TextEditingController();
  TextEditingController cityCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();

  initInfo() {
    nameCtrl.text = user.name != "" ? user.name : "Ime i prezime";
    bioCtrl.text = user.bio != "" ? user.bio : "Biografija";
    cityCtrl.text = user.city != "" ? user.city : "Grad";
    phoneCtrl.text = user.phone != "" ? user.phone : "Broj telefona";
  }

  void initImage() {
    image = NetworkImage(checkUserImgUrl(user.imgUrl));
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
    user = Provider.of<UserService>(context, listen: false).user;
    initInfo();
    initImage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refreshPage() {
    if (user.roleID == 1)
        Navigator.of(context).popAndPushNamed(AppRoutes.editProfile);
    else
      Navigator.of(context).popAndPushNamed(AppRoutes.editInstitutionProfile);
  }

  Future<void> updateProfile(context) async {
    if (_formKey.currentState.validate()) {
      user.name = nameCtrl.text;
      user.city = cityCtrl.text;

      if (bioCtrl.text != "")
        user.bio = bioCtrl.text;
      if (phoneCtrl.text != "")
        user.phone = phoneCtrl.text;

      var updated = await Provider.of<UserService>(context, listen: false).updateUserAccount(user);

      if(updated != null) {
        refreshPage();
        showDialog(context: context, child: alert("Status izmene", "Profil je uspešno izmenjen."));
      }
      else {
        showDialog(context: context, child: alert("Status izmene", "Profil nije izmenjen."));
      }
    }
  }

  Future pickImage() async {
    List<int> fromPicker = await ImagePickerWeb.getImage(outputType: ImageType.bytes);

    var oldImageName = user.imgUrl;
    if (user.imgUrl == "no-image.png" || user.imgUrl == "no-image-institution.png") 
      oldImageName = "";

    var result = await Provider.of<UserService>(context, listen: false)
                .changeUserImage(UploadUserImage(user.username, base64Encode(fromPicker)), 
                oldImageName);

    if (result != "") {
      refreshPage();
      showDialog(context: context, child: alert("Status izmene", "Slika profila uspešno izmenjena."));
    }
    else {
      showDialog(context: context, child: alert("Status izmene", "Slika profila nije izmenjena. Pokušajte ponovo."));
    }
  } 

  @override
  Widget build(BuildContext context) {
    return user == null ? Center(child: CircularProgressIndicator()) : ListView(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      children: [
        profileMainDetails(),
        SizedBox(
          height: 10,
        ),
        profileInfo(),
      ],
    );
  }

  Widget profileMainDetails() {
    return Container(
      padding: EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width,
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

  Widget profileInfo() {
    return Container(
      padding: EdgeInsets.all(30.0),
      width: MediaQuery.of(context).size.width,
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
      child: Container(
        width: 200,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ProfileInfoEntry("Ime i prezime", ProfileEntryType.Name, nameCtrl),
              SizedBox(
                height: 10,
              ),
              ProfileInfoEntry("Biografija", ProfileEntryType.Bio, bioCtrl),
              SizedBox(
                height: 10,
              ),
              ProfileInfoEntry("Grad", ProfileEntryType.City, cityCtrl),
              SizedBox(
                height: 10,
              ),
              ProfileInfoEntry("Broj telefona", ProfileEntryType.Phone, phoneCtrl),
            ],
          ),
        ),
      ),
    );
  }

  Widget profilePicture() {
    return Container(
      width: 400,
      child: Column(
        children: [
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(checkUserImgUrl(user.imgUrl)),
              ),
            ),
          ),
          Container(
            width: 250,
            child: FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit,
                    color: Colors.lightGreen,
                    size: 18,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Menjanje slike profila",
                    style: changePicture,
                  ),
                ],
              ),
              onPressed: () async {
                pickImage();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget profileMainInfo() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 50),
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
            height: 30,
          ),
          Text(
            user.email,
            style: profileInfoStyle,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            Provider.of<UserService>(context, listen: false).isAdmin ? "Administrator sistema" : "Institucija",
            style: profileInfoBold,
          ),
          SizedBox(
            height: 30,
          ),
          FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)
            ),
            child: Text(
              "Sačuvajte izmene",
              style: saveChanges,
            ),
            color: Colors.lightGreen,
            onPressed: () {
              updateProfile(context);
            },
          ),
        ],
      ),
    );
  }
}
