import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontendWeb/config/config.dart';
import 'package:frontendWeb/enums/entry.dart';
import 'package:frontendWeb/models/user.dart';
import 'package:frontendWeb/services/userServices.dart';
import 'package:frontendWeb/utils/app_routes.dart';
import 'package:frontendWeb/widgets/alert.dart';
import 'package:frontendWeb/widgets/registerEntry.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../commons/theme.dart';
import 'login.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage({Key key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController cityCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  String selectedCity;

  final String successTitle = "Uspešno kreiran nalog";
  final String successContent = "Nalog je kreiran i biće neaktivan sve dok administrator sistema ne izvrši verifikaciju.";

  final String failureTitle = "Greška pri kreiranju naloga";
  final String failureContent = "Došlo je do greške. Pokušajte ponovo.";

  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      desktop: _desktopRegistration(context),
      tablet: _tabletRegistration(context),
      mobile: _mobileRegistration(context),
    );
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

  Widget _entryData() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedCity,
              style: loginInput,
              hint: Text("Izaberite grad", style: loginCity),
              onChanged: (String value) {
                setState(() {
                  selectedCity = value;
                });
              },
              items: <String>["Kragujevac", "Beograd", "Novi Sad", "Niš", "Subotica", "Čačak"]
                .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: loginInput),
                  );
                })
                .toList(),
              ),
          ),
          SizedBox(
            height: 10,
          ),
          RegisterEntry("Korisničko ime", EntryType.Username, usernameCtrl),
          SizedBox(
            height: 10,
          ),
          RegisterEntry("Naziv institucije", EntryType.Name, nameCtrl),
          SizedBox(
            height: 10,
          ),
          RegisterEntry("Mejl adresa", EntryType.Email, emailCtrl),
          SizedBox(
            height: 10,
          ),
          RegisterEntry("Lozinka", EntryType.Password, passwordCtrl),
        ],
      ),
    );
  }

  Widget _title() {
    return Container(
      constraints: BoxConstraints.expand(
        height: 270.0,
      ),
      child: Image.asset(
        'assets/icon/LogoAplikacija.png',
        height: 200,
      ),
    );
  }

  Widget loginAccountLabel(context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Već imate nalog?', style: loginInfo),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
            child: Text('Prijavite se.', style: loginInfo),
          )
        ],
      ),
    );
  }

  Widget _register(context) {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(500)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.green.shade700,
              offset: Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2)
            ],
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.lightGreen, Colors.green[300]]
            )
          ),
        child: Text("Registrujte se", style: loginStyle),
      ),
      onTap: () async {
        if (_formKey.currentState.validate() && selectedCity != null) {
          var username = usernameCtrl.text.trim();
          var name = nameCtrl.text;
          var email = emailCtrl.text;
          var password = passwordCtrl.text.trim();

          User user = User(username, name, email, password, defaultInstitutionImage, "_", selectedCity, "_", "_", 2);

          bool result = await Provider.of<UserService>(context, listen: false).attemptSignUp(user);

          if (result == true) {
            showDialog(context: context, child: alert(successTitle, successContent)).whenComplete(() => Navigator.of(context).pop());
          }
          else {
            showDialog(context: context, child: alert(failureTitle, failureContent));
          }
        }
        else if (selectedCity == null) {
          showDialog(context: context, child: alert("Nepopunjeno polje", "Kako biste kreirali nalog, potrebno je da izaberete jedan od ponuđenih gradova."));
        }
      },
    );
  }

  Widget _mobileRegistration(context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    _entryData(),
                    SizedBox(
                      height: 10,
                    ),
                    _register(context),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        )
      )
    );
  }

  Widget _tabletRegistration(context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                width: 600,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    _title(),
                    _entryData(),
                    SizedBox(
                      height: 10,
                    ),
                    _register(context),
                    SizedBox(height: 30),
                  ],
                ),
              )
            ],
          ),
        )
      )
    );
  }

  Widget _desktopRegistration(context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                width: 600,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    _title(),
                    _entryData(),
                    SizedBox(
                      height: 20,
                    ),
                    _register(context),
                    SizedBox(height: 30),
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
