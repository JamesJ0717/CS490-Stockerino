import 'package:flutter/material.dart';

import 'package:cs490_stock_ticker/Components/stockInfo.dart';
import 'package:cs490_stock_ticker/Components/stocksDB.dart';

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
      ),
    );
  }

  GridView build(List<Stock> stocks) {
    print(stocks);
    List<Widget> cards = [];
    for (var i = 0; i < stocks.length; i++) {
      cards.add(getStructuredGridCell(stocks[i].symbol));
    }

    return GridView.count(
      primary: true,
      padding: const EdgeInsets.all(10.0),
      crossAxisCount: 1,
      childAspectRatio: 2,
      mainAxisSpacing: 1.0,
      crossAxisSpacing: 1.0,
      children: cards,
    );
  }
}
