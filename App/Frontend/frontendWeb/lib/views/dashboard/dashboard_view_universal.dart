import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';
import 'package:frontendWeb/models/statistics.dart';
import 'package:frontendWeb/models/user.dart';
import 'package:frontendWeb/services/statisticsServices.dart';
import 'package:frontendWeb/services/userServices.dart';
import 'package:frontendWeb/widgets/LineChartPoints.dart';
import 'package:frontendWeb/widgets/fillLineChart.dart';
import 'package:frontendWeb/widgets/infoSmallTile.dart';
import 'package:frontendWeb/widgets/pieChart.dart';
import 'package:frontendWeb/widgets/barChart.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DashboardViewUniversal extends StatefulWidget {
  DashboardViewUniversal({Key key}) : super(key: key);

  @override
  _DashboardViewUniversalState createState() => _DashboardViewUniversalState();
}

class _DashboardViewUniversalState extends State<DashboardViewUniversal> {
  Statistics stats;
  List<MLData> dataChart;
  List<PieChartData> pieChartData;
  List<ProblemPostsData> postsData;
  List<PopularityData> popularityData;

  Future<void> getStatistics() async {
    User user = Provider.of<UserService>(context, listen: false).user;
    var response = await StatisticsServices.getStatistics(user.token);

    setState(() {
      stats = response;

      dataChart = [
        MLData(
          problemType: "Grad",
          percentage: (stats.problemTypes[0] * 100).roundToDouble(),
          barColor: charts.ColorUtil.fromDartColor(chart2)
        ),
        MLData(
          problemType: "Priroda",
          percentage: (stats.problemTypes[1] * 100).roundToDouble(),
          barColor: charts.ColorUtil.fromDartColor(chart3)
        ),
        MLData(
          problemType: "Neidentifikovano",
          percentage: (stats.problemTypes[2] * 100).roundToDouble(),
          barColor: charts.ColorUtil.fromDartColor(chart4)
        ),
      ];

      pieChartData = [
        PieChartData(
          type: "Reakcije", 
          number: stats.latestReactionNumber,
          barColor: charts.ColorUtil.fromDartColor(chart1)
        ),
        PieChartData(
          type: "Prijave", 
          number: stats.latestReportNumber,
          barColor: charts.ColorUtil.fromDartColor(chart2)
        ),
        PieChartData(
          type: "Objave", 
          number: stats.latestPostNumber,
          barColor: charts.ColorUtil.fromDartColor(chart3)
        ),
        PieChartData(
          type: "Komentari", 
          number: stats.latestCommentNumber,
          barColor: charts.ColorUtil.fromDartColor(chart4)
        ),
      ];

      postsData = [];
      for (var i = 0; i < stats.dailyPosts.length; i++) {
        postsData.add(ProblemPostsData(num: i + 1, number: stats.dailyPosts[i]));
      }

      popularityData = [];
      for (var i = 0; i < stats.dailyLikes.length; i++) {
        popularityData.add(PopularityData(num: i + 1, number: stats.dailyLikes[i]));
      }
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
    getStatistics();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return stats == null ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: ResponsiveGridRow(
        children: [
          ResponsiveGridCol(
            xl: 4,
            lg: 4,
            md: 6,
            sm: 12,
            xs: 12,
            child: InfoSmallTile(
              cardTitle: "Broj korisnika",
              icon: Icons.people,
              information: stats.userNumber.toString(),
              mediaSize: 300,
              iconBgColor: Colors.white,
              cardBgColor: lightGreen0,
            ),
          ),
          ResponsiveGridCol(
            xl: 4,
            lg: 4,
            md: 6,
            sm: 12,
            xs: 12,
            child: InfoSmallTile(
              cardTitle: "Broj objava",
              icon: Icons.location_city,
              information: stats.postNumber.toString(),
              mediaSize: 300,
              iconBgColor: Colors.white,
              cardBgColor: lightGreen1,
            ),
          ),
          ResponsiveGridCol(
            xl: 4,
            lg: 4,
            md: 6,
            sm: 12,
            xs: 12,
            child: InfoSmallTile(
              cardTitle: "Broj rešenih problema",
              icon: Icons.score,
              information: stats.solutionNumber.toString(),
              mediaSize: 300,
              iconBgColor: Colors.white,
              cardBgColor: lightGreen2,
            ),
          ),
          ResponsiveGridCol(
            xl: 4,
            lg: 4,
            md: 6,
            sm: 12,
            xs: 12,
            child: InfoSmallTile(
              cardTitle: "Broj reakcija",
              icon: Icons.image,
              information: stats.reactionNumber.toString(),
              mediaSize: 300,
              iconBgColor: Colors.white,
              cardBgColor: gray0,
            ),
          ),
          ResponsiveGridCol(
            xl: 4,
            lg: 4,
            md: 6,
            sm: 12,
            xs: 12,
            child: InfoSmallTile(
              cardTitle: "Broj komentara",
              icon: Icons.thumb_up,
              information: stats.commentNumber.toString(),
              mediaSize: 300,
              iconBgColor: Colors.white,
              cardBgColor: gray1,
            ),
          ),
          ResponsiveGridCol(
            xl: 4,
            lg: 4,
            md: 6,
            sm: 12,
            xs: 12,
            child: InfoSmallTile(
              cardTitle: "Broj prijava",
              icon: Icons.comment,
              information: stats.reportNumber.toString(),
              mediaSize: 300,
              iconBgColor: Colors.white,
              cardBgColor: gray2,
            ),
          ),
          ResponsiveGridCol(
            xl: 4,
            lg: 4,
            md: 12,
            sm: 12,
            xs: 12,
            child: Container(
              child: PieChart(data: pieChartData)
            ),
          ),
          ResponsiveGridCol(
            xl: 4,
            lg: 4,
            md: 12,
            sm: 12,
            xs: 12,
            child: Container(
              child: LineChartPoints(data: postsData)
            ),
          ),
          ResponsiveGridCol(
            xl: 4,
            lg: 4,
            md: 12,
            sm: 12,
            xs: 12,
            child: Container(
              child: FillLineChart(data: popularityData)
            ),
          ),
          ResponsiveGridCol(
            xl: 12,
            md: 12,
            lg: 12,
            sm: 12,
            xs: 12,
            child: Container(
              width: 400,
              child: BarChart(data: dataChart),
            ),
          ),
        ],
      ),
    );
  }
}

class MLData {
  final String problemType;
  final double percentage;
  final charts.Color barColor;

  MLData({@required this.problemType, 
         @required this.percentage, 
         @required this.barColor});
} 

class PieChartData {
  final String type;
  final int number;
  final charts.Color barColor;

  PieChartData({@required this.type,
              @required this.number,
              @required this.barColor});
}

class ProblemPostsData {
  final int num;
  final double number;

  ProblemPostsData({@required this.num,
                  @required this.number});
}

class PopularityData {
  final int num;
  final double number;

  PopularityData({@required this.num,
                  @required this.number});
}