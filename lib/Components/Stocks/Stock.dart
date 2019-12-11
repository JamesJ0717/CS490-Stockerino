class Stock {
  String symbol;
  String name;
  int id;

  Stock(String symbol, [String name, int id]) {
    this.symbol = symbol;
    this.name = name;
    this.id = id;
  }

  Map<String, dynamic> toMap() {
    return {'symbol': symbol, 'name': name, 'id': id};
  }

  @override
  String toString() {
    return '{id: $id, symbol: $symbol, name: $name}';
  }
}

class StockData {
  dynamic symbol;
  dynamic companyName;
  dynamic primaryExchange;
  dynamic calculationPrice;
  dynamic open;
  dynamic openTime;
  dynamic close;
  dynamic closeTime;
  dynamic high;
  dynamic low;
  dynamic latestPrice;
  dynamic latestSource;
  dynamic latestTime;
  dynamic latestUpdate;
  dynamic latestVolume;
  dynamic iexRealtimePrice;
  dynamic iexRealtimeSize;
  dynamic iexLastUpdated;
  dynamic delayedPrice;
  dynamic delayedPriceTime;
  dynamic extendedPrice;
  dynamic extendedChange;
  dynamic extendedChangePercent;
  dynamic extendedPriceTime;
  dynamic previousClose;
  dynamic previousVolume;
  dynamic change;
  dynamic changePercent;
  dynamic volume;
  dynamic iexMarketPercent;
  dynamic iexVolume;
  dynamic avgTotalVolume;
  dynamic iexBidPrice;
  dynamic iexBidSize;
  dynamic iexAskPrice;
  dynamic iexAskSize;
  dynamic marketCap;
  dynamic peRatio;
  dynamic week52High;
  dynamic week52Low;
  dynamic ytdChange;
  dynamic lastTradeTime;
  dynamic isUSMarketOpen;
  bool error;

  StockData({
    this.symbol,
    this.companyName,
    this.primaryExchange,
    this.calculationPrice,
    this.open,
    this.openTime,
    this.close,
    this.closeTime,
    this.high,
    this.low,
    this.latestPrice,
    this.latestSource,
    this.latestTime,
    this.latestUpdate,
    this.latestVolume,
    this.iexRealtimePrice,
    this.iexRealtimeSize,
    this.iexLastUpdated,
    this.delayedPrice,
    this.delayedPriceTime,
    this.extendedPrice,
    this.extendedChange,
    this.extendedChangePercent,
    this.extendedPriceTime,
    this.previousClose,
    this.previousVolume,
    this.change,
    this.changePercent,
    this.volume,
    this.iexMarketPercent,
    this.iexVolume,
    this.avgTotalVolume,
    this.iexBidPrice,
    this.iexBidSize,
    this.iexAskPrice,
    this.iexAskSize,
    this.marketCap,
    this.peRatio,
    this.week52High,
    this.week52Low,
    this.ytdChange,
    this.lastTradeTime,
    this.isUSMarketOpen,
    this.error = false,
  });

  factory StockData.error(String symbol) {
    return StockData(
      symbol: symbol,
      error: true,
    );
  }

  factory StockData.fromJson(Map<String, dynamic> json) {
    return StockData(
      symbol: json['symbol'],
      companyName: json['companyName'],
      primaryExchange: json['primaryExchange'],
      calculationPrice: json['calculationPrice'],
      open: json['open'],
      openTime: json['openTime'],
      close: json['close'],
      closeTime: json['closeTime'],
      high: json['high'],
      low: json['low'],
      latestPrice: json['latestPrice'],
      latestSource: json['latestSource'],
      latestTime: json['latestTime'],
      latestUpdate: json['latestUpdate'],
      latestVolume: json['latestVolume'],
      iexRealtimePrice: json['iexRealtimePrice'],
      iexRealtimeSize: json['iexRealtimeSize'],
      iexLastUpdated: json['iexLastUpdated'],
      delayedPrice: json['delayedPrice'],
      delayedPriceTime: json['delayedPriceTime'],
      extendedPrice: json['extendedPrice'],
      extendedChange: json['extendedChange'],
      extendedChangePercent: json['extendedChangePercent'],
      extendedPriceTime: json['extendedPriceTime'],
      previousClose: json['previousClose'],
      previousVolume: json['previousVolume'],
      change: json['change'],
      changePercent: json['changePercent'],
      volume: json['volume'],
      iexMarketPercent: json['iexMarketPercent'],
      iexVolume: json['iexVolume'],
      avgTotalVolume: json['avgTotalVolume'],
      iexBidPrice: json['iexBidPrice'],
      iexBidSize: json['iexBidSize'],
      iexAskPrice: json['iexAskPrice'],
      iexAskSize: json['iexAskSize'],
      marketCap: json['marketCap'],
      peRatio: json['peRatio'],
      week52High: json['week52High'],
      week52Low: json['week52Low'],
      ytdChange: json['ytdChange'],
      lastTradeTime: json['lastTradeTime'],
      isUSMarketOpen: json['isUSMarketOpen'],
    );
  }
}
