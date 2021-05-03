import 'package:flutter/material.dart';
import 'package:frontend/homePage.dart';
import 'package:frontend/models/bandMember.dart';
import 'package:frontend/models/bandMemberServices.dart';

import 'models/band.dart';

class AddMemberPage extends StatefulWidget {
  final Band band;
  AddMemberPage(this.band);

  @override
  State<StatefulWidget> createState() {
    return _AddMemberPageState(band);
  }
}

class _AddMemberPageState extends State<AddMemberPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  Band band;

  _AddMemberPageState(this.band);

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
                    height: 200.0,
                  ),
                  firstNameFieldWidget(),
                  SizedBox(
                    height: 20.0,
                  ),
                  lastNameFieldWidget(),
                  SizedBox(
                    height: 20.0,
                  ),
                  addMemberButtonWidget(),
                  SizedBox(
                    height: 20.0,
                  ),
                  backToHomeWidget(),
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

  Widget firstNameFieldWidget() {
    return TextField(
      controller: firstNameController,
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
              Icons.person_add,
              color: Colors.cyan,
            ),
          ),
          hintText: "enter your first name",
          hintStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1)),
    );
  }

  Widget lastNameFieldWidget() {
    return TextField(
      controller: lastNameController,
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
            Icons.person_add,
            color: Colors.cyan,
          ),
        ),
        hintText: "enter your last name",
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
      ),
    );
  }

  Widget addMemberButtonWidget() {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        color: Colors.white,
        textColor: Colors.cyan,
        padding: const EdgeInsets.all(20.0),
        child: Text("add new member".toUpperCase()),
        onPressed: () async {
          BandMember member = new BandMember(band.id, firstNameController.text.trim(), lastNameController.text.trim());
          await BandMemberServices.addBandMember(member);
          navigateToHomePage(band);
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );
  }

  Widget backToHomeWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          textColor: Colors.white,
          child: Text("back to home page".toUpperCase()),
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
}
