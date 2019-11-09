import 'package:flutter/material.dart';
import 'stock.dart';
import 'stocksDB.dart';

class StockAPI extends SearchDelegate<String> {
  String symbol = "";
  String companyName = "";
  int id = 0;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: StockDB.db.insertStock(Stock(symbol, companyName, id)),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            close(context, ConnectionState.done.toString());
            return Container();
          default:
            return CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Stock>>(
      future: StockDB.db.find(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            List<Stock> myList = [];
            snapshot.data.forEach(
              (Stock s) {
                if (s.name.toLowerCase().contains(query.toLowerCase())) {
                  myList.add(s);
                }
              },
            );
            print(myList);
            return ListView.builder(
              itemBuilder: (context, index) => ListTile(
                leading: Icon(Icons.add_to_photos),
                title: Text(myList[index].name),
                onTap: () {
                  symbol = myList[index].symbol;
                  companyName = myList[index].name;
                  id = myList[index].id;
                  showResults(context);
                },
              ),
              itemCount: myList.length,
            );
          default:
            print(snapshot.connectionState.toString());
            return Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
