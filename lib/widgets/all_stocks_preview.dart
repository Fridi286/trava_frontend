import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trava_frontend/widgets/single_stock_preview.dart';

import '../models/stock.dart';
import 'package:http/http.dart' as http;

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
  final url = Uri.parse('http://127.0.0.1:8000/reply/stocks');

  final res = await http.get(url);
  if (res.statusCode != 200) return;

  final data = jsonDecode(res.body);

  setState(() {
    portfolioStocks =
        (data['portfolio'] as List).map((e) => Stock.fromJson(e)).toList();

    availableStocks =
        (data['available'] as List).map((e) => Stock.fromJson(e)).toList();

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