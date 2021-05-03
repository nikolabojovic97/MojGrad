import 'package:Frontend/commons/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';

Alert alert(BuildContext context, String desc, int statusCode) {
  String title = "Obaveštenje";
  return Alert(
    context: context,
    type: AlertType.none,
    title: title,
    desc: desc,
    style: AlertStyle(titleStyle: alertTitleError, descStyle: alertContent, isCloseButton: false),
    buttons: [],
  );
}

