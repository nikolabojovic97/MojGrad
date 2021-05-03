import 'package:Frontend/commons/theme.dart';
import 'package:Frontend/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:Frontend/utils/regexp.dart';

class EntryAccountInfo extends StatelessWidget {
  final String _text;
  EntryAccountType _type;
  TextEditingController _controller;
  EntryAccountInfo(this._text, {EntryAccountType type, TextEditingController controller}) {
    this._type = type;
    this._controller = controller;
  }

  Icon _getIcon(EntryAccountType type){
    IconData icon;
    if(type == EntryAccountType.username)
      icon = null;

    if(type == EntryAccountType.name)
      icon = Icons.person;

    if(type == EntryAccountType.email)
      icon = Icons.alternate_email;

    if(type == EntryAccountType.city)
      icon = Icons.location_city;

    if(type == EntryAccountType.bio)
      icon = Icons.info_outline;
    
    if(type == EntryAccountType.phone)
      icon = Icons.phone;

    return Icon(icon, color: Colors.lightGreen,);
  }

  TextInputType _getKeyboardType(EntryAccountType type){
    if(type == EntryAccountType.phone)
      return TextInputType.phone;

    if(type == EntryAccountType.email)
      return TextInputType.emailAddress;

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        style: accountInfo,
        controller: _controller,
        enabled: !(_type == EntryAccountType.username || _type == EntryAccountType.email),
        cursorColor: Colors.lightGreen,
        keyboardType: _getKeyboardType(_type),
        decoration: InputDecoration(
          labelText: _text,
          labelStyle: accountInfo,
          icon: _getIcon(_type),
        ),
        validator: (val) {
              if (val.length == 0 && _type != EntryAccountType.name && _type != EntryAccountType.phone && _type != EntryAccountType.bio)
                return "Popunite polje";
              else if (_type == EntryAccountType.email && !emailReg.hasMatch(val))
                return "Mejl adresa nije validna.";
              else if (_type == EntryAccountType.name && val != "_" && ((val.length > 0 && val.length < 3) || val.length > 40))
                return "Ime korisnika mora da sadrži 3 - 40 karaktera.";
              else if (_type == EntryAccountType.name && val != "_" && !nameReg.hasMatch(val))
                return "Ime korisnika sme da sadrži samo slova.";
              else if (_type == EntryAccountType.bio && val.length > 150)
                return "Biografija ne sme da bude duža od 150 karaktera.";
              else if (_type == EntryAccountType.phone && val != "_" && val.length > 0 && (val.length < 9 || val.length > 10))
                return "Broj telefona mora da sadrži 9 - 10 cifara.";
              else if (_type == EntryAccountType.phone && val != "_" && val.length > 0 && !phoneNumberReg.hasMatch(val))
                return "Broj telefona sme da sadrži samo brojeve.";

              return null;
            },
          ),
    );
  }
}