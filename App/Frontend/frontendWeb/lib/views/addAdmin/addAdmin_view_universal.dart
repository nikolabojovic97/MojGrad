import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/config/config.dart';
import 'package:frontendWeb/enums/confirm.dart';
import 'package:frontendWeb/enums/entry.dart';
import 'package:frontendWeb/models/user.dart';
import 'package:frontendWeb/services/passwordGeneratorServices.dart';
import 'package:frontendWeb/services/userServices.dart';
import 'package:frontendWeb/widgets/alert.dart';
import 'package:frontendWeb/widgets/profileInfoEntry.dart';
import 'package:provider/provider.dart';

class AddAdminViewUniversal extends StatelessWidget {
  AddAdminViewUniversal({Key key}) : super(key: key);

  final String addAdminTitle = "Kreiranje naloga";
  final String addAdminContent = "Da li ste sigurni da želite da kreirate novi administratorski nalog?";

  final _formKey = GlobalKey<FormState>();

  // controllers for input fields
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController cityCtrl = TextEditingController();

  Future<void> addAdmin(context) async {
    String username = usernameCtrl.text.trim();
    String email = emailCtrl.text.trim();
    String name = nameCtrl.text;
    String city = cityCtrl.text;

    if (_formKey.currentState.validate()) {
      var answer = await asyncConfirmDialog(context, addAdminTitle, addAdminContent);

      if (answer == ConfirmAction.ACCEPT) {
        String password = generatePassword(true, true, true, false, 8);
        User user = User(username, name, email, password, defaultUserImage, "_", city, "_", "_", 1);

        var result = await Provider.of<UserService>(context, listen: false).addNewAdminProfile(user);

        if (result) {
          showDialog(context: context, child: alert("Kreiranje novog naloga", "Novi administratorski nalog uspešno kreiran."));
          usernameCtrl.text = "";
          emailCtrl.text = "";
          nameCtrl.text = "";
          cityCtrl.text = "";
        }
        else {
          showDialog(context: context, child: alert("Pokušajte ponovo", "Došlo je do greške prilikom kreiranja naloga."));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      children: [
        header(),
        SizedBox(
          height: 10,
        ),
        profileInfo(context),
      ],
    );
  }

  Widget header() {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0, bottom: 25.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.horizontal,
        spacing: 30,
        children: [
          Icon(
            Icons.person_add,
            size: 150,
            color: Colors.lightGreen,
          ),
          Container(
            width: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dodavanje administratorskog naloga",
                  style: appBarTitle,
                ),
                _divider(),
                Text(
                  "Novi administrator će biti obavešten o kreiranju naloga putem mejl adrese.",
                  style: content,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget profileInfo(context) {
    return Container(
      padding: EdgeInsets.only(top: 40, bottom: 40, left: 20, right: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Container(
        width: 200,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ProfileInfoEntry("Korisničko ime", ProfileEntryType.Username, usernameCtrl),
              SizedBox(
                height: 10,
              ),
              ProfileInfoEntry("Mejl adresa", ProfileEntryType.Email, emailCtrl),
              SizedBox(
                height: 10,
              ),
              ProfileInfoEntry("Ime i prezime", ProfileEntryType.Name, nameCtrl),
              SizedBox(
                height: 10,
              ),
              ProfileInfoEntry("Grad", ProfileEntryType.City, cityCtrl),
              SizedBox(
                height: 10,
              ),
              addAdminButton(context)
            ],
          ),
        ), 
      ),
    );
  }

  Widget addAdminButton(context) {
    return Container(
      width: 200,
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0)
        ),
        child: Text(
          "Kreirajte nalog",
          style: saveChanges,
        ),
        color: Colors.lightGreen,
        onPressed: () async {
          await addAdmin(context);
        },
      )
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        color: drawerBgColor,
        thickness: 0.4,
      ),
    );
  }

  Future<ConfirmAction> asyncConfirmDialog(BuildContext context, String title, String content) async {
    return showDialog<ConfirmAction> (
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titleTextStyle: alertTitle,
          contentTextStyle: alertContent,
          title: Text(
            title,
          ),
          content: Text(
            content,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          actions: [
            FlatButton(
              child: Text(
                "Da",
                style: alertOption,
              ),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            ),
            FlatButton(
              child: Text(
                "Ne",
                style: alertOption,
              ),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
          ],
        );
      }
    );
  }
}