import 'package:Frontend/models/user.dart';
import 'package:Frontend/pages/loginPage.dart';
import 'package:Frontend/pages/productPage.dart';
import 'package:Frontend/providers/auth.dart';
import 'package:Frontend/widgets/textHeader.dart';
import 'package:Frontend/widgets/userOld.dart';
import 'package:Frontend/widgets/verticalText.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

TextEditingController firstnameController = new TextEditingController();
TextEditingController usernameController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();

class NewUserPage extends StatefulWidget {
  @override
  _NewUserPageState createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {
  final _formKey = GlobalKey<FormState>();

  void showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text("OK")),
              ],
            ));
  }

  Future<void> tryRegister(User user) async {
    var result = await Provider.of<Auth>(context, listen: false).register(user);
    if (result != null) 
      showErrorDialog(result);
    else  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.lightBlueAccent, Colors.blueGrey],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight),
          ),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      VerticalText("Sign up"),
                      TextHeader("Welcome to FS"),
                    ],
                  ),
                  Padding(
                    //input fistname
                    padding:
                        const EdgeInsets.only(top: 50, left: 50, right: 50),
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        controller: firstnameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            showErrorDialog("Enter firstname!");
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.lightBlueAccent,
                            labelText: 'FirstName',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    //input username
                    padding:
                        const EdgeInsets.only(top: 20, left: 50, right: 50),
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        controller: usernameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            showErrorDialog("Enter username!");
                            return "*";
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.lightBlueAccent,
                            labelText: 'Username',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    //input password
                    padding:
                        const EdgeInsets.only(top: 20, left: 50, right: 50),
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        controller: passwordController,
                        validator: (value) {
                          if (value.isEmpty || value.length < 6) {
                            showErrorDialog("Password is to short!");
                            return "*";
                          }
                          return null;
                        },
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        obscureText: true,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Password",
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    //button
                    padding:
                        const EdgeInsets.only(top: 40, right: 50, left: 200),
                    child: Container(
                      alignment: Alignment.bottomRight,
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue[300],
                            blurRadius: 10.0,
                            spreadRadius: 1.0,
                            offset: Offset(5.0, 5.0),
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: FlatButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            User user = User(
                                "",
                                firstnameController.text,
                                "",
                                usernameController.text,
                                passwordController.text,
                                "");
                            tryRegister(user);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "OK",
                              style: TextStyle(
                                color: Colors.lightBlueAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.lightBlueAccent,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  UserOld(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
