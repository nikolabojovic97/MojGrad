import 'package:flutter/material.dart';
import 'package:frontendWeb/config/config.dart';
import 'package:frontendWeb/enums/confirm.dart';
import 'package:frontendWeb/models/post.dart';
import 'package:frontendWeb/models/user.dart';
import 'package:frontendWeb/services/postServices.dart';
import 'package:frontendWeb/services/userServices.dart';
import 'package:frontendWeb/utils/app_routes.dart';
import 'package:frontendWeb/widgets/reportDetailsPost.dart';
import 'package:provider/provider.dart';

class PostReportDetailsUniversal extends StatefulWidget {
  final int reportId;

  PostReportDetailsUniversal({Key key, this.reportId}) : super(key: key);

  @override
  _PostReportDetailsUniversalState createState() => _PostReportDetailsUniversalState(reportId);
}

class _PostReportDetailsUniversalState extends State<PostReportDetailsUniversal> {
  // what we get from the route
  final int reportId;

  _PostReportDetailsUniversalState(this.reportId);

  // needed data
  Post post;
  List<String> images;
  User user;

  Future<void> initInfo() async {
    Post loadPost;
    List<String> loadImages = [];

    user = Provider.of<UserService>(context, listen: false).user;

    loadPost = await PostServices.getPost(reportId, user.token);

    if (loadPost == null)
      return;

    for (var image in loadPost.imgUrl) {
      loadImages.add(getPostImageURL + image);
    }  

    setState(() {
      post = loadPost;
      images = loadImages;
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    if (reportId == null) 
      Future.delayed(Duration.zero, () {
        Navigator.of(context).popAndPushNamed(AppRoutes.postReports);
      });
    else {
      initInfo();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> deletePost(int id) async {
    await PostServices.deletePostAndApproveReports(id, user.token);
    Navigator.of(context).pop(ConfirmAction.ACCEPT);
  }

  Future<void> deleteAllReports(int id) async {
    await PostServices.deleteAllReportsOfPost(id, user.token);
    Navigator.of(context).pop(ConfirmAction.ACCEPT);
  }

  @override
  Widget build(BuildContext context) {
    return post == null ? 
      Center(
        child: CircularProgressIndicator(),
      ) :
      ListView(
        children: [
          ReportDetailsPost(key: UniqueKey(), post: post, images: images, deletePost: deletePost, deleteAllReports: deleteAllReports),
        ],
      );
  }
}