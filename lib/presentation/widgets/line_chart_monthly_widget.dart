import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:final_proj/data/models/analytics_model.dart';

class LineChartMonthlyWidget extends StatelessWidget {
  final List<MonthlyData> monthlyData;
  final String currencySymbol;

  const LineChartMonthlyWidget({
    Key? key,
    required this.monthlyData,
    required this.currencySymbol,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (monthlyData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.show_chart, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text('No monthly data available'),
          ],
        ),
      );
    }

    final spots = List.generate(
      monthlyData.length,
      (index) => FlSpot(
        index.toDouble(),
        monthlyData[index].spending,
      ),
    );

    final incomeSpots = List.generate(
      monthlyData.length,
      (index) => FlSpot(
        index.toDouble(),
        monthlyData[index].income,
      ),
    );

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: _getHighestValue() / 5,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < monthlyData.length) {
                  final month = monthlyData[index].month.split('-')[1];
                  return Text(month);
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                if (value % (_getHighestValue() / 5) == 0) {
                  return Text('\$${value.toInt()}');
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
            left: BorderSide(color: Colors.grey.withOpacity(0.3)),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.red.withOpacity(0.8),
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.red,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.red.withOpacity(0.1),
            ),
          ),
          LineChartBarData(
            spots: incomeSpots,
            isCurved: true,
            color: Colors.green.withOpacity(0.8),
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.green,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  double _getHighestValue() {
    if (monthlyData.isEmpty) return 0;
    final spendingMax =
        monthlyData.map((d) => d.spending).reduce((a, b) => a > b ? a : b);
    final incomeMax =
        monthlyData.map((d) => d.income).reduce((a, b) => a > b ? a : b);
    final max = spendingMax > incomeMax ? spendingMax : incomeMax;
    return max > 0 ? max : 1000; // Default to 1000 if no data
  }
}

class MonthlyReportLegend extends StatelessWidget {
  final List<MonthlyData> monthlyData;
  final String currencySymbol;

  const MonthlyReportLegend({
    Key? key,
    required this.monthlyData,
    required this.currencySymbol,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (monthlyData.isEmpty) {
      return const SizedBox.shrink();
    }

    final latestData = monthlyData.last;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildLegendItem(
              'Spending',
              '$currencySymbol${latestData.spending.toStringAsFixed(2)}',
              Colors.red,
            ),
            _buildLegendItem(
              'Income',
              '$currencySymbol${latestData.income.toStringAsFixed(2)}',
              Colors.green,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, String value, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
