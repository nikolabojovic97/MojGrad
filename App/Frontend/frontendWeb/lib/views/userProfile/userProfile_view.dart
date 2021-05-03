import 'package:flutter/cupertino.dart';
import 'package:frontendWeb/responsive/screen_type_layout.dart';
import 'package:frontendWeb/views/userProfile/userProfile_view_universal.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments;

    return ScreenTypeLayout(
      desktop: UserProfileUniversal(username: args),
      tablet: UserProfileUniversal(username: args),
      mobile: UserProfileUniversal(username: args),
    );
  }
}