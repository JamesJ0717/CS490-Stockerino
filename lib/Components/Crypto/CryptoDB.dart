import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Crypto.dart';

class CryptoDB {
  CryptoDB._();
  static final CryptoDB db = CryptoDB._();

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
      join(databasesPath, 'crypto.db'),
      onOpen: (db) async {},
      onCreate: (db, version) async {
        var batch = db.batch();
        _createCryptoTable(batch);
        _createcryptoListTable(batch);
        await batch.commit(noResult: true);
      },
      version: 1,
    );
  }

  void _createCryptoTable(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS crypto');
    batch.execute('''
    CREATE TABLE crypto (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      name TEXT NOT NULL,
      symbol TEXT NOT NULL
    )''');
  }

  void _createcryptoListTable(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS cryptoList');
    batch.execute('''
    CREATE TABLE cryptoList (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      symbol TEXT NOT NULL
    )
    ''');
    makeTableForSymbols();
  }

  Future<int> insertCrypto(Crypto crypto) async {
    final Database db = await openDB();

    if (crypto.symbol == '' || crypto == null) {
      return 402;
    }
    await db.insert(
      'crypto',
      crypto.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return 200;
  }

  Future<List<Crypto>> stocks() async {
    final Database db = await openDB();

    final List<Map<String, dynamic>> maps = await db.query('crypto');

    return List.generate(maps.length, (i) {
      return Crypto(maps[i]['symbol'], maps[i]['name']);
    });
  }

  Future<void> deleteStock(String symbol) async {
    final db = await openDB();

    await db.delete(
      'crypto',
      where: "symbol = ?",
      whereArgs: [symbol],
    );
  }

  Future<void> removeAll() async {
    final db = await openDB();

    await db.execute("DELETE FROM crypto");
  }

  Future<void> makeTableForSymbols() async {
    final db = await openDB();
    String uri = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/map';
    return http
        .get(
          Uri.encodeFull(uri),
          headers: {
            "Accept": "application/json",
            "X-CMC_PRO_API_KEY": "a840b330-c7ae-40c8-b319-307f108f8eaf"
          },
        )
        .then((res) => jsonDecode(res.body)['data'])
        .then(
          (res) {
            for (var crypto in res) {
              Crypto newCrypto = Crypto(crypto['symbol'].toString(),
                  crypto['name'].toString(), crypto['id']);
              db.insert('cryptoList', newCrypto.toMap(),
                  conflictAlgorithm: ConflictAlgorithm.replace);
            }
          },
        );
  }

  Future<List<Crypto>> find() async {
    final db = await openDB();
    List<Map<String, dynamic>> maps = await db.query('cryptoList');
    return List.generate(maps.length, (i) {
      return Crypto(maps[i]['symbol'], maps[i]['name'], maps[i]['id']);
    });
  }
}
