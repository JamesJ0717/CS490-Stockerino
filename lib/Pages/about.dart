import 'package:flutter/material.dart';

class About {
  List<String> stocks;

  Widget build() {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "About This",
                  style: TextStyle(fontSize: 36),
                )
              ],
            ),
            Text(
                "Pariatur adipisicing veniam laboris ullamco ex esse adipisicing ad.")
          ],
        ),
      ),
    );
  }
}
