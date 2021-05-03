import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/enums/confirm.dart';
import 'package:frontendWeb/models/commentReport.dart';
import 'package:frontendWeb/utils/app_routes.dart';

class CommentReportDataSource extends DataTableSource {
  final List<CommentReport> reports;
  int rowsSelectedCount = 0;
  BuildContext context;

  CommentReportDataSource(this.reports, this.context);

  @override
  DataRow getRow(int index) {
    assert (index >= 0);
    if (index >= reports.length)
      return null;

    final CommentReport report = reports[index];

    return DataRow.byIndex(
      index: index,
      selected: report.selected,
      onSelectChanged: (selected) {
        if (report.selected != selected) {
          rowsSelectedCount += selected ? 1 : -1;
          report.selected = selected;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text("${report.dateReportedToString()}", style: itemTable)),
        DataCell(Text("${report.reportedUserName}", style: itemTable)),
        DataCell(Text("${report.username}", style: itemTable)),
        DataCell(Text("${report.reportsNumber}", style: itemTable)),
        DataCell(Text("${report.reportValidityRounded()}%", style: itemTable)),
        DataCell(
          IconButton(
            icon: Icon(Icons.info),
            color: Colors.lightGreen,
            tooltip: "Detalji prijave",
            onPressed: () async {
              var result = await Navigator.pushNamed(
                context, 
                AppRoutes.commentReportDetails,
                arguments: report.commentID,
              );
              
              if (result == ConfirmAction.ACCEPT) {
                Navigator.pushReplacementNamed(context, AppRoutes.commentReports);
              }
            },
          ),
        ),
      ]
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => reports.length;

  @override
  int get selectedRowCount => rowsSelectedCount;

  void sort<T>(Comparable<T> getField(CommentReport cr), bool ascending) {
    reports.sort((CommentReport a, CommentReport b) {
      if (!ascending) {
        final CommentReport c = a;
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
    reports.forEach((element) => element.selected = isAllChecked);
    rowsSelectedCount = isAllChecked ? reports.length : 0;
    notifyListeners();
  }
}