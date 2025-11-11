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
    return Column(
      children: [
        Header(text: "Your Portfolio"),
        Expanded(
          flex: 35,
          child: ListView(
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
          ),
        ),
        Header(text: "Available Stocks"),
        Expanded(
          flex: 65,
          child: ListView(
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
          ),
        ),
      ],
    );
  }
}


class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.text
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
          ]
      ),
      height: 60,
      width: double.infinity,
      child: Center(child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      )),
    );
  }
}