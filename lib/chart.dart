import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleLineChart(this.seriesList, {this.animate});

  factory SimpleLineChart.withSampleData(
      List<charts.Series<ChartData, int>> list) {
    return new SimpleLineChart(
      list,
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(seriesList, animate: animate);
  }
}

class ChartData {
  final int x;
  final double y;

  ChartData(this.x, this.y);
}
