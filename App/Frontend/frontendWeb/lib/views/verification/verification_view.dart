import 'package:flutter/material.dart';
import 'package:frontendWeb/responsive/screen_type_layout.dart';
import 'package:frontendWeb/views/verification/verification_universal.dart';

class VerificationView extends StatelessWidget {
  const VerificationView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      desktop: VerificationUniversal(),
      tablet: VerificationUniversal(),
      mobile: VerificationUniversal(),
    );
  }
}