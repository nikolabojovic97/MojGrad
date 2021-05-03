import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/config/config.dart';
import 'package:frontendWeb/enums/confirm.dart';
import 'package:frontendWeb/models/post.dart';
import 'package:frontendWeb/models/postComment.dart';
import 'package:frontendWeb/models/user.dart';
import 'package:frontendWeb/services/postCommentServices.dart';
import 'package:frontendWeb/services/postServices.dart';
import 'package:frontendWeb/services/userServices.dart';
import 'package:frontendWeb/utils/app_routes.dart';
import 'package:frontendWeb/widgets/reportDetailsPost.dart';
import 'package:provider/provider.dart';

class CommentReportDetailsUniversal extends StatefulWidget {
  final int commentReportId;

  CommentReportDetailsUniversal({Key key, this.commentReportId}) : super(key: key);

  @override
  _CommentReportDetailsUniversalState createState() => _CommentReportDetailsUniversalState(commentReportId);
}

class _CommentReportDetailsUniversalState extends State<CommentReportDetailsUniversal> {
  // what we get from the route
  final int commentReportId;

  _CommentReportDetailsUniversalState(this.commentReportId);

  // needed data
  PostComment reportedComment;
  Post post;
  List<String> images;
  User user;

  final String deleteAllReportsTitle = "Brisanje prijava";
  final String deleteAllReportsContent = "Da li ste sigurni da želite da obrišete sve prijave ovog komentara?";

  final String deleteCommentTitle = "Brisanje prijavljenog komentara";
  final String deleteCommentContent = "Da li ste sigurni da želite da obrišete prijavljeni komentar?";

  Future<void> initInfo() async {
    user = Provider.of<UserService>(context, listen: false).user;

    PostComment loadComment = await PostCommentServices.getPostCommentById(commentReportId, user.token);
    Post loadPost;
    List<String> loadImages = [];

    if (loadComment == null)
      return;
    
    loadPost = await PostServices.getPost(loadComment.postId, user.token);

    if (loadPost == null)
      return;

    for (var image in loadPost.imgUrl) {
      loadImages.add(getPostImageURL + image);
    }  

    setState(() {
      reportedComment = loadComment;
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

    if (commentReportId == null) 
      Future.delayed(Duration.zero, () {
      Navigator.of(context).popAndPushNamed(AppRoutes.commentReports);
    });
    else {
      initInfo();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> deleteComment(int id) async {
    await PostCommentServices.deleteCommentAndApproveReports(id, user.token);
    Navigator.of(context).pop(ConfirmAction.ACCEPT);
  }

  Future<void> deleteAllReports(int id) async {
    await PostCommentServices.deleteAllReportsOfComment(id, user.token);
    Navigator.of(context).pop(ConfirmAction.ACCEPT);
  }

  @override
  Widget build(BuildContext context) {
    return post == null ?
      Center(
        child: CircularProgressIndicator(),
      ) :
      ListView(
        padding: EdgeInsets.only(bottom: 10),
        children: [
          ReportDetailsPost(key: UniqueKey(), post: post, images: images, deletePost: null, deleteAllReports: null),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: reportedCommentWidget(),
          )
        ],
      );
  }

  Widget reportedCommentWidget() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red[100],
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Row(
        children: [
          Row(
            children: [
              Icon(
                Icons.report,
                size: 25,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                reportedComment.reportsNumber.toString(),
                style: postReportDetailsCardMain,
              ),
            ],
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        checkUserImgUrl(reportedComment.userImgUrl)    
                      ),
                      radius: 15.0,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      reportedComment.userName,
                      style: postReportDetailsCardUsername,
                      softWrap: true,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    reportedComment.comment,
                    maxLines: null,
                    overflow: TextOverflow.fade,
                    style: postReportDetailsCardMain,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            direction: Axis.horizontal,
            children: [
              IconButton(
                icon: Icon(Icons.report_off),
                iconSize: 25.0,
                tooltip: "Izbrišite sve prijave komentara",
                onPressed: () async {
                  var res = await asyncConfirmDialog(context, deleteAllReportsTitle, deleteAllReportsContent);

                  if (res == ConfirmAction.ACCEPT) {
                    deleteAllReports(reportedComment.id);
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                iconSize: 25.0,
                tooltip: "Izbrišite prijavljeni komentar",
                onPressed: () async {
                  var res = await asyncConfirmDialog(context, deleteCommentTitle, deleteCommentContent);

                  if (res == ConfirmAction.ACCEPT) {
                    deleteComment(reportedComment.id);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<ConfirmAction> asyncConfirmDialog(BuildContext context, String title, String content) async {
    return showDialog<ConfirmAction> (
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titleTextStyle: alertTitle,
          contentTextStyle: alertContent,
          title: Text(
            title,
          ),
          content: Text(
            content,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          actions: [
            FlatButton(
              child: Text(
                "Da",
                style: alertOption,
              ),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            ),
            FlatButton(
              child: Text(
                "Ne",
                style: alertOption,
              ),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
          ],
        );
      }
    );
  }
}