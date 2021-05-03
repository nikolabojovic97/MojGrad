import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/views/dashboard/dashboard_view_universal.dart';

class LineChartPoints extends StatelessWidget {
  final List<ProblemPostsData> data;

  LineChartPoints({@required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<ProblemPostsData, int>> series = [
      charts.Series(
        id: "Objave",
        data: data,
        domainFn: (ProblemPostsData dataPP, _) => dataPP.num,
        measureFn: (ProblemPostsData dataPP, _) => dataPP.number,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(chart4)
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
                "Objavljivanje problema",
                style: sideBarItem,
              ),
              Expanded(
                child: charts.LineChart(
                  series, 
                  animate: true,
                  defaultRenderer: charts.LineRendererConfig(includePoints: true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}