import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:cs490_stock_ticker/Pages/stockView.dart';
import 'package:cs490_stock_ticker/Pages/newStock.dart';
import 'package:cs490_stock_ticker/Pages/about.dart';
import 'package:cs490_stock_ticker/stocksDB.dart';

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

  TabController controller;
  TextEditingController newStock;
  Stock stock;

  @override
  void initState() {
    newStock = new TextEditingController();
    super.initState();
    controller = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  void onRefresh() async {
    // monitor network fetch
    setState(() {});
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    // monitor network fetch
    refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Stock>>(
          future: StockDB.db.stocks(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return TabBarView(
              children: <Widget>[
                SmartRefresher(
                  controller: refreshController,
                  onRefresh: onRefresh,
                  onLoading: onLoading,
                  enablePullUp: false,
                  header: MaterialClassicHeader(),
                  child: myGridView.build(snapshot.data),
                )
              ],
              controller: controller,
            );
          }),
      appBar: AppBar(
        title: Text("Stockerino"),
      ),
      bottomNavigationBar: Material(
        color: ThemeData.dark().bottomAppBarColor,
        child: TabBar(
          tabs: <Tab>[
            Tab(icon: Icon(Icons.home)),
          ],
          controller: controller,
        ),
      ),
      endDrawer: buildDrawer(),
    );
  }

  Drawer buildDrawer() {
    final _formKey = new GlobalKey<FormState>();
    addNewStock() {
      StockDB.db.insertStock(stock);
    }

    removeStock() {
      StockDB.db.deleteStock(stock.symbol);
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 36),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              )),
          //Add new stock
          FlatButton(
            padding: EdgeInsets.all(10.0),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text('Add New Stock'),
                          TextFormField(
                            decoration: new InputDecoration(
                                hintText: "Enter Stock's Symbol"),
                            controller: newStock,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FlatButton(
                                onPressed: () {
                                  if (newStock.text != "") {
                                    setState(() {
                                      this.stock = Stock(newStock.text);
                                      addNewStock();
                                    });
                                    newStock.clear();
                                    Navigator.pop(context);
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Text(
                                              "Please enter a symbol...",
                                              style: TextStyle(fontSize: 24),
                                              textAlign: TextAlign.center,
                                            ),
                                          );
                                        });
                                  }
                                },
                                child: Text('Submit')),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Text(
              'Add A New Stock',
              style: TextStyle(fontSize: 24),
            ),
            color: Colors.grey,
          ),
          //Delete stock
          FlatButton(
            padding: EdgeInsets.all(10.0),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text('Remove a Stock'),
                          TextFormField(
                            decoration: new InputDecoration(
                                hintText: "Enter Stock's Symbol"),
                            controller: newStock,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    this.stock = Stock(newStock.text);
                                    removeStock();
                                  });
                                  newStock.clear();
                                  Navigator.pop(context);
                                },
                                child: Text('Submit')),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Text(
              'Remove A Stock',
              style: TextStyle(fontSize: 24),
            ),
            color: Colors.grey,
          ),
          //Delete all stocks
          FlatButton(
            padding: EdgeInsets.all(10.0),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text('Are You Sure?'),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    StockDB.db.removeAll();
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text('Submit')),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Text(
              'Remove All Stocks',
              style: TextStyle(fontSize: 24),
            ),
            color: Colors.red,
          )
        ],
      ),
    );
  }
}
