import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/utils/app_routes.dart';
import 'package:frontendWeb/widgets/alert.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../services/userServices.dart';

class Login extends StatefulWidget {
  Login({Key key, this.title}) : super(key: key);

  final String title;

  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      desktop: _desktopLogin(),
      tablet: _tabletLogin(),
      mobile: _mobileLogin(),
    );
  }

  void passwordRecovery(context) async {
    if (_usernameController.text.isNotEmpty) {
      var response =await UserService.getPasswordRecovery(_usernameController.text);
      showDialog(context: context, child: alert("Oporavak lozinke", response));
    } 
    else
      showDialog(context: context, child: alert("Napomena", "Unesite Vaše korisničko ime."));
  }

  Widget _backButton(context) {
    return Container(
      width: 150,
      child: FlatButton(
        child: Row(
          children: [
            Icon(
              Icons.arrow_back_ios,
              color: Colors.lightGreen,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Nazad",
              style: backStyle,
            ),
          ],
        ),
        onPressed: () {
          Navigator.popAndPushNamed(context, AppRoutes.welcome);
        },
      ),
    );
  }

  Widget _entryField(String title, TextEditingController controller, {bool isPassword = false}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (val) {
              if (val.length == 0) 
                return "Popunite polje.";
              return null;
            },
            style: loginInput,
            controller: controller,
            obscureText: isPassword,
            decoration: new InputDecoration(
              errorStyle: fillFieldMsg,
              labelText: title,
              fillColor: Colors.lightGreen,
              border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(500),
                borderSide: new BorderSide(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          bool result = await Provider.of<UserService>(context, listen: false)
              .attemptLogin(_usernameController.text, _passwordController.text);

          if (result == true) {
            if (Provider.of<UserService>(context, listen: false).isAdmin)
              Navigator.popAndPushNamed(context, AppRoutes.dashboard);
          else if (Provider.of<UserService>(context, listen: false).isVerifiedInstitution)
            Navigator.popAndPushNamed(context, AppRoutes.home);
          }
          else {
            _showDialog();
          }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(500)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.green.shade700,
              offset: Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.lightGreen, Colors.green[300]]
          ),
        ),
        child: Text(
          'Prijava',
          style: loginStyle,
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Pokušajte ponovo",
            style: alertLoginTitle,
          ),
          content: Text(
            "Uneta je pogrešna kombinacija korisničkog imena i lozinke.",
            style: alertLogin,
          ),
          shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              child: Text(
                "OK",
                style: alertLoginOk,
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

  Widget _emailPasswordWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _entryField("Korisničko ime", _usernameController),
          _entryField("Lozinka", _passwordController, isPassword: true),
        ],
      ),
    );
  }

  Widget _title() {
    return Container(
      constraints: BoxConstraints.expand(
        height: 300.0,
      ),
      child: Image.asset(
        'assets/icon/LogoAplikacija.png',
        height: 200,
      ),
    );
  }

  Widget _mobileLogin() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              _backButton(context),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    _title(),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    GestureDetector(
                      onTap: () => passwordRecovery(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerRight,
                        child: Text('Zaboravili ste lozinku?',
                            style: loginInfo
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      )
    );
  }

  Widget _tabletLogin() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: 600,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    _title(),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                      width: 50,
                    ),
                    _submitButton(),
                    GestureDetector(
                      onTap: () => passwordRecovery(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerRight,
                        child: Text('Zaboravili ste lozinku?',
                            style: loginInfo
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget _desktopLogin() {
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
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                      width: 50,
                    ),
                    _submitButton(),
                    GestureDetector(
                      onTap: () => passwordRecovery(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerRight,
                        child: Text('Zaboravili ste lozinku?',
                            style: loginInfo
                        ),
                      ),
                    ),
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
