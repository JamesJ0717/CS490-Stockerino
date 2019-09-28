import 'package:flutter/material.dart';
import 'package:cs490_stock_ticker/gridView.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final MyGridView myGridView = MyGridView();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Stockerino'),
          ),
          body: myGridView.build(),
        ));
  }
}
