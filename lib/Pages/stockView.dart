import 'package:flutter/material.dart';

import 'package:cs490_stock_ticker/Components/stockInfo.dart';
import 'package:cs490_stock_ticker/Components/stock.dart';

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
    print("GridView build " + stocks.toString());
    List<Widget> cards = [];
    if (stocks.isEmpty) {
      return GridView.count(
        crossAxisCount: 1,
        children: <Widget>[
          Center(
            child: Text(
              "Add Some Stocks...",
              style: TextStyle(fontSize: 24),
            ),
          )
        ],
      );
    } else {
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
}
