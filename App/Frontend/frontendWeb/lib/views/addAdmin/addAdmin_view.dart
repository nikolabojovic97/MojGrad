import 'package:flutter/material.dart';
import 'package:frontendWeb/responsive/screen_type_layout.dart';

import 'addAdmin_view_universal.dart';

class AddAdminView extends StatelessWidget {
  const AddAdminView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: AddAdminViewUniversal(),
      tablet: AddAdminViewUniversal(),
      desktop: AddAdminViewUniversal(),
    );
  }
}