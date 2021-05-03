import 'package:flutter/material.dart';
import 'package:frontendWeb/responsive/screen_type_layout.dart';
import 'package:frontendWeb/views/recommended/recommended_view_universal.dart';

class RecommendedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: RecommendedUniversal(),
      tablet: RecommendedUniversal(),
      desktop: RecommendedUniversal(),
    );
  }
}
