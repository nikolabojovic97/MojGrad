import 'package:flutter/material.dart';
import 'package:frontendWeb/responsive/screen_type_layout.dart';
import 'institutions_view_universal.dart';

class InstitutionsView extends StatelessWidget {
  const InstitutionsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      desktop: InstitutionsUniversalView(),
      tablet: InstitutionsUniversalView(),
      mobile: InstitutionsUniversalView(),
    );
  }
}
