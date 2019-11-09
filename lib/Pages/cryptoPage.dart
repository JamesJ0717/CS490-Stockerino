import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CryptoPage {
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 1,
      children: <Widget>[
        Center(
          child: Text(
            "Crypto Coming ;)",
            style: TextStyle(fontSize: 24),
          ),
        )
      ],
    );
  }
}
