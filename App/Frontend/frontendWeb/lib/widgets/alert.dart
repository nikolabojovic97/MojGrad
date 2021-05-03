import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';

AlertDialog alert(String title, String content) {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    titleTextStyle: alertTitle,
    contentTextStyle: alertContent,
    title: Text(
      title,
    ),
    content: Text(
      content,
    ),
  );
}
