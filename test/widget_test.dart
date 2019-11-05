// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cs490_stock_ticker/main.dart';

void main() {
  testWidgets('Load drawer', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // expect(find.byWidget(), findsOneWidget);
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pump();
    expect(find.text("Menu"), findsOneWidget);
  });
}
