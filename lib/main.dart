import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data.dart';

String apiKey = 'TT1KDKHC0BDTBO6A';
String symbol = 'GOOGL';

void main() => runApp(FutureWidget());

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(),
    );
  }
}

class FutureWidget extends StatefulWidget {
  FutureWidget({Key key}) : super(key: key);

  @override
  FutureState createState() => FutureState();
}

class FutureState extends State<FutureWidget> {
  Future<Data> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData(apiKey, symbol);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: 'Test',
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            '$symbol',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontFamily: 'Product Sans',
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: FutureBuilder<Data>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  child: charts.TimeSeriesChart(
                    snapshot.data.seriesList,
                    animate: false,
                    primaryMeasureAxis: new charts.NumericAxisSpec(
                      tickProviderSpec: new charts.BasicNumericTickProviderSpec(
                        zeroBound: false,
                      ),
                    ),
                  ),
                  height: 400,
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.hasError}');
              }
              return CircularProgressIndicator();
            },
          ),
        ),
        backgroundColor: Colors.grey[900],
      ),
    );
  }
}
