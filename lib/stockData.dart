class StockData {
  final String companyName;
  final String symbol;
  final double high;
  final double low;
  final double current;
  final double percentChange;
  final double dollarChange;
  final bool error;

  StockData({
    this.companyName,
    this.symbol,
    this.high,
    this.low,
    this.current,
    this.percentChange,
    this.dollarChange,
    this.error = false,
  });

  factory StockData.error() {
    return StockData(error: true);
  }

  factory StockData.fromJson(Map<String, dynamic> json) {
    return StockData(
      companyName: json['companyName'].toString(),
      symbol: json['symbol'].toString(),
      high: json['high'],
      low: json['low'],
      current: json['latestPrice'],
      percentChange: (json['changePercent'] * 100),
      dollarChange: json['change'],
    );
  }
}
