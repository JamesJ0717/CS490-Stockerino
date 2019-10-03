import 'package:flutter/material.dart';

import 'package:cs490_stock_ticker/stockInfo.dart';
import 'package:cs490_stock_ticker/stocksDB.dart';

class MyGridView {
  StockInfo myStocks = StockInfo();

  Card getStructuredGridCell(name) {
    return Card(
        elevation: 1.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            Center(child: myStocks.getStockInfo(name)),
          ],
        ));
  }

  GridView build(List<Stock> stocks) {
    List<Widget> cards = [];
    // print(stocks);
    stocks.forEach((stock) => cards.add(getStructuredGridCell(stock.symbol)));
    return GridView.count(
        primary: true,
        padding: const EdgeInsets.all(10.0),
        crossAxisCount: 1,
        childAspectRatio: 2,
        mainAxisSpacing: 1.0,
        crossAxisSpacing: 1.0,
        children: cards);
  }
}
