import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';

class About {
  Future<String> readContents() async {
    return await rootBundle.loadString('assets/README.md');
  }

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: FutureBuilder<String>(
        future: readContents(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 75),
                child: Markdown(
                  data: snapshot.data,
                ),
              );
            case ConnectionState.active:
              return CircularProgressIndicator();
            default:
              return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
