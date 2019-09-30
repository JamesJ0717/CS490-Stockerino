class ResponseData {
  final String companyName;
  final String symbol;
  final String high;
  final String low;
  final String current;
  final String percentChange;
  final String dollarChange;

  ResponseData({
    this.companyName,
    this.symbol,
    this.high,
    this.low,
    this.current,
    this.percentChange,
    this.dollarChange,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      companyName: json['companyName'],
      symbol: json['symbol'],
      high: json['high'].toString(),
      low: json['low'].toString(),
      current: "\$" + json['latestPrice'].toString(),
      percentChange: json['changePercent'].toString() + '%',
      dollarChange: "\$" + json['change'].toString(),
    );
  }
}
