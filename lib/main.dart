import 'dart:async';
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
          child: FutureWidget(
            apiKey: apiKey,
            symbol: symbol,
          ),
        ),
        backgroundColor: Color(0xff1f1f3a),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FutureWidget extends StatefulWidget {
  final String apiKey;
  final String symbol;

  FutureWidget({
    Key key,
    this.apiKey,
    this.symbol,
  }) : super(key: key);

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
            child: StockChart(
              data: snapshot.data.seriesList,
              animate: true,
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
