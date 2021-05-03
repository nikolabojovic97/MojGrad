import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/enums/confirm.dart';
import 'package:frontendWeb/models/user.dart';
import 'package:frontendWeb/utils/app_routes.dart';

class InstitutionDataSource extends DataTableSource {
  final List<User> users;
  int rowsSelectedCount = 0;
  BuildContext context;

  InstitutionDataSource(this.users, this.context);

  @override
  DataRow getRow(int index) {
    assert (index >= 0);
    if (index >= users.length)
      return null;

    final User user = users[index];

    return DataRow.byIndex(
      index: index,
      selected: user.selected,
      onSelectChanged: (selected) {
        if (user.selected != selected) {
          rowsSelectedCount += selected ? 1 : -1;
          user.selected = selected;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text("${user.username}", style: itemTable)),
        DataCell(Text("${user.name}", style: itemTable)),
        DataCell(Text("${user.email}", style: itemTable)),
        DataCell(Text("${user.city}", style: itemTable)),
        DataCell(Text("${user.reportValidityRounded()}%", style: itemTable)),
        DataCell(
          IconButton(
            icon: Icon(Icons.info),
            color: Colors.lightGreen,
            tooltip: "Detalji korisnika",
            onPressed: () async {
              var result = await Navigator.pushNamed(
                context, 
                AppRoutes.institutionDetails,
                arguments: user.username
              );
              
              if (result == ConfirmAction.ACCEPT) {
                Navigator.pushReplacementNamed(
                  context, 
                  AppRoutes.institutionUsers
                );
              }
            },
          )
        ),
      ]
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => rowsSelectedCount;

  void sort<T>(Comparable<T> getField(User u), bool ascending) {
    users.sort((User a, User b) {
      if (!ascending) {
        final User c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);

      return Comparable.compare(aValue, bValue);
    });

    notifyListeners();
  }

  void selectAll(bool isAllChecked) {
    users.forEach((element) => element.selected = isAllChecked);
    rowsSelectedCount = isAllChecked ? users.length : 0;
    notifyListeners();
  }
}
