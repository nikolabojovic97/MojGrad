import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/enums/confirm.dart';
import 'package:frontendWeb/models/user.dart';
import 'package:frontendWeb/services/userServices.dart';
import 'package:frontendWeb/utils/app_routes.dart';
import 'package:provider/provider.dart';

class VerificationDataSource extends DataTableSource {
  final List<User> institutions;
  int rowsSelectedCount = 0;
  BuildContext context;

  VerificationDataSource(this.institutions, this.context);

  String verifyTitle = "Verifikacija naloga";
  String verifySingleContent = "Da li ste sigurni da želite da verifikujete odabrani nalog?";

  String deleteTitle = "Odbijanje zahteva";
  String deleteSingleContent = "Da li ste sigurni da želite da odbijete zahtev za verifikaciju i obrišete odabrani nalog?";

  @override
  DataRow getRow(int index) {
    assert (index >= 0);
    if (index >= institutions.length)
      return null;

    final User institution = institutions[index];

    return DataRow.byIndex(
      index: index,
      selected: institution.selected,
      onSelectChanged: (selected) {
        if (institution.selected != selected) {
          rowsSelectedCount += selected ? 1 : -1;
          institution.selected = selected;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text("${institution.username}", style: itemTable)),
        DataCell(Text("${institution.name}", style: itemTable)),
        DataCell(Text("${institution.email}", style: itemTable)),
        DataCell(Text("${institution.city}", style: itemTable)),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.check),
                color: Colors.lightGreen,
                tooltip: "Odobrite",
                onPressed: () async {
                  var res = await asyncConfirmDialog(context, verifyTitle, verifySingleContent);

                  if (res == ConfirmAction.ACCEPT) {
                    await Provider.of<UserService>(context, listen: false).verifyInstitution(institution.username);

                    Navigator.of(context).pushReplacementNamed(AppRoutes.verification);
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.close),
                color: Colors.lightGreen,
                tooltip: "Odbijte",
                onPressed: () async {
                  var res = await asyncConfirmDialog(context, deleteTitle, deleteSingleContent);

                  if (res == ConfirmAction.ACCEPT) {
                    await Provider.of<UserService>(context, listen: false).deleteUserAccount(institution.username);

                    Navigator.of(context).pushReplacementNamed(AppRoutes.verification);
                  }
                },
              )
            ],
          ),
        ),
      ]
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => institutions.length;

  @override
  int get selectedRowCount => rowsSelectedCount;

  void sort<T>(Comparable<T> getField(User u), bool ascending) {
    institutions.sort((User a, User b) {
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
    institutions.forEach((element) => element.selected = isAllChecked);
    rowsSelectedCount = isAllChecked ? institutions.length : 0;
    notifyListeners();
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
