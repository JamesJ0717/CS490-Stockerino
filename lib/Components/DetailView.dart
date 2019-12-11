import 'package:cs490_stock_ticker/Components/Stocks/Stock.dart';
import 'package:flutter/material.dart';

class DetailView {
  Widget build(BuildContext context, StockData item) {
    return Dialog(
      child: Card(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  item.companyName.toString(),
                  style: TextStyle(fontSize: 28),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  item.symbol.toString(),
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  item.latestPrice.toString(),
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
                  child: Text(
                    "\$" + item.change.toString(),
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
                  child: Text(
                    item.changePercent.toStringAsFixed(2) + "%",
                    style: (TextStyle(fontSize: 18)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
