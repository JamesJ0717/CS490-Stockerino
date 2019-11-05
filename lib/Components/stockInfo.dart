import 'package:cs490_stock_ticker/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'stockData.dart';
// import 'stocksDB.dart';

class StockInfo extends State<MyApp> {
  Column data;
  var responseBody, response;

  Future<StockData> getStockData(String symbol) {
    String uri = 'https://cloud.iexapis.com/stable/stock/' +
        symbol +
        '/quote?token=pk_15392fe3de7e4253a1a4941d76535000';
    return http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"})
        .then((response) => StockData.fromJson(json.decode(response.body)))
        .catchError((err) => StockData.error());
  }

  Column makeCard(StockData info) {
    if (info.error) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  'There was an error retrieving the data...',
                  style: TextStyle(fontSize: 26),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
        ],
      );
    }
    Color current = (!info.dollarChange.isNegative) ? Colors.green : Colors.red;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(
                info.companyName,
                style: TextStyle(fontSize: 36),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            // IconButton(
            //     padding: EdgeInsets.all(0),
            //     icon: Icon(Icons.remove_circle),
            //     onPressed: () {
            //       this.setState(
            //         () {
            //           StockDB.db.deleteStock(info.symbol.toLowerCase());
            //         },
            //       );
            //       Navigator.pop(context);
            //     })
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                info.symbol,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                ("\$" + info.current.toStringAsFixed(2)),
                style: TextStyle(fontSize: 22, color: current),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
              child: Text(
                "\$" + info.dollarChange.toString(),
                style: TextStyle(fontSize: 18, color: current),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
              child: Text(
                info.percentChange.toStringAsFixed(2) + "%",
                style: (TextStyle(fontSize: 18, color: current)),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Container getStockInfo(name) {
    return Container(
      child: Container(
        child: FutureBuilder<StockData>(
          future: getStockData(name),
          builder: (BuildContext context, AsyncSnapshot<StockData> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return makeCard(snapshot.data);
              case ConnectionState.active:
                return CircularProgressIndicator();
              default:
                return CircularProgressIndicator();
            }
          },
        ),
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }
}
