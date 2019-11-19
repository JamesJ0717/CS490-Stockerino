class Crypto {
  String symbol;
  int id;
  String name;

  Crypto(String symbol, [String name, int id]) {
    this.symbol = symbol;
    this.id = id;
    this.name = name;
  }

  Map<String, dynamic> toMap() {
    return {
      'symbol': symbol,
      'name': name,
      'id': id,
    };
  }
}

class CryptoData {
  int id;
  String name;
  String symbol;
  String slug;
  int maxSupply;
  num circulatingSupply;
  num totalSupply;
  Map<String, dynamic> quote;
  double quotePrice;
  double quoteVolume_24h;
  double quotePercentChange_1h;
  double quotePercentChange_24h;
  double quotePercentChange_7d;
  double quoteMarketCap;
  String quoteLastUpdated;

  bool error = false;

  CryptoData({
    this.id,
    this.name,
    this.symbol,
    this.slug,
    this.maxSupply,
    this.circulatingSupply,
    this.totalSupply,
    this.quote,
    this.quotePrice,
    this.quoteVolume_24h,
    this.quotePercentChange_1h,
    this.quotePercentChange_24h,
    this.quotePercentChange_7d,
    this.quoteMarketCap,
    this.quoteLastUpdated,
    this.error = false,
  });

  @override
  String toString() {
    return '{id: $id, name: $name, symbol: $symbol, slug: $slug, quote: $quote, quotePrice: $quotePrice}';
  }

  factory CryptoData.error() {
    return (CryptoData(error: true));
  }

  factory CryptoData.fromJson(Map<String, dynamic> json, String name) {
    Map<String, dynamic> jsonData = json['data'][name];
    return CryptoData(
      id: jsonData['id'],
      name: jsonData['name'],
      symbol: jsonData['symbol'],
      slug: jsonData['slug'],
      maxSupply: jsonData['max_supply'],
      circulatingSupply: jsonData['circulating_supply'],
      totalSupply: jsonData['total_supply'],
      quote: jsonData['quote'],
      quotePrice: jsonData['quote']['USD']['price'],
      quoteVolume_24h: jsonData['quote']['USD']['volume_24h'],
      quotePercentChange_1h: jsonData['quote']['USD']['percent_change_1h'],
      quotePercentChange_24h: jsonData['quote']['USD']['percent_change_24h'],
      quotePercentChange_7d: jsonData['quote']['USD']['percent_change_7d'],
      quoteMarketCap: jsonData['quote']['USD']['market_cap'],
      quoteLastUpdated: jsonData['quote']['USD']['last_updated'],
      error: false,
    );
  }
}
