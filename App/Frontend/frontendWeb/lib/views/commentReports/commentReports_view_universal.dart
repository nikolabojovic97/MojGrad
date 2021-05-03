import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/dataSources/commentReportDataSource.dart';
import 'package:frontendWeb/enums/confirm.dart';
import 'package:frontendWeb/models/commentReport.dart';
import 'package:frontendWeb/models/user.dart';
import 'package:frontendWeb/services/commentReportServices.dart';
import 'package:frontendWeb/services/userServices.dart';
import 'package:provider/provider.dart';

class CommentReportsUniversalView extends StatefulWidget {
  CommentReportsUniversalView({Key key}) : super(key: key);

  @override
  _CommentReportsUniversalViewState createState() => _CommentReportsUniversalViewState();
}

class _CommentReportsUniversalViewState extends State<CommentReportsUniversalView> {
  final String alertDialogTitle = "Brisanje prijava komentara";
  final String alertDialogContent = "Da li ste sigurni da želite da izbrišete izabrane prijave komentara?";

  int rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int columnIndex = 1;

  bool sortAscending = true;

  List<CommentReport> commentReports;
  CommentReportDataSource tableDataSource;

  User user;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void sort<T>(Comparable<T> getField(CommentReport cr), int sortColumnIndex, bool ascending) {
    tableDataSource?.sort(getField, ascending); 
    
    setState(() {
      columnIndex = sortColumnIndex;
      sortAscending = ascending;
    });
  }

  Future<void> getAllCommentReports() async {
    user = Provider.of<UserService>(context, listen: false).user;
    var response = await CommentReportServices.getCommentReports(user.token);

    setState(() {
      commentReports = response;
      tableDataSource = CommentReportDataSource(commentReports, context);
    });
  }

  @override
  void initState() {
    super.initState();
    getAllCommentReports();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return commentReports == null || tableDataSource == null ? Center(child: CircularProgressIndicator()) : ListView(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      children: [
        SingleChildScrollView(
          child: PaginatedDataTable(
            columnSpacing: 5,
            header: Text("Prijave komentara", style: appBarTitle),
            dataRowHeight: 40,
            rowsPerPage: rowsPerPage,
            onRowsPerPageChanged: (rowCount) {
              setState(() {
                rowsPerPage = rowCount;
              });
            },
            sortColumnIndex: columnIndex,
            sortAscending: sortAscending,
            onSelectAll: (isAllChecked) => tableDataSource?.selectAll(isAllChecked),
            columns: [
              DataColumn(
                label: Text("Datum prijave", style: headerTable),
                onSort: (int columnIndex, bool sortAscending) => sort<DateTime>((CommentReport cr) => cr.dateReported, columnIndex, sortAscending),
              ),
              DataColumn(
                label: Text("Prijavljeni korisnik", style: headerTable),
                onSort: (int columnIndex, bool sortAscending) => sort<String>((CommentReport cr) => cr.reportedUserName.toLowerCase(), columnIndex, sortAscending),
              ),
              DataColumn(
                label: Text("Podnosilac prijave", style: headerTable),
                onSort: (int columnIndex, bool sortAscending) => sort<String>((CommentReport cr) => cr.username.toLowerCase(), columnIndex, sortAscending),
              ),
              DataColumn(
                label: Text("Broj prijava", style: headerTable),
                onSort: (int columnIndex, bool sortAscending) => sort<num>((CommentReport cr) => cr.reportsNumber, columnIndex, sortAscending),
              ),
              DataColumn(
                label: Text("Validnost prijava", style: headerTable),
                onSort: (int columnIndex, bool sortAscending) => sort<num>((CommentReport cr) => cr.reportValidity, columnIndex, sortAscending),
              ),
              DataColumn(
                label: Text("Detalji", style: headerTable),
              ),
            ],
            source: tableDataSource,
            actions: [
              IconButton(
                tooltip: "Izbrišite sve odabrane prijave",
                icon: Icon(Icons.delete, color: Colors.lightGreen),
                onPressed: () async {
                  var res = await asyncConfirmDialog(context, alertDialogTitle, alertDialogContent);

                  if (res == ConfirmAction.ACCEPT) {
                    for (var report in commentReports) {
                      if (report.selected == true) {
                        await CommentReportServices.deleteCommentReport(report.id, user.token);
                      }
                    }

                    setState(() {
                      commentReports.removeWhere((element) => element.selected == true);
                      tableDataSource = CommentReportDataSource(commentReports, context);
                    });
                  }
                }
              ), 
            ], 
          ),
        ),
      ],
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