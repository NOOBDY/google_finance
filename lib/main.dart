import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'future.dart';

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
          child: SizedBox(
            child: Container(
              child: FutureWidget(
                apiKey: apiKey,
                symbol: symbol,
              ),
              decoration: new BoxDecoration(
                color: Color(0xff0b0b19),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
            ),
            width: 350,
            height: 350,
          ),
        ),
        backgroundColor: Color(0xff1f1f3a),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
