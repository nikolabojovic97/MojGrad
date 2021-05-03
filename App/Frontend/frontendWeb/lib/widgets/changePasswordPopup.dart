import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/enums/entry.dart';
import 'package:frontendWeb/widgets/alert.dart';
import 'package:frontendWeb/widgets/registerEntry.dart';

class ChangePasswordPopup extends StatelessWidget {
  final String username;

  ChangePasswordPopup(this.username); 

  final _formKey = GlobalKey<FormState>();

  final TextEditingController oldPasswordCtrl = TextEditingController();
  final TextEditingController newPasswordCtrl = TextEditingController();
  final TextEditingController newPasswordRepeatedCtrl = TextEditingController();

  final String successTitle = "Status izmene";
  final String successContent = "Vaša lozinka je uspešno izmenjena. Sledi ponovna prijava korišćenjem nove lozinke.";

  final String failureTitle = "Status izmene";
  final String failureContent = "Došlo je do greške prilikom izmene lozinke. Pokušajte ponovo.";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(left: 25, right: 25, top: 30),
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: EdgeInsets.zero,
      title: Container(
        decoration: BoxDecoration(
          color: Colors.lightGreen,
        ),
        padding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
        child: Text(
          "Izmena lozinke",
          style: popupProblemTitle,
        ),
      ),
      content: Container(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              RegisterEntry("Trenutna lozinka", EntryType.Password, oldPasswordCtrl),
              SizedBox(
                height: 10,
              ),
              RegisterEntry("Nova lozinka", EntryType.Password, newPasswordCtrl),
              SizedBox(
                height: 10,
              ),
              RegisterEntry("Ponovljena nova lozinka", EntryType.Password, newPasswordRepeatedCtrl),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
      actions: [
        FlatButton(
          child: Text(
            "Sačuvajte izmene",
            style: changePicture,
          ),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              if (newPasswordCtrl.text == newPasswordRepeatedCtrl.text) {
                // update password
              }
              else {
                showDialog(
                  context: context, 
                  child: alert(
                    "Nepodudaranje lozinki", 
                    "Kako biste uspešno izvršili izmenu, potrebno je da dva puta unesete istu novu lozinku."
                  )
                );
              }
            }
          },
        ),
      ],
    );
  }
}