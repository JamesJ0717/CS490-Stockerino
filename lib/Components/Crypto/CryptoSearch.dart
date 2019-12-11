import 'package:flutter/material.dart';

import 'Crypto.dart';
import 'CryptoDB.dart';

class CryptoSearch extends SearchDelegate<String> {
  String symbol;
  String name;

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData.light();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    CryptoDB.db
        .insertCrypto(Crypto(symbol, name))
        .then((res) => close(context, res.toString()));
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // print(query);
    return FutureBuilder<List<Crypto>>(
      future: CryptoDB.db.find(),
      builder: (BuildContext context, AsyncSnapshot<List<Crypto>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            List<Crypto> myList = [];
            snapshot.data.forEach(
              (Crypto s) {
                if (s.name.toLowerCase().contains(query.toLowerCase())) {
                  myList.add(s);
                }
              },
            );
            // print(myList);
            return ListView.builder(
              itemBuilder: (context, index) => ListTile(
                leading: Icon(Icons.add_to_photos),
                title: Text(myList[index].name),
                onTap: () {
                  symbol = myList[index].symbol.toLowerCase();
                  name = myList[index].name;
                  showResults(context);
                },
              ),
              itemCount: myList.length,
            );
          default:
            // print(snapshot.connectionState.toString());
            return Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
