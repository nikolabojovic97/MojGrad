import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/bandServices.dart';
import 'package:crypto/crypto.dart';

import 'homePage.dart';
import 'models/band.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final bandNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.teal, Colors.cyan, Colors.indigo]),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 60.0,
                  ),
                  Text(
                    "registration".toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  emailFieldWidget(),
                  SizedBox(
                    height: 20.0,
                  ),
                  passwordFieldWidget(),
                  SizedBox(
                    height: 20.0,
                  ),
                  bandNameFieldWidget(),
                  SizedBox(
                    height: 30.0,
                  ),
                  registerButtonWidget(),
                  SizedBox(
                    height: 10.0,
                  ),
                  backToLoginWidget(),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget emailFieldWidget() {
    return TextField(
      controller: emailController,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16.0),
          prefixIcon: Container(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            margin: const EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                  bottomRight: Radius.circular(10.0)),
            ),
            child: Icon(
              Icons.person,
              color: Colors.cyan,
            ),
          ),
          hintText: "enter your email",
          hintStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1)),
    );
  }

  Widget passwordFieldWidget() {
    return TextField(
      controller: passwordController,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16.0),
        prefixIcon: Container(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          margin: const EdgeInsets.only(right: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomRight: Radius.circular(10.0)),
          ),
          child: Icon(
            Icons.lock,
            color: Colors.cyan,
          ),
        ),
        hintText: "enter your password",
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
      ),
      obscureText: true,
    );
  }

  Widget bandNameFieldWidget() {
    return TextField(
      controller: bandNameController,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16.0),
        prefixIcon: Container(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          margin: const EdgeInsets.only(right: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomRight: Radius.circular(10.0)),
          ),
          child: Icon(
            Icons.queue_music,
            color: Colors.cyan,
          ),
        ),
        hintText: "enter your band name",
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
      ),
    );
  }

  Widget registerButtonWidget() {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        color: Colors.white,
        textColor: Colors.cyan,
        padding: const EdgeInsets.all(20.0),
        child: Text("register".toUpperCase()),
        onPressed: () async {
          if(emailController.text.trim() == "" || passwordController.text.trim() == "" || bandNameController.text.trim() == "") {
            alertBox("Empty fields!");
          }
          else {
            var kod = utf8.encode(passwordController.text.trim());
            var kriptovano = sha1.convert(kod);

            bool checkReg = await BandServices.checkRegistration(emailController.text);

            // ako ne postoji korisnik sa unetim email-om
            if (checkReg) {
              Band addition = new Band(emailController.text.trim(), kriptovano.toString(), bandNameController.text.trim());
              bool test = await BandServices.addBand(addition);
              if(test == false){
                print("Nije dobro odradjen addBand");
              }

              Band sendAddition = await BandServices.getBand(addition.email, kriptovano.toString());

              print(sendAddition.id);
              print(sendAddition.email);
              print(sendAddition.name);
              print(sendAddition.password);
              navigateToHomePage(sendAddition);
            } 
            else {
              alertBox("User with that email already exists!");
            }
          }
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );
  }

  Widget backToLoginWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          textColor: Colors.white,
          child: Text("back to login page".toUpperCase()),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  void navigateToHomePage(Band band) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage(band)));
  }

  Future<void> alertBox(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          backgroundColor: Colors.black,
          title: Text(
            'Warning',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Try again.',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Okay',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
