import 'package:flutter/material.dart';
import 'package:frontendWeb/responsive/screen_type_layout.dart';
import 'package:frontendWeb/views/dashboard/dashboard_view_universal.dart';

class DashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      desktop: DashboardViewUniversal(),
      tablet: DashboardViewUniversal(),
      mobile: DashboardViewUniversal(),
    );
  }
}