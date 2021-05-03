import 'package:flutter/material.dart';
import 'package:frontendWeb/responsive/screen_type_layout.dart';
import 'package:frontendWeb/views/users/users_view_universal.dart';

class UsersView extends StatelessWidget {
  const UsersView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      desktop: UsersUniversalView(),
      tablet: UsersUniversalView(),
      mobile: UsersUniversalView(),
    );
  }
}