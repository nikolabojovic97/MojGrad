import 'package:flutter/material.dart';
import 'package:frontendWeb/responsive/screen_type_layout.dart';

import 'institution_profile_view_universal.dart';

class InstitutionProfile extends StatelessWidget {
  const InstitutionProfile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      desktop: InstitutionProfileUniversal(),
      tablet: InstitutionProfileUniversal(),
      mobile: InstitutionProfileUniversal(),
    );
  }
}