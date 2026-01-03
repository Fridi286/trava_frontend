class StockPoint {
  final DateTime time;
  final double close;

  StockPoint({
    required this.time,
    required this.close,
  });

  factory StockPoint.fromJson(Map<String, dynamic> json) {
    return StockPoint(
      time: DateTime.parse(json['t']),
      close: (json['c'] as num).toDouble(),
    );
  }
}