import 'package:flutter/material.dart';

class SingleStockPreview extends StatelessWidget {
  const SingleStockPreview({
    super.key,
    required this.stockName,
    required this.stockPrice,
  });

  final String stockName;
  final double stockPrice;

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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                stockName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                stockPrice.toString(),
              ),
          ),
        ],
      ),
    );
  }
}
