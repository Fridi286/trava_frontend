import 'package:flutter/material.dart';

class SingleStockPreview extends StatelessWidget {
  const SingleStockPreview({
    super.key,
    required this.stockName,
    required this.stockPrice,
    required this.buyValue,
    required this.sellValue,
    required this.holdingValue,
  });

  final String stockName;
  final double stockPrice;
  final double buyValue;
  final double sellValue;
  final double holdingValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.onPrimary,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
          ]
      ),
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Column(
                children: [
                  Flexible(
                    child: Text(
                      stockName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      stockPrice.toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ]
            ),
          ),
          Expanded(
            flex: 7,
            child: TripleColorBar(
              greenValue: buyValue,
              grayValue: sellValue,
              redValue: holdingValue,
              height: 20,
              width: 200,
            ),
          ),
        ],
      ),
    );
  }
}


class TripleColorBar extends StatelessWidget {
  final double greenValue;
  final double grayValue;
  final double redValue;
  final double height;
  final double width;

  const TripleColorBar({
    super.key,
    required this.greenValue,
    required this.grayValue,
    required this.redValue,
    this.height = 15,
    this.width = 200,
  });

  @override
  Widget build(BuildContext context) {
    final total = greenValue + grayValue + redValue;
    final greenRatio = total == 0 ? 0.0 : greenValue / total;
    final grayRatio = total == 0 ? 0.0 : grayValue / total;
    final redRatio = total == 0 ? 0.0 : redValue / total;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade300,
      ),
      clipBehavior: Clip.hardEdge,
      child: Row(
        children: [
          Expanded(
            flex: (greenRatio * 1000).round(),
            child: Container(color: Colors.green),
          ),
          Expanded(
            flex: (grayRatio * 1000).round(),
            child: Container(color: Colors.grey),
          ),
          Expanded(
            flex: (redRatio * 1000).round(),
            child: Container(color: Colors.red),
          ),
        ],
      ),
    );
  }
}

