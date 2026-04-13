import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:final_proj/data/models/analytics_model.dart';

class BarChartWeeklyWidget extends StatelessWidget {
  final List<WeeklySpending> weeklySpending;
  final String currencySymbol;

  const BarChartWeeklyWidget({
    Key? key,
    required this.weeklySpending,
    required this.currencySymbol,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (weeklySpending.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.bar_chart, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text('No weekly data available'),
          ],
        ),
      );
    }

    final barGroups = List.generate(
      weeklySpending.length,
      (index) => BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: weeklySpending[index].amount,
            color: _getColorForAmount(weeklySpending[index].amount),
            width: 12,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      ),
    );

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getHighestValue(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: _getHighestValue() / 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
            left: BorderSide(color: Colors.grey.withOpacity(0.3)),
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < weeklySpending.length) {
                  return Text(weeklySpending[index].day.substring(0, 3));
                }
                return const Text('');
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                if (value % (_getHighestValue() / 5) == 0) {
                  return Text('\$${value.toInt()}');
                }
                return const Text('');
              },
            ),
          ),
        ),
        barGroups: barGroups,
      ),
    );
  }

  Color _getColorForAmount(double amount) {
    if (amount == 0) {
      return Colors.grey.withOpacity(0.5);
    } else if (amount < _getHighestValue() / 3) {
      return Colors.green;
    } else if (amount < (_getHighestValue() / 3) * 2) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  double _getHighestValue() {
    if (weeklySpending.isEmpty) return 0;
    final max = weeklySpending.map((w) => w.amount).reduce((a, b) => a > b ? a : b);
    return max > 0 ? max : 100; // Default to 100 if no data
  }
}

class WeeklySpendingLegend extends StatelessWidget {
  final List<WeeklySpending> weeklySpending;
  final String currencySymbol;

  const WeeklySpendingLegend({
    Key? key,
    required this.weeklySpending,
    required this.currencySymbol,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (weeklySpending.isEmpty) {
      return const SizedBox.shrink();
    }

    final totalWeeklySpending =
        weeklySpending.fold<double>(0, (sum, item) => sum + item.amount);
    final averageDaily = totalWeeklySpending / weeklySpending.length;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              'Total Weekly',
              '$currencySymbol${totalWeeklySpending.toStringAsFixed(2)}',
              Colors.blue,
            ),
            _buildStatItem(
              'Daily Average',
              '$currencySymbol${averageDaily.toStringAsFixed(2)}',
              Colors.purple,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
