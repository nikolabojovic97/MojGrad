import 'package:flutter/material.dart';

class CloseIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(
        Icons.close,
      ),
      onTap: () => Navigator.of(context).pop(),
    );
  }
}