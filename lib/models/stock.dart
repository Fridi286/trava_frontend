class Stock {
  final String stockName;
  final double stockPrice;
  final double buyValue;
  final double sellValue;
  final double holdingValue;

  Stock({
    required this.stockName,
    required this.stockPrice,
    required this.buyValue,
    required this.sellValue,
    required this.holdingValue,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      stockName: json['stockName'],
      stockPrice: (json['stockPrice'] as num).toDouble(),
      buyValue: (json['buyValue'] as num).toDouble(),
      sellValue: (json['sellValue'] as num).toDouble(),
      holdingValue: (json['holdingValue'] as num).toDouble(),
    );
  }
}
