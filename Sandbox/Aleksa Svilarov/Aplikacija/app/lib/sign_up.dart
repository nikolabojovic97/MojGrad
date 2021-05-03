import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Aplikacija/models/user.dart';
import 'package:flutter/material.dart';

//import 'login_page.dart';
class SignupPage extends StatefulWidget {
  static String tag = 'signup-page';
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  TextEditingController imeController = TextEditingController();
  TextEditingController prezimeController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  
  Widget _buildFirstNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'First Name',
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: imeController,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.people,
                color: Colors.white,
              ),
              hintText: 'Enter your first name',
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildLastNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Last Name',
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: prezimeController,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.people,
                color: Colors.white,
              ),
              hintText: 'Enter your last name',
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Username',
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: usernameController,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.people,
                color: Colors.white,
              ),
              hintText: 'Enter your username',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          child: TextFormField(
            obscureText: true,
            controller: passwordController,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your password',
            ),
          ),
        ),
      ],
    );
  }
 
   Widget _buildSignUpBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          String myUrl = "http://192.168.8.100:45455/registracija";
          User u = User();

          u.ime = imeController.text;
          u.prezime = prezimeController.text;
          u.username = usernameController.text;
          u.password = passwordController.text;

          Map<String, dynamic> mapa = u.toMap();

          var bodyy = jsonEncode(mapa);
          print(bodyy);
          var body = jsonEncode({
            "ime" : imeController.text,
            "prezime" : prezimeController.text,
            "username" : usernameController.text,
            "password" : passwordController.text
          });
          Map<String, String> header = {
            "Accept": "application/json",
            "Content-type":"application/json"
          };
          http.post(myUrl, headers: header, body: body).then((response){
            if(response.statusCode == 200){
              Navigator.of(context).pushNamed('/signin');
            }else{
              //obavestenje da se lose registrovao
              Navigator.of(context).pushNamed('/signup');
            }
          });
          

          




         Navigator.of(context).pushNamed('/home');
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'SIGN UP',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFA7FFEB),
                  Color(0xFF64FFDA),
                  Color(0xFF1De9B6),
                  Color(0xFF00BFA5),
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              ),
            ),
          ),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 120.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Sign in',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  _buildFirstNameTF(),
                  SizedBox(height: 30.0),
                  _buildLastNameTF(),
                  SizedBox(height: 30.0),
                  _buildEmailTF(),
                  SizedBox(height: 30.0),
                  _buildPasswordTF(),
                  _buildSignUpBtn(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
