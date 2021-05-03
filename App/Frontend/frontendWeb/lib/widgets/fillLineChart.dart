import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/views/dashboard/dashboard_view_universal.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class FillLineChart extends StatelessWidget {
  final List<PopularityData> data;

  FillLineChart({@required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<PopularityData, int>> series = [
      charts.Series(
        id: "Popularnost",
        data: data,
        domainFn: (PopularityData dataP, _) => dataP.num,
        measureFn: (PopularityData dataP, _) => dataP.number,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(chart2)
      )
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
                "Popularnost",
                style: sideBarItem,
              ),
              Expanded(
                child: charts.LineChart(
                  series, 
                  animate: true,
                  defaultRenderer: charts.LineRendererConfig(includePoints: true, includeArea: true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}