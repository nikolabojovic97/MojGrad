import 'package:flutter/material.dart';
import 'package:frontendWeb/responsive/screen_type_layout.dart';
import 'postReports_view_universal.dart';

class PostReportsView extends StatelessWidget {
  const PostReportsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      desktop: PostReportsUniversalView(),
      tablet: PostReportsUniversalView(),
      mobile: PostReportsUniversalView(),
    );
  }
}