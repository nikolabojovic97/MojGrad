import 'package:flutter/material.dart';
import 'package:frontendWeb/responsive/screen_type_layout.dart';

import 'commentReports_view_universal.dart';

class CommentReportsView extends StatelessWidget {
  const CommentReportsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      desktop: CommentReportsUniversalView(),
      tablet: CommentReportsUniversalView(),
      mobile: CommentReportsUniversalView(),
    );
  }
}