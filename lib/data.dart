import 'dart:collection';
import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Data> fetchData(String apiKey, String symbol) async {
  final response = await http.get(
      'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=$symbol&apikey=$apiKey');

  if (response.statusCode == 200) {
    return Data.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed');
  }
}

class StockChart extends StatelessWidget {
  final List data;
  final bool animate;

  const StockChart({
    Key key,
    this.data,
    this.animate,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      data,
      animate: animate,
      primaryMeasureAxis: new charts.NumericAxisSpec(
        tickProviderSpec: new charts.StaticNumericTickProviderSpec(
          <charts.TickSpec<num>>[
            charts.TickSpec(0, label: ''),
            charts.TickSpec(1, label: ''),
          ],
        ),
      ),
      disjointMeasureAxes:
          new LinkedHashMap<String, charts.NumericAxisSpec>.from(
        {
          'axis 1': new charts.NumericAxisSpec(),
          'axis 2': new charts.NumericAxisSpec(),
        },
      ),
    );
  }
}

class Data {
  List<charts.Series<dynamic, DateTime>> seriesList;

  Data({
    this.seriesList,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    Map data = json['Time Series (Daily)'];

    List<ChartData> close = List();
    List<ChartData> volume = List();

    int counter = 0;

    data.forEach(
      (key, value) {
        if (counter < 20) {
          close.add(
            new ChartData(
              new DateTime(
                int.parse(key.substring(0, 4)),
                int.parse(key.substring(5, 7)),
                int.parse(key.substring(8)),
              ),
              double.parse(value['4. close']),
            ),
          );
          volume.add(
            new ChartData(
              new DateTime(
                int.parse(key.substring(0, 4)),
                int.parse(key.substring(5, 7)),
                int.parse(key.substring(8)),
              ),
              int.parse(value['5. volume']),
            ),
          );
          counter++;
        }
      },
    );
    return new Data(
      seriesList: [
        charts.Series<ChartData, DateTime>(
          id: 'Fake',
          domainFn: (ChartData data, _) => data.time,
          measureFn: (ChartData data, _) => data.val,
          data: [],
        ),
        charts.Series<ChartData, DateTime>(
          id: 'close',
          domainFn: (ChartData data, _) => data.time,
          measureFn: (ChartData data, _) => data.val,
          data: close,
          colorFn: (_, __) => (close.first.val > close.last.val)
              ? charts.Color.fromHex(code: '#64ddac')
              : charts.Color.fromHex(code: '#cc2737'),
        )..setAttribute(charts.measureAxisIdKey, 'axis 1'),
        charts.Series<ChartData, DateTime>(
          id: 'volume',
          domainFn: (ChartData data, _) => data.time,
          measureFn: (ChartData data, _) => data.val,
          data: volume,
          colorFn: (_, __) => charts.Color.fromHex(code: '#48487c'),
        )..setAttribute(charts.measureAxisIdKey, 'axis 2'),
      ],
    );
  }
}

class ChartData {
  final DateTime time;
  final num val;

  ChartData(this.time, this.val);
}
