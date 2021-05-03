import 'package:Frontend/commons/theme.dart';
import 'package:Frontend/config/config.dart';
import 'package:Frontend/models/enums.dart';
import 'package:Frontend/src/pages/welcomePage.dart';
import 'package:Frontend/widgets/alert.dart';
import 'package:Frontend/widgets/entryField.dart';
import 'package:Frontend/widgets/progressIndicator.dart';
import 'package:Frontend/widgets/submitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import '../../models/user.dart';
import '../../services/userServices.dart';
import 'loginPage.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage({Key key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  String _selectedCity = null;
  Color _color = Colors.black;
  List<String> cities = ["Beograd", "Kragujevac", "Niš", "Novi Sad", "Subotica", "Čačak"];
  List<DropdownMenuItem<String>> _items = List<DropdownMenuItem<String>>();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();


  @override
  initState(){
    super.initState();
        for(var city in cities)
      _items.add(DropdownMenuItem<String>(
          value: city,
          child: Container(
            child: Text(city),
            ),
        )
      );
  }

  Widget _entryData() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          ListTile(
         /* title: ListTile(
            title: Text(
              "Institucija",
              style: infoFieldBold,
            ),
          ),*/
          subtitle: SearchableDropdown.single(
            style: infoField,
            items: _items,
            value: _selectedCity,
            onChanged: (value) {
              setState(() {
                _selectedCity = value;
              });
            },
            hint: "Izaberite",
            isExpanded: true,
            dialogBox: false,
            menuConstraints: BoxConstraints.tight(Size.fromHeight(300)),
            iconSize: 30,
            iconEnabledColor: Colors.lightGreen,
            closeButton: "Zatvori",
          ),
        ),
          EntryField("Korisničko ime",
              type: EntryType.text, controller: _usernameController),
          EntryField("E-adresa",
              type: EntryType.email, controller: _emailController),
          EntryField("Lozinka",
              type: EntryType.password, controller: _passwordController),
        ],
      ),
    );
  }

  Widget _title() {
    return Container(
      constraints: BoxConstraints.expand(height: 200.0),
      child: Image.asset('assets/icon/LogoAplikacija.png'),
    );
  }

  Widget _loginAccountLabel(context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Već imate nalog?',
            style: loginInfo,
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage()),
                (route) => false);
            },
            child: Text(
              'Prijavite se.',
              style: loginInfoBolder,
            ),
          )
        ],
      ),
    );
  }

  Widget _backButton(context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.lightGreen),
            ),
            Text('Nazad', style: nazad)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void onTap() async {
      if(_selectedCity != null){
        if (_isLoading == false) {
            if (_formKey.currentState.validate()) {
              setState(() {
                _isLoading = true;
              });
              User user = User(_usernameController.text, "_", _emailController.text, _passwordController.text, defaultUserImage, "", _selectedCity, "_", "");
              Response result = await Provider.of<UserService>(context, listen: false).attemptSignUp(user);

              setState(() {
                _isLoading = false;
              });

              alert(context, result.body.replaceAll("\"", "").trim(), result.statusCode).show()
              .then((value) => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => WelcomePage()),
                (route) => false)
              );
            }
        }
      }
      else alert(context, "Izaberite grad u kome boravite.", 0).show();
    }

    return Scaffold(
      backgroundColor: Colors.white,
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
                    _title(),
                    Container(
                      height: 350,
                      child: ListView(
                        children: <Widget>[
                          _entryData(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SubmitButton('Registrujte se', onTap),
                    Expanded(
                      flex: 2,
                      child: SizedBox(),
                    )
                  ],
                ),
              ),
              // Positioned(top: 40, left: 0, child: _backButton(context)),
              Align(
                alignment: Alignment.bottomCenter,
                child: _loginAccountLabel(context),
              ),
              _isLoading == true ? MyProgressIndicator() : Text(""),
            ],
          ),
        ),
      ),
    );
  }
}
