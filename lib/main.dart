import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cs490_stock_ticker/Pages/gridView.dart';
import 'package:cs490_stock_ticker/Pages/newStock.dart';
import 'package:cs490_stock_ticker/Pages/about.dart';

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

  List<String> savedStocks;
  TabController controller;

  @override
  void initState() {
    super.initState();

    saveStocks();
    loadSavedStocks();

    controller = TabController(initialIndex: 1, length: 3, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  loadSavedStocks() async {
    SharedPreferences stocks = await SharedPreferences.getInstance();
    setState(() {
      savedStocks = stocks.getStringList('stocks');
    });
  }

  saveStocks() async {
    SharedPreferences stocks = await SharedPreferences.getInstance();

    stocks.setStringList('stocks', [
      "FB",
      "TWTR",
      "AAPL",
      "AMZN",
      "GE",
      "DNKN",
      "TSLA",
      "DIS",
      "SBUX",
      "NKE",
    ]);
  }

  @override
  Widget build(BuildContext context) {
    saveStocks();
    return Scaffold(
      body: TabBarView(
        children: <Widget>[
          addNewStockTab.build(),
          myGridView.build(savedStocks),
          aboutPage.build()
        ],
        controller: controller,
      ),
      appBar: AppBar(
        title: Text("Stockerino"),
      ),
      bottomNavigationBar: Material(
        color: Colors.blue,
        child: TabBar(
          tabs: <Tab>[
            Tab(icon: Icon(Icons.add_circle_outline)),
            Tab(icon: Icon(Icons.home)),
            Tab(icon: Icon(Icons.info_outline))
            // Tab(icon: Icon(Icons.info_outline))
          ],
          controller: controller,
        ),
      ),
    );
  }
}
