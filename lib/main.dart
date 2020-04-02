import 'dart:async';
import 'dart:collection';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data.dart';

String apiKey = 'TT1KDKHC0BDTBO6A';
String symbol = 'ZM';

void main() => runApp(App());

class App extends StatelessWidget {
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
          child: FutureWidget(),
        ),
        backgroundColor: Color(0xff1f1f3a),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FutureWidget extends StatefulWidget {
  FutureWidget({Key key}) : super(key: key);

  @override
  FutureState createState() => FutureState(fetchData(apiKey, symbol));
}

class FutureState extends State<FutureWidget> {
  Future<Data> futureData;

  FutureState(this.futureData);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Data>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            child: charts.TimeSeriesChart(
              snapshot.data.seriesList,
              animate: false,
              primaryMeasureAxis: new charts.NumericAxisSpec(
                tickProviderSpec: new charts.StaticNumericTickProviderSpec(
                  <charts.TickSpec<num>>[
                    charts.TickSpec(0, label: ''),
                    charts.TickSpec(1, label: ''),
                  ],
                ),
              ),
              disjointMeasureAxes:
                  new LinkedHashMap<String, charts.NumericAxisSpec>.from({
                'axis 1': new charts.NumericAxisSpec(),
                'axis 2': new charts.NumericAxisSpec(),
              }),
            ),
            height: 400,
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.hasError}');
        }
        return CircularProgressIndicator(
          backgroundColor: Colors.white,
        );
      },
    );
  }
}
