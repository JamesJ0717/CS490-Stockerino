import 'package:flutter/material.dart';

import 'package:cs490_stock_ticker/Pages/stockView.dart';
import 'package:cs490_stock_ticker/Pages/about.dart';
import 'package:cs490_stock_ticker/Pages/cryptoPage.dart';

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

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  final StockPage stockPage = StockPage();
  final About aboutPage = About();
  final CryptoPage cryptoPage = CryptoPage();

  TabController controller;
  TextEditingController newStock;

  @override
  void initState() {
    newStock = new TextEditingController();
    controller = TabController(length: 3, initialIndex: 1, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        children: <Widget>[cryptoPage, stockPage, aboutPage.build(context)],
        controller: controller,
      ),
      appBar: AppBar(
        title: Text("Stockerino"),
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
