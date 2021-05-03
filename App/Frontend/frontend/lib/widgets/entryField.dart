import 'package:Frontend/commons/theme.dart';
import 'package:Frontend/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:Frontend/utils/regexp.dart';

class EntryField extends StatelessWidget {
  final String _text;
  EntryType _type;
  TextEditingController _controller;
  EntryField(this._text, {EntryType type, TextEditingController controller}) {
    this._type = type;
    this._controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 1,
          ),
          TextFormField(
            style: loginInput,
            controller: _controller,
            obscureText: _type == EntryType.password,
            decoration: new InputDecoration(
              errorStyle: fillFieldMsg,
              labelText: _text,
              fillColor: Colors.lightGreen,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(500),
                borderSide: new BorderSide(),
              ),
            ),
            validator: (val) {
              if (val.length == 0) 
                return "Popunite polje.";
              else if (_type == EntryType.email && !emailReg.hasMatch(val))
                return "Mejl adresa nije validna.";
              else if (_type == EntryType.text && (val.length < 6 || val.length > 20))
                return "Korisničko ime mora da sadrži 6 - 20 karaktera.";
              else if (_type == EntryType.text && !usernameReg.hasMatch(val))
                return "Korisničko ime sme da sadrži isključivo slova, brojeve i donju crtu.";
              else if (_type == EntryType.password && (val.length < 8 || val.length > 32))
                return "Lozinka mora da sadrži 8 - 32 karaktera.";
              else if (_type == EntryType.password && !isPasswordCompliant(val))
                return "Lozinka mora da sadrži: cifru, malo slovo i veliko slovo.";

              return null;
            },
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }
}
