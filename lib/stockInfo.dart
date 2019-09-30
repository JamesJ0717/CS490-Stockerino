import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cs490_stock_ticker/repsponseData.dart';

class StockInfo {
  Column data;
  var responseBody, response;

  Future<ResponseData> getStockData(String symbol) async {
    String uri = 'https://cloud.iexapis.com/stable/stock/' +
        symbol +
        '/quote?token=pk_15392fe3de7e4253a1a4941d76535000';
    response = await http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
    return ResponseData.fromJson(json.decode(response.body));
  }

  Column makeCard(ResponseData info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              info.companyName,
              style: TextStyle(fontSize: 24),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              info.symbol,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              info.current,
              style: TextStyle(fontSize: 22),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Text(info.dollarChange),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Text(info.percentChange),
            )
          ],
        )
      ],
    );
  }

  Container getStockInfo(name) {
    return Container(
      child: Container(
        child: FutureBuilder<ResponseData>(
            future: getStockData(name),
            builder:
                (BuildContext context, AsyncSnapshot<ResponseData> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                case ConnectionState.done:
                  return makeCard(snapshot.data);
                default:
                  return CircularProgressIndicator();
              }
            }),
        padding: const EdgeInsets.all(15.0),
      ),
    );
  }
}
