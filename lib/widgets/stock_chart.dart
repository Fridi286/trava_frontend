import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StockChart extends StatelessWidget {
  final List<FlSpot> spots;
  final String symbol;

  const StockChart({
    super.key,
    required this.spots,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          symbol,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 250,
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  barWidth: 2,
                  dotData: FlDotData(show: false),
                ),
              ],
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: true),
            ),
          ),
        ),
      ],
    );
  }
}