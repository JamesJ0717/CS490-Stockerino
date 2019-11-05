import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:cs490_stock_ticker/Pages/stockView.dart';
import 'package:cs490_stock_ticker/Pages/newStock.dart';
import 'package:cs490_stock_ticker/Pages/about.dart';
import 'package:cs490_stock_ticker/Pages/cryptoPage.dart';
import 'package:cs490_stock_ticker/Components/stocksDB.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
    title: 'Stockerino',
    theme: ThemeData.dark(),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  final MyGridView myGridView = MyGridView();
  final NewStock addNewStockTab = NewStock();
  final About aboutPage = About();
  final CryptoPage cryptoPage = CryptoPage();

  TabController controller;
  TextEditingController newStock;
  Stock stock;

  @override
  void initState() {
    newStock = new TextEditingController();
    super.initState();
    controller = TabController(length: 3, initialIndex: 1, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    setState(() {});
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    refreshController.loadComplete();
  }

  final _formKey = new GlobalKey<FormState>();
  addNewStock() {
    StockDB.db.insertStock(stock);
  }

  removeStock() {
    StockDB.db.deleteStock(stock.symbol);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Stock>>(
        future: StockDB.db.stocks(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TabBarView(
            children: <Widget>[
              cryptoPage.build(context),
              SmartRefresher(
                controller: refreshController,
                onRefresh: onRefresh,
                onLoading: onLoading,
                enablePullUp: false,
                child: myGridView.build(snapshot.data),
              ),
              aboutPage.build(context)
            ],
            controller: controller,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_circle),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Add New Stock'),
                  TextFormField(
                    decoration:
                        new InputDecoration(hintText: "Enter Stock's Symbol"),
                    controller: newStock,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                        onPressed: () {
                          setState(
                            () {
                              this.stock = Stock(newStock.text);
                              addNewStock();
                            },
                          );
                          newStock.clear();
                          Navigator.pop(context);
                        },
                        child: Text('Submit')),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text("Stockerino"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.restore_from_trash),
            onPressed: () => this.setState(() {
              StockDB.db.removeAll();
            }),
          )
        ],
      ),
      bottomNavigationBar: Material(
        color: ThemeData.dark().primaryColor,
        child: TabBar(
          tabs: <Tab>[
            Tab(icon: Icon(Icons.account_balance)),
            Tab(icon: Icon(Icons.home)),
            Tab(icon: Icon(Icons.info_outline))
          ],
          controller: controller,
        ),
      ),
    );
  }
}
