import 'package:flutter/material.dart';
import 'package:trava_frontend/widgets/stock_preview.dart';


class PortfolioPreview extends StatefulWidget {
  const PortfolioPreview({super.key});

  @override
  State<PortfolioPreview> createState() => _PortfolioPreviewState();
}

class _PortfolioPreviewState extends State<PortfolioPreview> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        StockPreview(
          stockName: "Apple",
          stockPrice: 12,
          buyValue: 5,
          sellValue: 8,
          holdingValue: 6,
        ),
        StockPreview(
          stockName: "Apple",
          stockPrice: 263,
          buyValue: 23,
          sellValue: 4,
          holdingValue: 6,
        ),
        StockPreview(
          stockName: "Apple",
          stockPrice: 2777,
          buyValue: 5,
          sellValue: 16,
          holdingValue: 6,
        ),
        StockPreview(
          stockName: "Apple",
          stockPrice: 155,
          buyValue: 5,
          sellValue: 4,
          holdingValue: 6,
        ),
      ],
    );
  }
}
