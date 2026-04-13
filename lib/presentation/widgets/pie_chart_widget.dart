import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:final_proj/data/models/analytics_model.dart' as analytics;

class PieChartWidget extends StatelessWidget {
  final List<analytics.CategorySpending> categorySpending;
  final String currencySymbol;

  const PieChartWidget({
    Key? key,
    required this.categorySpending,
    required this.currencySymbol,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categorySpending.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.pie_chart, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text('No spending data available'),
          ],
        ),
      );
    }

    return PieChart(
      PieChartData(
        sections: List.generate(
          categorySpending.length,
          (index) {
            final category = categorySpending[index];
            return PieChartSectionData(
              value: category.amount,
              title: '${category.percentage.toStringAsFixed(1)}%',
              radius: 100,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              color: Color(_getColorForCategory(category.category)),
            );
          },
        ),
        centerSpaceRadius: 0,
        sectionsSpace: 0,
      ),
    );
  }

  int _getColorForCategory(String category) {
    const colors = [
      0xFF1E88E5, // Blue
      0xFFE53935, // Red
      0xFF43A047, // Green
      0xFFFDD835, // Yellow
      0xFF039BE5, // Light Blue
      0xFF8E24AA, // Purple
      0xFF00ACC1, // Cyan
      0xFFFB8C00, // Orange
    ];

    final hash = category.hashCode;
    return colors[hash % colors.length];
  }
}

class CategorySpendingLegend extends StatelessWidget {
  final List<analytics.CategorySpending> categorySpending;
  final String currencySymbol;

  const CategorySpendingLegend({
    Key? key,
    required this.categorySpending,
    required this.currencySymbol,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categorySpending.length,
      itemBuilder: (context, index) {
        final category = categorySpending[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Color(_getColorForCategory(category.category)),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category.category,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Text(
                '$currencySymbol${category.amount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  int _getColorForCategory(String category) {
    const colors = [
      0xFF1E88E5, // Blue
      0xFFE53935, // Red
      0xFF43A047, // Green
      0xFFFDD835, // Yellow
      0xFF039BE5, // Light Blue
      0xFF8E24AA, // Purple
      0xFF00ACC1, // Cyan
      0xFFFB8C00, // Orange
    ];

    final hash = category.hashCode;
    return colors[hash % colors.length];
  }
}
