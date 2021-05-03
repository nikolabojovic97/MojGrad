import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/views/dashboard/dashboard_view_universal.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PieChart extends StatelessWidget {
  final List<PieChartData> data;

  PieChart({@required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<PieChartData, String>> series = [
      charts.Series(
        id: "Tipovi problema",
        data: data,
        domainFn: (PieChartData dataPC, _) => dataPC.type,
        measureFn: (PieChartData dataPC, _) => dataPC.number,
        colorFn: (PieChartData dataPC, _) => dataPC.barColor,
        labelAccessorFn: (PieChartData dataPC, _) => dataPC.type
      ),
    ];

    return Container(
      height: 250,
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
                "Aktivnost korisnika",
                style: sideBarItem,
              ),
              Expanded(
                child: charts.PieChart(
                  series, 
                  animate: true, 
                  defaultRenderer: charts.ArcRendererConfig(arcWidth: 60,  arcRendererDecorators: [new charts.ArcLabelDecorator()]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}