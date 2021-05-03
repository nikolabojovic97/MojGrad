import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/dataSources/userDataSource.dart';
import 'package:frontendWeb/enums/confirm.dart';
import 'package:frontendWeb/models/user.dart';
import 'package:frontendWeb/services/postServices.dart';
import 'package:frontendWeb/services/userServices.dart';
import 'package:provider/provider.dart';

class UsersUniversalView extends StatefulWidget {
  UsersUniversalView({Key key}) : super(key: key);

  @override
  _UsersUniversalViewState createState() => _UsersUniversalViewState();
}

class _UsersUniversalViewState extends State<UsersUniversalView> {
  final String alertDialogTitle = "Brisanje korisničkih naloga";
  final String alertDialogContent = "Da li ste sigurni da želite da izbrišete izabrane korisničke naloge?";

  int rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int columnIndex = 1;

  bool sortAscending = true;

  List<User> users;
  UserDataSource tableDataSource;
  User loggedUser;

  void sort<T>(Comparable<T> getField(User u), int sortColumnIndex, bool ascending) {
    tableDataSource?.sort(getField, ascending); 
    
    setState(() {
      columnIndex = sortColumnIndex;
      sortAscending = ascending;
    });
  }

  Future<void> getAllRegularUsers() async {
    loggedUser = Provider.of<UserService>(context, listen: false).user;
    var response = await Provider.of<UserService>(context, listen: false).getRegularUsers();

    setState(() {
      users = response;
      tableDataSource = UserDataSource(users, context);
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return users == null || tableDataSource == null ? Center(child: CircularProgressIndicator()) : ListView(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      children: [
        SingleChildScrollView(
          child: PaginatedDataTable(
            columnSpacing: 5,
            header: Text("Upravljanje korisničkim nalozima", style: appBarTitle),
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
                label: Text("Ime i prezime", style: headerTable),
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
                tooltip: "Izbrišite sve odabrane prijave",
                icon: Icon(Icons.delete, color: Colors.lightGreen),
                onPressed: () async {
                  var res = await asyncConfirmDialog(context, alertDialogTitle, alertDialogContent);

                  if (res == ConfirmAction.ACCEPT) {
                    for (var user in users) {
                      if (user.selected == true) {
                        await PostServices.deleteAllPostsByUser(user.username, loggedUser.token);
                        await Provider.of<UserService>(context, listen: false).deleteUserAccount(user.username);
                      }
                    }

                    setState(() {
                      users.removeWhere((element) => element.selected == true);
                      tableDataSource = UserDataSource(users, context);
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