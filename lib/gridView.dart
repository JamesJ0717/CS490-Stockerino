import 'package:flutter/material.dart';

import 'package:cs490_stock_ticker/stockInfo.dart';

class MyGridView {
  StockInfo myStocks = StockInfo();

  Card getStructuredGridCell(name) {
    return Card(
        elevation: 1.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            Center(child: myStocks.getStockInfo(name)),
          ],
        ));
  }

  GridView build() {
    return GridView.count(
      primary: true,
      padding: const EdgeInsets.all(1.0),
      crossAxisCount: 2,
      childAspectRatio: 0.85,
      mainAxisSpacing: 1.0,
      crossAxisSpacing: 1.0,
      children: <Widget>[
        getStructuredGridCell("FB"),
        getStructuredGridCell("TWTR"),
        getStructuredGridCell("AAPL"),
        getStructuredGridCell("AMZN"),
        getStructuredGridCell("GE"),
        getStructuredGridCell("DNKN"),
      ],
    );
  }
}
