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
    return Scaffold(
      body: FutureBuilder<String>(
        future: readContents(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Container(
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
