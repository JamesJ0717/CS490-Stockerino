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
                "Culpa tempor velit ea id fugiat ad magna consectetur duis dolore esse minim esse. Aute qui laborum sint in aliquip excepteur non. Amet adipisicing deserunt aliqua anim velit esse sit.")
          ],
        ),
      ),
    );
  }
}
