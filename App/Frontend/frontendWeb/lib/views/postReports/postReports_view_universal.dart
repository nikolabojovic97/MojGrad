import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/dataSources/postReportDataSource.dart';
import 'package:frontendWeb/enums/confirm.dart';
import 'package:frontendWeb/models/postReport.dart';
import 'package:frontendWeb/models/user.dart';
import 'package:frontendWeb/services/postReportServices.dart';
import 'package:frontendWeb/services/userServices.dart';
import 'package:provider/provider.dart';

class PostReportsUniversalView extends StatefulWidget {
  PostReportsUniversalView({Key key}) : super(key: key);

  @override
  _PostReportsUniversalViewState createState() => _PostReportsUniversalViewState();
}

class _PostReportsUniversalViewState extends State<PostReportsUniversalView> {
  final String alertDialogTitle = "Brisanje prijava objava";
  final String alertDialogContent = "Da li ste sigurni da želite da izbrišete izabrane prijave objava?";

  int rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int columnIndex = 1;

  bool sortAscending = true;

  List<PostReport> postReports;
  PostReportDataSource tableDataSource;

  User user;

  void sort<T>(Comparable<T> getField(PostReport pr), int sortColumnIndex, bool ascending) {
    tableDataSource?.sort(getField, ascending); 
    
    setState(() {
      columnIndex = sortColumnIndex;
      sortAscending = ascending;
    });
  }

  Future<void> getAllPostReports() async {
    user = Provider.of<UserService>(context, listen: false).user;
    var response = await PostReportServices.getPostReports(user.token);

    setState(() {
      postReports = response;
      tableDataSource = PostReportDataSource(postReports, context);
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
    getAllPostReports();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return postReports == null || tableDataSource == null ? Center(child: CircularProgressIndicator()) : ListView(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      children: [
        SingleChildScrollView(
          child: PaginatedDataTable(
            columnSpacing: 5,
            header: Text("Prijave objava", style: appBarTitle),
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
                onSort: (int columnIndex, bool sortAscending) => sort<DateTime>((PostReport pr) => pr.dateReported, columnIndex, sortAscending),
              ),
              DataColumn(
                label: Text("Prijavljeni korisnik", style: headerTable),
                onSort: (int columnIndex, bool sortAscending) => sort<String>((PostReport pr) => pr.reportedUsername.toLowerCase(), columnIndex, sortAscending),
              ),
              DataColumn(
                label: Text("Podnosilac prijave", style: headerTable),
                onSort: (int columnIndex, bool sortAscending) => sort<String>((PostReport pr) => pr.username.toLowerCase(), columnIndex, sortAscending),
              ),
              DataColumn(
                label: Text("Broj prijava", style: headerTable),
                onSort: (int columnIndex, bool sortAscending) => sort<num>((PostReport pr) => pr.reportsNumber, columnIndex, sortAscending),
              ),
              DataColumn(
                label: Text("Validnost prijava", style: headerTable),
                onSort: (int columnIndex, bool sortAscending) => sort<num>((PostReport pr) => pr.reportValidity, columnIndex, sortAscending),
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
                    for (var report in postReports) {
                      if (report.selected == true) {
                        await PostReportServices.deletePostReport(report.id, user.token);
                      }
                    }

                    setState(() {
                      postReports.removeWhere((element) => element.selected == true);
                      tableDataSource = PostReportDataSource(postReports, context);
                    });
                  }
                },
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