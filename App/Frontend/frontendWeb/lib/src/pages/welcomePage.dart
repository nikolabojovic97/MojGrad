import 'package:flutter/material.dart';
import 'package:frontendWeb/utils/app_routes.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:universal_html/html.dart';
import '../../commons/theme.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      desktop: _desktopWelcome(),
      tablet: _tabletWelcome(),
      mobile: _mobileWelcome(),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.login);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(500)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Color(0xFF4CAF50).withAlpha(100),
                offset: Offset(2, 4),
                blurRadius: 8,
                spreadRadius: 2)
          ],
          color: Colors.lightGreen
        ),
        child: Text(
          'Prijava',
          style: loginStyle,
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.registration);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(500)),
          border: Border.all(color: Colors.lightGreen, width: 2),
        ),
        child: Text(
          'Registracija institucija',
          style: registrationStyle,
        ),
      ),
    );
  }

  Widget _title(){
    return Container(
      constraints: BoxConstraints.expand(
        height: 400.0,
      ),
      child: Image.asset('assets/icon/LogoAplikacija.png'),
    );
  }

  Widget _mobileWelcome() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    _title(),
                    SizedBox(
                      height: 80,
                    ),
                    _submitButton(),
                    SizedBox(
                      height: 20,
                    ),
                    _signUpButton(),
                  ],
                ),
              ),
            ],
          ),
        )
      )
    );
  }

  Widget _tabletWelcome() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                width: 600,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    _title(),
                    SizedBox(
                      height: 80,
                    ),
                    _submitButton(),
                    SizedBox(
                      height: 20,
                    ),
                    _signUpButton(),
                  ],
                ),
              ),
            ],
          ),
        )
      )
    );
  }

  Widget _desktopWelcome() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                width: 600,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    _title(),
                    SizedBox(
                      height: 80,
                    ),
                    _submitButton(),
                    SizedBox(
                      height: 20,
                    ),
                    _signUpButton(),
                  ],
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}
