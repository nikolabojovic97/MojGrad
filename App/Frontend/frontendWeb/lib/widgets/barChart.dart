import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/views/dashboard/dashboard_view_universal.dart';

class BarChart extends StatelessWidget {
  final List<MLData> data;

  BarChart({@required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<MLData, String>> series = [
      charts.Series(
        id: "Tipovi problema",
        data: data,
        domainFn: (MLData dataML, _) => dataML.problemType,
        measureFn: (MLData dataML, _) => dataML.percentage,
        colorFn: (MLData dataML, _) => dataML.barColor,
      )
    ];

    return Container(
      height: 400,
      width: 400,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 10.0,
          ),
        ]
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                "Zastupljenost tipova problema",
                style: sideBarName,
              ),
              Expanded(
                child: charts.BarChart(series, animate: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}