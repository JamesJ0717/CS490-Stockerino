import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:cs490_stock_ticker/Components/Stocks/Stock.dart';
import 'package:cs490_stock_ticker/Components/Stocks/StockDB.dart';
import 'package:cs490_stock_ticker/Components/Stocks/StockSearch.dart';

class StockPage extends StatefulWidget {
  StockPage({Key key}) : super(key: key);

  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    setState(() {});
    refreshController.refreshCompleted();
  }

  void _onLoading() async {
    refreshController.loadComplete();
  }

  Card getStructuredGridCell(name) {
    return Card(
      // color: Colors.white70,
      // elevation: 1.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Center(child: getStockInfo(name)),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return FutureBuilder<List<Stock>>(
      future: StockDB.db.stocks(),
      builder: (BuildContext context, AsyncSnapshot<List<Stock>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            List<Widget> cards = [];
            List<Stock> stocks = snapshot.data;
            // print("GridView build " + stocks.toString());
            if (stocks.isEmpty) {
              return Scaffold(
                appBar: AppBar(
                  title: Text("Stocks"),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.restore_from_trash),
                      onPressed: () {
                        setState(() {
                          StockDB.db.removeAll();
                        });
                      },
                    )
                  ],
                ),
                body: GridView.count(
                  crossAxisCount: 1,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "Add Some Stocks...",
                        style: TextStyle(fontSize: 24),
                      ),
                    )
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  heroTag: "emptyList",
                  key: Key("EmptyStocks"),
                  child: Icon(Icons.add_circle_outline),
                  onPressed: () =>
                      showSearch(context: context, delegate: StockSearch()),
                ),
              );
            } else {
              for (var i = 0; i < stocks.length; i++) {
                cards.add(getStructuredGridCell(stocks[i].symbol));
              }

              return Scaffold(
                appBar: AppBar(
                  title: Text("Stocks"),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.restore_from_trash),
                      onPressed: () {
                        setState(() {
                          StockDB.db.removeAll();
                        });
                      },
                    )
                  ],
                ),
                body: SmartRefresher(
                  controller: refreshController,
                  onLoading: _onLoading,
                  onRefresh: _onRefresh,
                  child: GridView.count(
                    primary: true,
                    padding: const EdgeInsets.all(10.0),
                    crossAxisCount: 1,
                    childAspectRatio: 2,
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 1.0,
                    children: cards,
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  heroTag: "list",
                  child: Icon(Icons.add_circle_outline),
                  onPressed: () =>
                      showSearch(context: context, delegate: StockSearch()),
                ),
              );
            }
            break;
          default:
            return Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }

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
          Expanded(
            flex: 1,
            child: Text(
              'There was an error retrieving the data...',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
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
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            FloatingActionButton(
              heroTag: "remove" + info.symbol,
              mini: true,
              onPressed: () {
                StockDB.db.deleteStock(info.symbol.toLowerCase());
                setState(() {});
              },
              child: Icon(
                Icons.remove_circle_outline,
                color: ThemeData.light().accentIconTheme.color,
              ),
            )
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
      child: FutureBuilder<StockData>(
        future: getStockData(name),
        builder: (BuildContext context, AsyncSnapshot<StockData> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return makeCard(snapshot.data);
            case ConnectionState.active:
              return Center(
                  child: Row(children: <Widget>[CircularProgressIndicator()]));
            default:
              return Center(
                  child: Row(children: <Widget>[CircularProgressIndicator()]));
          }
        },
      ),
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
    );
  }
}
