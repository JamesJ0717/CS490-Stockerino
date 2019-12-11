import 'package:cs490_stock_ticker/Components/Crypto/CryptoDB.dart';
import 'package:cs490_stock_ticker/Components/Crypto/CryptoSearch.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:cs490_stock_ticker/Components/Crypto/Crypto.dart';

class CryptoPage extends StatefulWidget {
  CryptoPage({Key key}) : super(key: key);

  @override
  _CryptoPageState createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
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

  Widget build(BuildContext context) {
    return FutureBuilder<List<Crypto>>(
        future: CryptoDB.db.stocks(),
        builder: (BuildContext context, AsyncSnapshot<List<Crypto>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              List<Widget> cards = [];
              List<Crypto> cryptos = snapshot.data;

              if (cryptos.isEmpty) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Crypto"),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.restore_from_trash),
                        onPressed: () {
                          setState(() {
                            CryptoDB.db.removeAll();
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
                          "Add Some Cryptos...",
                          style: TextStyle(fontSize: 24),
                        ),
                      )
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    heroTag: "empty",
                    child: Icon(Icons.add_circle_outline),
                    onPressed: () =>
                        showSearch(context: context, delegate: CryptoSearch()),
                  ),
                );
              } else {
                for (Crypto crypto in cryptos) {
                  cards.add(getCryptoInfo(crypto));
                }
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Crypto"),
                    leading: FlatButton(
                      child: Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          this.edit = !this.edit;
                        });
                      },
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.restore_from_trash),
                        onPressed: () {
                          setState(() {
                            CryptoDB.db.removeAll();
                          });
                        },
                      )
                    ],
                  ),
                  body: SmartRefresher(
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    enablePullUp: false,
                    controller: refreshController,
                    child: GridView.count(
                      primary: true,
                      padding: const EdgeInsets.all(10.0),
                      crossAxisCount: 1,
                      mainAxisSpacing: 1.0,
                      crossAxisSpacing: 1.0,
                      childAspectRatio: 3,
                      children: cards,
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    heroTag: "list",
                    child: Icon(Icons.add_circle_outline),
                    onPressed: () =>
                        showSearch(context: context, delegate: CryptoSearch()),
                  ),
                );
              }
              break;
            default:
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        });
  }

  Card getCryptoInfo(Crypto crypto) {
    return Card(
      child: FutureBuilder<CryptoData>(
        future: getInfo(crypto.symbol.toUpperCase()),
        builder: (BuildContext context, AsyncSnapshot<CryptoData> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return makeCard(snapshot.data);
            case ConnectionState.active:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }

  Column makeCard(CryptoData data) {
    if (data.error)
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Error",
              style: TextStyle(fontSize: 26),
            ),
          ]);
    else {
      Color change =
          data.quotePercentChange_1h.isNegative ? Colors.red : Colors.green;
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  data.name.toString(),
                  style: TextStyle(fontSize: 28),
                  textAlign: TextAlign.center,
                ),
              ),
              Visibility(
                visible: this.edit,
                child: FloatingActionButton(
                  heroTag: "error $data",
                  mini: true,
                  onPressed: () {
                    CryptoDB.db.deleteStock(data.symbol.toLowerCase());
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
          Text(
            data.symbol.toString(),
            style: TextStyle(fontSize: 24),
          ),
          Text(
            "\$" + data.quotePrice.toString(),
            style: TextStyle(fontSize: 20, color: change),
          ),
          Text(
            data.quotePercentChange_1h.toString() + "%",
            style: TextStyle(fontSize: 20, color: change),
          ),
        ],
      );
    }
  }

  Future<CryptoData> getInfo(String name) {
    String uri =
        "https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=$name";
    return http
        .get(Uri.encodeFull(uri), headers: {
          "Accept": "application/json",
          "X-CMC_PRO_API_KEY": "a840b330-c7ae-40c8-b319-307f108f8eaf"
        })
        .then((response) =>
            CryptoData.fromJson(json.decode(response.body), name.toUpperCase()))
        .catchError((err) => CryptoData.error());
  }
}
