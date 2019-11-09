class Stock {
  String symbol;
  String name;
  int id;

  Stock(String symbol, [String name, int id]) {
    this.symbol = symbol;
    this.name = name;
    this.id = id;
  }

  Stock fromMap(Map<String, dynamic> mappie) {
    return Stock(mappie['symbol'].toString());
  }

  Map<String, dynamic> toMap() {
    return {'symbol': symbol, 'name': name, 'id': id};
  }

  @override
  String toString() {
    return '{id: $id, symbol: $symbol, name: $name}';
  }
}
