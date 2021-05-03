import 'package:Frontend/commons/theme.dart';
import 'package:Frontend/models/enums.dart';
import 'package:Frontend/models/user.dart';
import 'package:Frontend/services/oAuth2Service.dart';
import 'package:Frontend/src/pages/prehome.dart';
import 'package:Frontend/widgets/progressIndicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../../commons/messages.dart';
import '../../services/userServices.dart';
import '../../widgets/alert.dart';
import '../../widgets/entryField.dart';
import '../../widgets/submitButton.dart';
import 'RegistrationPage.dart';

class LoginPage extends StatefulWidget {
  final String title;
  LoginPage({Key key, this.title}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  Widget _backButton(context) {
    return InkWell(
      onTap: () {
        if (!isLoading) Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.lightGreen),
            ),
            Text('Nazad', style: nazad),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('ili', style: loginInfoBig),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _facebookButton() {
    return Container(
      height: 50,
      width: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff1959a9),
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                'assets/facebook.png',
                color: Colors.white,
                height: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void googleSignIn(context) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      User user = await authService.googleSignIn(context);
      if (user != null)
        setState(() {
          _usernameController.text = user.username;
          _passwordController.text = user.password;
          isLoading = false;
        });
    } else
      alert(context, requestLoading, 0).show();
  }

  Widget _googleButton(context) {
    return GestureDetector(
      onTap: () async => googleSignIn(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/google.png',
              ),
              Container(
                child: Text(
                  "Google nalog",
                  style: googleButton,
                ),
                margin: EdgeInsets.only(right: 5.0),
              ),
            ],
          ),
          height: 50,
          margin: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(500.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0),
                blurRadius: 6.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void passwordRecovery(context) async {
    if (isLoading == false) {
      if (_usernameController.text.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        var response =
            await UserService.getPasswordRecovery(_usernameController.text);

        setState(() {
          isLoading = false;
        });
        alert(context, response, 0).show();
      } else
        alert(context, "Unesite Vaše korisničko ime.", 0).show();
    }
  }

  Widget _createAccountLabel(context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Nemate nalog?',
            style: loginInfoBig,
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()));
            },
            child: Text(
              'Registrujte se.',
              style: loginInfoBolder,
            ),
          )
        ],
      ),
    );
  }

  Widget _usernamePasswordWidget() {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            EntryField("Korisničko ime",
                type: EntryType.text, controller: _usernameController),
            EntryField("Lozinka",
                type: EntryType.password, controller: _passwordController),
          ],
        ));
  }

  Widget _title() {
    return Container(
      constraints: BoxConstraints.expand(
        height: 200.0,
      ),
      child: Image.asset('assets/icon/LogoAplikacija.png'),
    );
  }

  @override
  Widget build(BuildContext context) {
    void onTap() async {
      print("TU sam");
      //securing only one click at the time
      if (!isLoading) {
        //validates entry fields
        if (_formKey.currentState.validate()) {
          setState(() {
            isLoading = true;
          });
          Response result = await Provider.of<UserService>(context, listen: false)
              .attemptLogin(_usernameController.text, _passwordController.text);

          /*if(result is String)
            alert(context, result);*/

          setState(() {
            isLoading = false;
            print("tu sam 1");
          });

          print("Tu sam 2");
          //ckecks result if user logged in correctly
          if (result.statusCode == 200) {
            //Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()),
                                      (route) => false);
          }
          else{
            print("Context" + context.toString());
            alert(context, result.body.replaceAll("\"", "").trim(), 0).show();
          }
        }
      } else
        alert(context, requestLoading, 0).show();
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: SizedBox(),
                    ),
                    _title(),
                    SizedBox(
                        // height: 50,
                        ),
                    _usernamePasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    SubmitButton("Prijava", onTap),
                    GestureDetector(
                      onTap: () => passwordRecovery(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerRight,
                        child:
                            Text('Zaboravili ste lozinku?', style: loginInfo),
                      ),
                    ),
                    _divider(),
                    _googleButton(context),
                    Expanded(
                      flex: 2,
                      child: SizedBox(),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _createAccountLabel(context),
              ),
              //Positioned(top: 40, left: 0, child: _backButton(context)),
              isLoading == true
                  ? MyProgressIndicator()
                  : Text(""),
            ],
          ),
        ),
      ),
    );
  }
}
