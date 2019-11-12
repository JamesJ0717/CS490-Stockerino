import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'stock.dart';

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
      join(databasesPath, 'stocks.db'),
      onOpen: (db) async {},
      onCreate: (db, version) async {
        var batch = db.batch();
        _createStockTable(batch);
        _createSymbolListTable(batch);
        await batch.commit(noResult: true);
      },
      version: 1,
    );
  }

  void _createStockTable(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS stocks');
    batch.execute('''
    CREATE TABLE stocks (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      name TEXT NOT NULL,
      symbol TEXT NOT NULL
    )''');
  }

  void _createSymbolListTable(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS symbolList');
    batch.execute('''
    CREATE TABLE symbolList (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      symbol TEXT NOT NULL
    )
    ''');
    makeTableForSymbols();
  }

  Future<int> insertStock(Stock stock) async {
    final Database db = await openDB();

    if (stock.symbol == '' || stock == null) {
      return 402;
    }
    await db.insert(
      'stocks',
      stock.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return 200;
  }

  Future<List<Stock>> stocks() async {
    final Database db = await openDB();

    final List<Map<String, dynamic>> maps = await db.query('stocks');

    return List.generate(maps.length, (i) {
      return Stock(maps[i]['symbol'], maps[i]['name'], maps[i]['id']);
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

    await db.execute("DELETE FROM stocks");
  }

  Future<void> makeTableForSymbols() async {
    final db = await openDB();
    int i = 0;
    return http
        .get(
            Uri.encodeFull(
                'https://cloud.iexapis.com/stable/ref-data/symbols?token=' +
                    'pk_15392fe3de7e4253a1a4941d76535000'),
            headers: {"Accept": "application/json"})
        .then((res) => jsonDecode(res.body))
        .then(
          (res) {
            for (var stock in res) {
              Stock newStock = Stock(
                  stock['symbol'].toString(), stock['name'].toString(), i++);
              db.insert('symbolList', newStock.toMap(),
                  conflictAlgorithm: ConflictAlgorithm.replace);
            }
          },
        );
  }

  Future<List<Stock>> find() async {
    final db = await openDB();
    List<Map<String, dynamic>> maps = await db.query('symbolList');
    return List.generate(maps.length, (i) {
      return Stock(maps[i]['symbol'], maps[i]['name'], i);
    });
  }
}
