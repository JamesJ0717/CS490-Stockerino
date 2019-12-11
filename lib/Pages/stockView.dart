import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:cs490_stock_ticker/Components/Stocks/Stock.dart';
import 'package:cs490_stock_ticker/Components/Stocks/StockDB.dart';
import 'package:cs490_stock_ticker/Components/Stocks/StockSearch.dart';
import 'package:cs490_stock_ticker/Components/DetailView.dart';

class StockPage extends StatefulWidget {
  StockPage({Key key}) : super(key: key);

  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  bool edit = false;

  void _onRefresh() async {
    setState(() {});
    refreshController.refreshCompleted();
  }

  void _onLoading() async {
    refreshController.loadComplete();
  }

  StockData info = new StockData();
  DetailView details = new DetailView();

  Card getStructuredGridCell(String name) {
    return Card(
      // color: Colors.white70,
      // elevation: 1.5,
      // child: FlatButton(
      //   onPressed: () => showDialog(
      //       context: context,
      //       builder: (context) => details.build(context, this.info)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Center(child: getStockInfo(name)),
        ],
      ),
      // ),
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
                  leading: Container(
                    child: FlatButton(
                      child: Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          this.edit = !this.edit;
                        });
                      },
                    ),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.restore_from_trash),
                      onPressed: () {
                        setState(() {
                          StockDB.db.removeAll();
                        });
                      },
                    ),
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
                    childAspectRatio: 3,
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
    String uri =
        'https://cloud.iexapis.com/stable/stock/$symbol/quote?token=pk_15392fe3de7e4253a1a4941d76535000';
    return http.get(Uri.encodeFull(uri),
        headers: {"Accept": "application/json"}).then((response) {
      return this.info = StockData.fromJson(json.decode(response.body));
    }).catchError((err) {
      return StockData.error(symbol);
    });
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
              Text(
                'There was an error retrieving the data...',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              Visibility(
                visible: this.edit,
                child: FloatingActionButton(
                  heroTag: "error $info",
                  mini: true,
                  onPressed: () {
                    StockDB.db.deleteStock(info.symbol.toLowerCase());
                    setState(() {});
                  },
                  child: Icon(
                    Icons.remove_circle_outline,
                    color: ThemeData.light().accentIconTheme.color,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
    Color current = (!info.change.isNegative) ? Colors.green : Colors.red;
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
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            Visibility(
              visible: this.edit,
              child: FloatingActionButton(
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
              ),
            ),
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
                ("\$" + info.latestPrice.toStringAsFixed(2)),
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
                "\$" + info.change.toString(),
                style: TextStyle(fontSize: 18, color: current),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
              child: Text(
                info.changePercent.toStringAsFixed(2) + "%",
                style: (TextStyle(fontSize: 18, color: current)),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Card getStockInfo(name) {
    return Card(
      elevation: 0,
      child: FutureBuilder<dynamic>(
        future: getStockData(name),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return makeCard(snapshot.data);
            case ConnectionState.active:
            default:
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
