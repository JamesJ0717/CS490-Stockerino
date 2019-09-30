import 'package:flutter/material.dart';

import 'package:cs490_stock_ticker/stockNameDB.dart';

class NewStock {
  List<String> stocks;

  final database = Stock;
  db = database.newDatabase();

  Widget build() {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Add New Stock Page",
                  style: TextStyle(fontSize: 36),
                )
              ],
            ),
            Text(
                "Proident irure consequat ipsum esse ullamco laborum sint magna consectetur.")
          ],
        ),
      ),
    );
  }
}