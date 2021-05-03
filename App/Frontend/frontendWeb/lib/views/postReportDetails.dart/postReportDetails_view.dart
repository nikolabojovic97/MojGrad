import 'package:flutter/material.dart';
import 'package:frontendWeb/views/postReportDetails.dart/postReportDetails_view_universal.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PostReportDetails extends StatelessWidget {
  const PostReportDetails({Key key, this.args}) : super(key: key);

  final int args;

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments;

    return ScreenTypeLayout(
      mobile: PostReportDetailsUniversal(reportId: args),
      tablet: PostReportDetailsUniversal(reportId: args),
      desktop: PostReportDetailsUniversal(reportId: args),
    );
  }
}