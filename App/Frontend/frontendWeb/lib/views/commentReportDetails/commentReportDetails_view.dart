import 'package:flutter/material.dart';
import 'package:frontendWeb/responsive/screen_type_layout.dart';
import 'package:frontendWeb/views/commentReportDetails/commentReportDetails_view_universal.dart';

class CommentReportDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   var args = ModalRoute.of(context).settings.arguments;

    return ScreenTypeLayout(
      mobile: CommentReportDetailsUniversal(commentReportId: args),
      tablet: CommentReportDetailsUniversal(commentReportId: args),
      desktop: CommentReportDetailsUniversal(commentReportId: args),
    );
  }
}
