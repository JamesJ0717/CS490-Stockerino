// import 'package:flutter/material.dart';
// import 'package:cs490_stock_ticker/main.dart';
// import 'package:cs490_stock_ticker/stocksDB.dart';

// Drawer buildDrawer() {
//     final _formKey = new GlobalKey<FormState>();
//     addNewStock() {
//       StockDB.db.insertStock(stock);
//     }

//     removeStock() {
//       StockDB.db.deleteStock(stock.symbol);
//     }

//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           DrawerHeader(
//               child: Text(
//                 'Menu',
//                 style: TextStyle(fontSize: 36),
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               )),
//           FlatButton(
//             padding: EdgeInsets.all(10.0),
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) {
//                   return AlertDialog(
//                     content: Form(
//                       key: _formKey,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           Text('Add New Stock'),
//                           TextFormField(
//                             decoration: new InputDecoration(
//                                 hintText: "Enter Stock's Symbol"),
//                             controller: newStock,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: FlatButton(
//                                 onPressed: () {
//                                   if (newStock != null) {
//                                     setState(() {
//                                       this.stock = Stock(newStock.text);
//                                       addNewStock();
//                                     });
//                                     newStock.clear();
//                                     Navigator.pop(context);
//                                   } else {
//                                     newStock.text = "Please enter a symbol";
//                                   }
//                                 },
//                                 child: Text('Submit')),
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//             child: Text(
//               'Add A New Stock',
//               style: TextStyle(fontSize: 24),
//             ),
//             color: Colors.grey,
//           ),
//           FlatButton(
//             padding: EdgeInsets.all(10.0),
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) {
//                   return AlertDialog(
//                     content: Form(
//                       key: _formKey,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           Text('Remove a Stock'),
//                           TextFormField(
//                             decoration: new InputDecoration(
//                                 hintText: "Enter Stock's Symbol"),
//                             controller: newStock,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: FlatButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     this.stock = Stock(newStock.text);
//                                     removeStock();
//                                   });
//                                   newStock.clear();
//                                   Navigator.pop(context);
//                                 },
//                                 child: Text('Submit')),
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//             child: Text(
//               'Remove A Stock',
//               style: TextStyle(fontSize: 24),
//             ),
//             color: Colors.grey,
//           ),
//           FlatButton(
//             padding: EdgeInsets.all(10.0),
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) {
//                   return AlertDialog(
//                     content: Form(
//                       key: _formKey,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           Text('Are You Sure?'),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: FlatButton(
//                                 onPressed: () {
//                                   StockDB.db.removeAll();
//                                   Navigator.pop(context);
//                                 },
//                                 child: Text('Submit')),
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//             child: Text(
//               'Remove All Stocks',
//               style: TextStyle(fontSize: 24),
//             ),
//             color: Colors.red,
//           )
//         ],
//       ),
//     );
