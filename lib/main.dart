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
  List<List> list;
  List<String> date;
  List<double> open;
  List<double> high;
  List<double> low;
  List<double> close;
  List<int> volume;

  Data({
    this.list,
    this.date,
    this.open,
    this.high,
    this.low,
    this.close,
    this.volume,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    Map data = json['Time Series (Daily)'];

    List<List> list = List();

    List<String> date = List();
    List<double> open = List();
    List<double> high = List();
    List<double> low = List();
    List<double> close = List();
    List<int> volume = List();

    data.forEach((key, value) {
      list.add([
        key,
        double.parse(value['1. open']),
        double.parse(value['2. high']),
        double.parse(value['3. low']),
        double.parse(value['4. close']),
        int.parse(value['5. volume']),
      ]);

      date.add(key);
      open.add(double.parse(value['1. open']));
      high.add(double.parse(value['2. high']));
      low.add(double.parse(value['3. low']));
      close.add(double.parse(value['4. close']));
      volume.add(int.parse(value['5. volume']));
    });
    return new Data(
      list: list,
      date: date,
      open: open,
      high: high,
      low: low,
      close: close,
      volume: volume,
    );
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
                List _list = snapshot.data.list;
                Data _data = snapshot.data;
                // List<charts.Series<dynamic, num>> _createData() {
                //   final data = _list;
                //   return [
                //     new charts.Series(
                //       id: 'bruh',
                //       data: data,
                //       domainFn: null,
                //       measureFn: null,
                //     )
                //   ];
                // }

                // return charts.LineChart(_createData());

                // return ListView.builder(
                //   itemCount: _list.length,
                //   itemBuilder: (context, index) {
                //     return ListTile(
                //       title: Text(
                //         'date: ${_data.date[index]}\nopen: ${_data.open[index]}\nhigh: ${_data.high[index]}\nlow: ${_data.low[index]}\nvolume: ${_data.volume[index]}\n',
                //         style: TextStyle(
                //           fontFamily: 'Roboto Mono',
                //           fontSize: 20,
                //           color: Colors.white,
                //         ),
                //       ),
                //     );
                //   },
                // );

                return new OHLCVGraph(
                  data: [_list],
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
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
