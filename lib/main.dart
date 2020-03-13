import 'dart:async';
import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_candlesticks/flutter_candlesticks.dart';
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
  List<Map> list;

  Data({
    this.list,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    Map data = json['Time Series (Daily)'];

    List<Map> list = List();

    data.forEach((key, value) {
      list.add(
        {
          'open': double.parse(value['1. open']),
          'high': double.parse(value['2. high']),
          'low': double.parse(value['3. low']),
          'close': double.parse(value['4. close']),
          'volumeto': double.parse(value['5. volume']),
        },
      );
    });
    return new Data(list: list);
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
                List _data = snapshot.data.list;
                return new OHLCVGraph(
                  data: _data,
                  enableGridLines: true,
                  volumeProp: 0.2,
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
