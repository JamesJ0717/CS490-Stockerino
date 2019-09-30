import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Stock {
  Future<Database> newDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'stock_names.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE stocks(id INTEGER PRIMARY KEY, symbol TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertStock(Stock stock) async {
    final Database db = await database;

    await db.insert(
      'stocks',
      stock.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Stock>> stocks() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('stocks');

    return List.generate(maps.length, (i) {
      return Stock(
        id: maps[i]['id'],
        symbol: maps[i]['symbol'],
      );
    });
  }

  Future<void> deleteStock(int id) async {
    final db = await database;

    await db.delete(
      'stocks',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  final int id;
  final String symbol;

  Stock({this.id, this.symbol});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'symbol': symbol,
    };
  }

  @override
  String toString() {
    return 'Stock{id: $id, symbol: $symbol}';
  }
}
