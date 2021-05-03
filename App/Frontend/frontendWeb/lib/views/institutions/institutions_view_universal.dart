import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/dataSources/institutionDataSource.dart';
import 'package:frontendWeb/enums/confirm.dart';
import 'package:frontendWeb/models/user.dart';
import 'package:frontendWeb/services/postServices.dart';
import 'package:frontendWeb/services/userServices.dart';
import 'package:provider/provider.dart';

class InstitutionsUniversalView extends StatefulWidget {
  InstitutionsUniversalView({Key key}) : super(key: key);

  @override
  _InstitutionsUniversalViewState createState() => _InstitutionsUniversalViewState();
}

class _InstitutionsUniversalViewState extends State<InstitutionsUniversalView> {
  final String alertDialogTitle = "Brisanje naloga";
  final String alertDialogContent = "Da li ste sigurni da želite da izbrišete izabrane naloge institucija?";

  int rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int columnIndex = 1;

  bool sortAscending = true;

  List<User> institutions;
  InstitutionDataSource tableDataSource;
  User user;

  void sort<T>(Comparable<T> getField(User u), int sortColumnIndex, bool ascending) {
    tableDataSource?.sort(getField, ascending); 
    
    setState(() {
      columnIndex = sortColumnIndex;
      sortAscending = ascending;
    });
  }

  Future<void> getAllRegularUsers() async {
    var response = await Provider.of<UserService>(context, listen: false).getAllVerifiedInstitutions();

    setState(() {
      institutions = response;
      tableDataSource = InstitutionDataSource(institutions, context);
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
    getAllRegularUsers();
    user = Provider.of<UserService>(context, listen: false).user;
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
            header: Text("Upravljanje nalozima institucija", style: appBarTitle),
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
                label: Text("Validnost prijava", style: headerTable),
                onSort: (int columnIndex, bool sortAscending) => sort<num>((User u) => u.reportValidity, columnIndex, sortAscending),
              ),
              DataColumn(
                label: Text("Detalji", style: headerTable),
              ),
            ],
            source: tableDataSource,
            actions: [
              IconButton(
                tooltip: "Izbrišite sve odabrane naloge",
                icon: Icon(Icons.delete, color: Colors.lightGreen),
                onPressed: () async {
                  var res = await asyncConfirmDialog(context, alertDialogTitle, alertDialogContent);

                  if (res == ConfirmAction.ACCEPT) {
                    for (var institution in institutions) {
                      if (institution.selected == true) {
                        await PostServices.deleteAllPostsByUser(institution.username, user.token);
                        await Provider.of<UserService>(context, listen: false).deleteUserAccount(institution.username);
                      }
                    }

                    setState(() {
                      institutions.removeWhere((element) => element.selected == true);
                      tableDataSource = InstitutionDataSource(institutions, context);
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
