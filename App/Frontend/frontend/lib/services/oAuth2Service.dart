import 'package:Frontend/commons/theme.dart';
import 'package:Frontend/models/enums.dart';
import 'package:Frontend/models/user.dart';
import 'package:Frontend/services/userServices.dart';
import 'package:Frontend/widgets/entryField.dart';
import 'package:Frontend/widgets/submitButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class AuthService extends UserService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  final _key = GlobalKey<FormState>();


  Future<User> googleSignIn(context) async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    var usernameFromMail = googleUser.email.split("@")[0];
    var user = await getUser(usernameFromMail);
    
    if (user != null) 
      return user;

    user = User(usernameFromMail, googleUser.displayName, googleUser.email,
          "", googleUser.photoUrl, "", "", "", "");
    user = await _showPasswordAndCityEntry(context, user);

    Response result = await Provider.of<UserService>(context, listen: false)
          .attemptSignUp(user);
    if(result.statusCode == 200)
      return user;
    return null;   
  }

  void updateUserData(FirebaseUser user) async {}

  Future<User> _showPasswordAndCityEntry(context, User user) async {
    return showModalBottomSheet<User>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        builder: (BuildContext context) {
          void _onTap() {
            if (_key.currentState.validate()) {
              user.password = _passwordController.text;
              user.city = _cityController.text;
              Navigator.of(context).pop(user);
            }
          }

          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _key,
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          "Unesite podatke",
                          style: additionalData,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      EntryField("Loznika",
                          type: EntryType.password, controller: _passwordController),
                      EntryField("Grad",
                          type: EntryType.text, controller: _cityController),
                      SizedBox(
                        height: 20,
                      ),
                      SubmitButton("Registruj se", _onTap),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

final AuthService authService = AuthService();
