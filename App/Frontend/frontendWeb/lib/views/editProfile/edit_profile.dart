import 'package:flutter/material.dart';
import 'package:frontendWeb/responsive/screen_type_layout.dart';

import 'edit_profile_view.dart';

class EditProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      desktop: EditProfile(),
      tablet: EditProfile(),
      mobile: EditProfile(),
    );
  }
}