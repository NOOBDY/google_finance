import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: W(),
        ),
      ),
    );
  }
}

class W extends StatefulWidget {
  S createState() => S();
}

class S extends State<W> {
  Widget build(BuildContext context) {
    return Text('hello');
  }
}
