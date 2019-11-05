import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class StockDB {
  StockDB._();
  static final StockDB db = StockDB._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await openDB();
    return _database;
  }

  Future<Database> openDB() async {
    var databasesPath = await getDatabasesPath();

    return await openDatabase(
      join(databasesPath, 'stock_names.db'),
      onOpen: (db) {},
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE stocks(id INTEGER PRIMARY KEY AUTOINCREMENT, symbol TEXT NOT NULL); INSERT INTO stocks (id, symbol) VALUES (0, aapl);",
        );
      },
      version: 1,
    );
  }

  Future<void> insertStock(Stock stock) async {
    final Database db = await openDB();

    if (stock.symbol == '' || stock == null) {
      return;
    }
    await db.insert(
      'stocks',
      stock.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Stock>> stocks() async {
    final Database db = await openDB();

    final List<Map<String, dynamic>> maps = await db.query('stocks');

    return List.generate(maps.length, (i) {
      return Stock(
        maps[i]['symbol'],
        maps[i]['id'],
      );
    });
  }

  Future<void> deleteStock(String symbol) async {
    final db = await openDB();

    await db.delete(
      'stocks',
      where: "symbol = ?",
      whereArgs: [symbol],
    );
  }

  Future<void> removeAll() async {
    final db = await openDB();

    await db.execute("DELETE FROM stocks WHERE id IS NOT 0");
  }
}

class Stock {
  String symbol;
  int id;

  Stock(String symbol, [int id]) {
    this.symbol = symbol;
    this.id = id;
  }

  Map<String, dynamic> toMap() {
    return {'symbol': symbol, 'id': id};
  }

  @override
  String toString() {
    return '{id: $id, symbol: $symbol}';
  }
}
