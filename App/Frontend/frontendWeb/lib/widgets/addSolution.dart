import 'dart:convert';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/enums/confirm.dart';
import 'package:frontendWeb/models/uploadPostImage.dart';
import 'package:universal_html/html.dart' as html;
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as Path;

import 'package:flutter/material.dart';
import 'package:frontendWeb/models/post.dart';
import 'package:frontendWeb/models/postSolution.dart';
import 'package:frontendWeb/models/user.dart';
import 'package:frontendWeb/services/postServices.dart';
import 'package:frontendWeb/widgets/alert.dart';
import 'package:image_picker_web/image_picker_web.dart';

class AddSolution extends StatefulWidget {
  final User user;
  final Post problem;

  AddSolution({Key key, @required this.problem, @required this.user}) : super(key: key);

  @override
  _AddSolutionState createState() => _AddSolutionState(problem, user);
}

class _AddSolutionState extends State<AddSolution> {
  User user;
  Post problem;

  // controller for post solution description
  TextEditingController solutionDescriptionCtrl = TextEditingController();

  // loaded image 
  Image pickedImage; 
  String imageData;

  // solution
  Post solution;

  _AddSolutionState(this.problem, this.user);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> createPost() async {
    if (problem == null) 
      return false;

    if (pickedImage == null) 
      return false;

    solution = Post(user.username, solutionDescriptionCtrl.text, user.city, problem.latLng, problem.address);
    Post added = await PostServices.addPost(solution, user.token);

    if (added != null) {
      PostSolution postSolution = PostSolution(problem.id, added.id);
      PostServices.addSolutionOnProblem(postSolution, user.token);

      String base64Image = "" + imageData;
      String name = DateTime.now().millisecondsSinceEpoch.toString() + user.username + ".jpg";

      List<String> images = [];
      images.add(base64Image);

      UploadPostImage postImage = UploadPostImage(added.id, name, images);
      var isAdded = await PostServices.addPostImage(postImage, user.token);

      if (isAdded == true) 
        return true;
    }

    return false;
  }

  Future pickImage() async {
    var mediaData = await ImagePickerWeb.getImageInfo;

    String mimeType = mime(Path.basename(mediaData.fileName));
    html.File mediaFile = html.File(mediaData.data, mediaData.fileName, {'type': mimeType});

    if (mediaFile != null) {
      setState(() {
        pickedImage = Image.memory(mediaData.data);
        imageData = base64Encode(mediaData.data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: popupProblemTitle,
      title: Container(
        decoration: BoxDecoration(
          color: Colors.lightGreen,
        ),
        padding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
        child: Text(
          "Dodavanje rešenja",
        ),
      ),
      content: Container(
        width: 600,
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            description(),
            SizedBox(
              height: 5,
            ),
            image(),
          ],
        ),
      ),
      actions: [
        FlatButton(
          child: Text(
            "Dodajte rešenje",
            style: addSolutionBtn,
          ),
          onPressed: () async {
            if (solutionDescriptionCtrl.text == "" || pickedImage == null) {
              showDialog(context: context, child: alert("Nevalidni podaci", "Kako biste uspešno dodali rešenje, neophodno je uneti opis i učitati fotografiju."));
            }
            else if (solutionDescriptionCtrl.text.length > 500) {
              showDialog(context: context, child: alert("Nevalidni podaci", "Opis ne sme biti duži od 500 karaktera."));
            }
            else {
              bool res = await createPost();

              if (res) 
                showDialog(context: context, child: alert("Dodavanje rešenja", "Rešenje uspešno dodato.")).then((value) => Navigator.of(context).pop(ConfirmAction.ACCEPT));
              else
                showDialog(context: context, child: alert("Dodavanje rešenja", "Došlo je do greške prilikom dodavanja rešenja. Pokušajte ponovo."));
            }   
          },
        ),
      ],
    );
  } 

  Widget description() {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        style: descriptionStyle,
        controller: solutionDescriptionCtrl,
        decoration: InputDecoration.collapsed(
          hintText: "Unesite opis...",
          hintStyle: descriptionHint,
        ),
        autofocus: false,
        maxLines: null,
      ),
    );
  }

  Widget image() {
    return GestureDetector(
      onTap: () async {
        await pickImage();
      },
      child: Container(
        height: 250,
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: pickedImage == null ? 
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.image,
                color: Colors.lightGreen,
                size: 40,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Za izbor fotografije kliknite ovde",
                style: imagePicker,
              ),
            ],
          )
        )
        : 
        Center(
          child: pickedImage
        ),
      ),
    );
  }
}