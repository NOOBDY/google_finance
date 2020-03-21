import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';
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

class Data {
  List<charts.Series<dynamic, DateTime>> seriesList;

  Data({
    this.seriesList,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    Map data = json['Time Series (Daily)'];

    List<ChartData> open = List();
    List<ChartData> high = List();
    List<ChartData> low = List();
    List<ChartData> close = List();

    int counter = 0;

    data.forEach(
      (key, value) {
        if (counter < 20) {
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
          high.add(
            new ChartData(
              new DateTime(
                int.parse(key.substring(0, 4)),
                int.parse(key.substring(5, 7)),
                int.parse(key.substring(8)),
              ),
              double.parse(value['2. high']),
            ),
          );
          low.add(
            new ChartData(
              new DateTime(
                int.parse(key.substring(0, 4)),
                int.parse(key.substring(5, 7)),
                int.parse(key.substring(8)),
              ),
              double.parse(value['3. low']),
            ),
          );
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
          counter++;
        }
      },
    );
    return new Data(
      seriesList: [
        charts.Series<ChartData, DateTime>(
          id: 'open',
          domainFn: (ChartData data, _) => data.time,
          measureFn: (ChartData data, _) => data.val,
          data: open,
        ),
        charts.Series<ChartData, DateTime>(
          id: 'high',
          domainFn: (ChartData data, _) => data.time,
          measureFn: (ChartData data, _) => data.val,
          data: high,
        ),
        charts.Series<ChartData, DateTime>(
          id: 'low',
          domainFn: (ChartData data, _) => data.time,
          measureFn: (ChartData data, _) => data.val,
          data: low,
        ),
        charts.Series<ChartData, DateTime>(
          id: 'close',
          domainFn: (ChartData data, _) => data.time,
          measureFn: (ChartData data, _) => data.val,
          data: close,
        ),
      ],
    );
  }
}

class ChartData {
  final DateTime time;
  final double val;

  ChartData(this.time, this.val);
}
