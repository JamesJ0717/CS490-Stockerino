import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StockInfo {
  Column data;
  var responseBody, response;

  String getSymbol(stock, name) {
    String symbol;
    // print(stock + "\t" + name);
    // print(stock == name);
    symbol = ((stock == name) ? stock.toString().toUpperCase() : "AAPL");
    return symbol;
  }

  getStockData(symbol) async {
    String uri = 'https://cloud.iexapis.com/stable/stock/' +
        symbol +
        '/quote?token=pk_15392fe3de7e4253a1a4941d76535000';
    http.Response response = await http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
    data = makeCard(json.decode(response.body));
    return;
  }

  Column makeCard(Map info) {
    print(info['symbol']);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(info['companyName'].toString()),
        Text("Symbol: " + info['symbol'].toString()),
        Text("Daily High: " + info['high'].toString()),
        Text("Daily Low: " + info['low'].toString()),
        Text("Latest Price: " + info['latestPrice'].toString()),
      ],
    );
  }

  Container getStockInfo(name) {
    getStockData(name);
    return Container(
      child: Container(
        child: data,
        // added padding
        padding: const EdgeInsets.all(15.0),
      ),
    );
  }
}
