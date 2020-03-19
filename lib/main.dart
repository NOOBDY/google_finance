import 'dart:async';
import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

Future<Data> fetchData() async {
  final response = await http.get(
      'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=MSFT&apikey=demo');

  if (response.statusCode == 200) {
    return Data.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed');
  }
}

class Data {
  List<charts.Series<dynamic, DateTime>> seriesList;

  Data({
    this.seriesList,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    Map data = json['Time Series (Daily)'];

    List<ChartData> open = List();

    data.forEach(
      (key, value) {
        open.add(
          new ChartData(
            new DateTime(
              int.parse(key.substring(0, 4)),
              int.parse(key.substring(5, 7)),
              int.parse(key.substring(8)),
            ),
            double.parse(value['1. open']),
          ),
        );
      },
    );
    return new Data(seriesList: [
      charts.Series<ChartData, DateTime>(
        id: 'test',
        domainFn: (ChartData data, _) => data.time,
        measureFn: (ChartData data, _) => data.val,
        data: open,
      )
    ]);
  }
}

void main() => runApp(App());

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Future<Data> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: 'Test',
      home: Scaffold(
        body: Center(
          child: FutureBuilder<Data>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<charts.Series<dynamic, DateTime>> _data =
                    snapshot.data.seriesList;
                return charts.TimeSeriesChart(
                  _data,
                  animate: false,
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.hasError}');
              }
              return CircularProgressIndicator();
            },
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}

class ChartData {
  final DateTime time;
  final double val;

  ChartData(this.time, this.val);
}