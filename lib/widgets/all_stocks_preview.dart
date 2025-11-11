import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trava_frontend/widgets/single_stock_preview.dart';

import '../models/stock.dart';


class AllStocksPreview extends StatefulWidget {
  const AllStocksPreview({super.key});

  @override
  State<AllStocksPreview> createState() => _AllStocksPreviewState();
}

class _AllStocksPreviewState extends State<AllStocksPreview> {

  List<Stock> portfolioStocks = [];
  List<Stock> availableStocks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStocks();
  }

  Future<void> loadStocks() async {
    final portfolioData = await rootBundle.loadString('assets/portfolio.json');
    final availableData = await rootBundle.loadString('assets/available.json');

    final portfolioList = jsonDecode(portfolioData) as List;
    final availableList = jsonDecode(availableData) as List;

    setState(() {
      portfolioStocks = portfolioList.map((e) => Stock.fromJson(e)).toList();
      availableStocks = availableList.map((e) => Stock.fromJson(e)).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        const Header(text: "Your Portfolio"),
        Expanded(
          flex: 35,
          child: ListView.builder(
            itemCount: portfolioStocks.length,
            itemBuilder: (context, index) {
              final stock = portfolioStocks[index];
              return SingleStockPreview(
                stockName: stock.stockName,
                stockPrice: stock.stockPrice,
                buyValue: stock.buyValue,
                sellValue: stock.sellValue,
                holdingValue: stock.holdingValue,
              );
            },
          ),
        ),
        const Header(text: "Available Stocks"),
        Expanded(
          flex: 65,
          child: ListView.builder(
            itemCount: availableStocks.length,
            itemBuilder: (context, index) {
              final stock = availableStocks[index];
              return SingleStockPreview(
                stockName: stock.stockName,
                stockPrice: stock.stockPrice,
                buyValue: stock.buyValue,
                sellValue: stock.sellValue,
                holdingValue: stock.holdingValue,
              );
            },
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