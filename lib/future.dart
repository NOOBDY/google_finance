import 'package:flutter/material.dart';
import 'data.dart';

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
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xff48487c)),
          backgroundColor: Colors.transparent,
        );
      },
    );
  }
}
