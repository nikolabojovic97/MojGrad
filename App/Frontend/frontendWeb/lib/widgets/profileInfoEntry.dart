import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/enums/entry.dart';
import 'package:frontendWeb/utils/regexp.dart';

class ProfileInfoEntry extends StatelessWidget {
  final String text;
  final ProfileEntryType type;
  final TextEditingController controller;

  ProfileInfoEntry(this.text, this.type, this.controller);

  Icon getIcon(ProfileEntryType type) {
    IconData icon;

    if (type == ProfileEntryType.Username)
      icon = Icons.person;

    if (type == ProfileEntryType.Name)
      icon = Icons.supervised_user_circle;

    if (type == ProfileEntryType.City)
      icon = Icons.location_city;

    if (type == ProfileEntryType.Bio)
      icon = Icons.info_outline;

    if (type == ProfileEntryType.Phone)
      icon = Icons.phone;

    if (type == ProfileEntryType.Password)
      icon = Icons.lock;

    if (type == ProfileEntryType.Email)
      icon = Icons.email;

    return Icon(
      icon,
      color: Colors.lightGreen,
      size: 18,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: TextFormField(
        controller: controller,
        obscureText: type == ProfileEntryType.Password ? true : false,
        cursorColor: Colors.lightGreen,
        decoration: InputDecoration(
          errorStyle: fillFieldMsg,
          labelText: text,
          icon: getIcon(type),
          fillColor: Colors.lightGreen,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(500),
            borderSide: BorderSide(
              color: drawerBgColor,
            ),
          ),
        ),
        validator: (val) {
          if (val.length == 0 && type != ProfileEntryType.Bio && type != ProfileEntryType.Phone)
            return "Popunite polje";
          else if (type == ProfileEntryType.Username && (val.length < 6 || val.length > 20))
            return "Korisničko ime mora da sadrži 6 - 20 karaktera.";
          else if (type == ProfileEntryType.Username && !usernameReg.hasMatch(val))
            return "Korisničko ime sme da sadrži isključivo slova, brojeve i donju crtu.";
          else if (type == ProfileEntryType.Name && (val.length < 3 || val.length > 40))
            return "Ime mora da sadrži 3 - 40 karaktera.";
          else if (type == ProfileEntryType.Name && !nameReg.hasMatch(val))
            return "Ime sme da sadrži samo slova.";
          else if (type == ProfileEntryType.Email && !emailReg.hasMatch(val))
            return "Mejl adresa nije validna.";
          else if (type == ProfileEntryType.Bio && val.length > 150)
            return "Biografija ne sme da bude duža od 150 karaktera.";
          else if (type == ProfileEntryType.City && val != "Kragujevac" && val != "Novi Sad" && val != "Beograd" && val != "Niš" && val != "Nis" && val != "Subotica" && val != "Cacak" && val != "Čačak")
            return "Dostupni gradovi: Kragujevac, Novi Sad, Niš, Beograd, Subotica i Čačak";
          else if (type == ProfileEntryType.Phone && val.length > 0 && val != "_" && (val.length < 9 || val.length > 10))
            return "Broj telefona mora da sadrži 9 - 10 cifara.";
          else if (type == ProfileEntryType.Phone && val.length > 0 && val != "_" && !phoneNumberReg.hasMatch(val))
            return "Broj telefona sme da sadrži samo brojeve.";

          return null;
        },
        style: sideBarItem,
      ),
    );
  }
}