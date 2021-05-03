import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/dataSources/verificationDataSource.dart';
import 'package:frontendWeb/enums/confirm.dart';
import 'package:frontendWeb/models/user.dart';
import 'package:frontendWeb/services/userServices.dart';
import 'package:provider/provider.dart';

class VerificationUniversal extends StatefulWidget {
  VerificationUniversal({Key key}) : super(key: key);

  @override
  _VerificationUniversalState createState() => _VerificationUniversalState();
}

class _VerificationUniversalState extends State<VerificationUniversal> {
  String verifyTitle = "Verifikacija naloga";
  String verifyMultipleContent = "Da li ste sigurni da želite da verifikujete odabrane naloge?";

  String deleteTitle = "Odbijanje zahteva";
  String deleteMultipleContent = "Da li ste sigurni da želite da odbijete zahteve za verifikaciju i obrišete odabrane naloge?";

  int rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int columnIndex = 1;

  bool sortAscending = true;

  List<User> institutions;
  VerificationDataSource tableDataSource;

  void sort<T>(Comparable<T> getField(User u), int sortColumnIndex, bool ascending) {
    tableDataSource?.sort(getField, ascending); 
    
    setState(() {
      columnIndex = sortColumnIndex;
      sortAscending = ascending;
    });
  }

  Future<void> getAllUnverified() async {
    var response = await Provider.of<UserService>(context, listen: false).getAllForVerification();

    setState(() {
      institutions = response;
      tableDataSource = VerificationDataSource(institutions, context);
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
    getAllUnverified();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return institutions == null || tableDataSource == null ? Center(child: CircularProgressIndicator()) : ListView(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      children: [
        SingleChildScrollView(
          child: PaginatedDataTable(
            columnSpacing: 5,
            header: Text("Verifikacija naloga institucija", style: appBarTitle),
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
                label: Text("Korisničko ime", style: headerTable),
                onSort: (int columnIndex, bool sortAscending) => sort<String>((User u) => u.username.toLowerCase(), columnIndex, sortAscending),
              ),
              DataColumn(
                label: Text("Naziv institucije", style: headerTable),
                onSort: (int columnIndex, bool sortAscending) => sort<String>((User u) => u.name.toLowerCase(), columnIndex, sortAscending),
              ),
              DataColumn(
                label: Text("Mejl adresa", style: headerTable),
                onSort: (int columnIndex, bool sortAscending) => sort<String>((User u) => u.email.toLowerCase(), columnIndex, sortAscending),
              ),
              DataColumn(
                label: Text("Grad", style: headerTable),
                onSort: (int columnIndex, bool sortAscending) => sort<String>((User u) => u.city.toLowerCase(), columnIndex, sortAscending),
              ),
              DataColumn(
                label: Text("Akcije", style: headerTable),
              ),
            ],
            source: tableDataSource,
            actions: [
              IconButton(
                tooltip: "Verifikujte sve odabrane naloge",
                icon: Icon(Icons.done_all, color: Colors.lightGreen),
                onPressed: () async {
                  var res = await asyncConfirmDialog(context, verifyTitle, verifyMultipleContent);

                  if (res == ConfirmAction.ACCEPT) {
                    for (var institution in institutions) {
                      if (institution.selected == true) {
                        await Provider.of<UserService>(context, listen: false).verifyInstitution(institution.username);
                      }
                    }
                  }

                  setState(() {
                    institutions.removeWhere((element) => element.selected == true);
                    tableDataSource = VerificationDataSource(institutions, context);
                  });
                },
              ), 
              IconButton(
                tooltip: "Izbrišite sve odabrane zahteve",
                icon: Icon(Icons.delete, color: Colors.lightGreen),
                onPressed: () async {
                  var res = await asyncConfirmDialog(context, deleteTitle, deleteMultipleContent);

                  if (res == ConfirmAction.ACCEPT) {
                    for (var institution in institutions) {
                      if (institution.selected == true) {
                        await Provider.of<UserService>(context, listen: false).deleteUserAccount(institution.username);
                      }
                    }
                  }

                  setState(() {
                    institutions.removeWhere((element) => element.selected == true);
                    tableDataSource = VerificationDataSource(institutions, context);
                  });
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