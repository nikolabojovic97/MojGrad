import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/enums/entry.dart';
import 'package:frontendWeb/utils/regexp.dart';

class RegisterEntry extends StatelessWidget {
  final String text;
  final EntryType type;
  final TextEditingController controller;

  const RegisterEntry(this.text, this.type, this.controller);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: type == EntryType.Password ? true : false,
      cursorColor: Colors.lightGreen,
      decoration: InputDecoration(
        errorStyle: fillFieldMsg,
        labelText: text,
        fillColor: Colors.lightGreen,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(500),
          borderSide: BorderSide(
            color: drawerBgColor,
          ),
        ),
      ),
      validator: (val) {
        if (val.length == 0)
          return "Popunite polje";
        else if (type == EntryType.Username && (val.length < 6 || val.length > 20))
          return "Korisničko ime mora da sadrži 6 - 20 karaktera.";
        else if (type == EntryType.Username && !usernameReg.hasMatch(val))
          return "Korisničko ime sme da sadrži isključivo slova, brojeve i donju crtu.";
        else if (type == EntryType.Name && (val.length < 3 || val.length > 40))
          return "Naziv institucije mora da sadrži 3 - 40 karaktera.";
        else if (type == EntryType.Name && !nameReg.hasMatch(val))
          return "Naziv institucije sme da sadrži samo slova.";
        else if (type == EntryType.Email && !emailReg.hasMatch(val))
          return "Mejl adresa nije validna.";
        else if (type == EntryType.Password && (val.length < 8 || val.length > 32))
          return "Lozinka mora da sadrži 8 - 32 karaktera.";
        else if (type == EntryType.Password && !isPasswordCompliant(val))
          return "Lozinka mora da sadrži: cifru, malo slovo i veliko slovo.";

        return null;
      },
      style: loginInput,
    );
  }
}