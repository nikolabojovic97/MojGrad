import 'dart:convert';

import 'package:flutter/material.dart';

import 'models/user.dart';

import 'package:http/http.dart' as http;

//import 'login_page.dart';
class SignInPage extends StatefulWidget {
  static String tag = 'signup-page';
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //bool _rememberMe = false;
  Widget _buildEmailTF() {
    //var controller;
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
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            controller: usernameController,
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

  Widget _buildForgotPasswordTF() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () {
         Navigator.of(context).pushNamed('/forgot');
        },
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
        ),
      ),
    );
  }

  /*Widget _buildRememberMeCheckboxTF(){
    return    Container(
                    child: Row(
                      children: <Widget>[
                        Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.white),
                          child: Checkbox(
                            value: _rememberMe,
                            checkColor: Colors.green,
                            activeColor: Colors.white,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value;
                              });
                            },
                          ),
                        ),
                        Text( 
                          'Remember me', 
                        ),
                      ],
                    ),
                  );
  }*/
   Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {

          String url = "http://192.168.8.100:45455/login";
          User u = User();
          u.username = usernameController.text;
          u.password = passwordController.text;
          Map<String, dynamic> mapa = u.toMap();

          var bodyy = jsonEncode(mapa);
          print(bodyy);
          var body = jsonEncode({
            "username" : usernameController.text,
            "password" : passwordController.text
          });
          Map<String, String> header = {
            "Accept": "application/json",
            "Content-type":"application/json"
          };
          http.post(url, headers: header, body: body).then((response){
            if(response.statusCode == 200){
              Navigator.of(context).pushNamed('/home');
            }else{
              Navigator.of(context).pushNamed('/forgot');
            }
          });
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOG IN',
          style: TextStyle(
            color: Color(0xFF00BFA5),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
   Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/signup');
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
                    'Log in',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  _buildEmailTF(),
                  SizedBox(height: 30.0),
                  _buildPasswordTF(),
                  _buildForgotPasswordTF(),
                  //_buildRememberMeCheckboxTF(),
                  _buildLoginBtn(),
                  _buildSignupBtn(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
