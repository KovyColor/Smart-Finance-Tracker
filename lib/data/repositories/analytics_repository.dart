import 'package:final_proj/data/models/analytics_model.dart';
import 'package:final_proj/data/services/hive/hive_transaction_service.dart';

class AnalyticsRepository {
  final HiveTransactionService _hiveService;

  AnalyticsRepository({required HiveTransactionService hiveService})
      : _hiveService = hiveService;

  Future<AnalyticsData> getAnalyticsData() async {
    try {
      final transactions = await _hiveService.getAllTransactions();

      if (transactions.isEmpty) {
        return AnalyticsData.empty();
      }

      double totalSpending = 0;
      double totalIncome = 0;
      Map<String, double> categoryMap = {};
      Map<String, MonthlyData> monthlyMap = {};
      Map<String, double> weeklyMap = {
        'Mon': 0,
        'Tue': 0,
        'Wed': 0,
        'Thu': 0,
        'Fri': 0,
        'Sat': 0,
        'Sun': 0,
      };

      final now = DateTime.now();
      final sixMonthsAgo = now.subtract(Duration(days: 180));

      for (var transaction in transactions) {
        final isSpending = transaction.type == 'expense';
        final amount = transaction.amount;

        if (isSpending) {
          totalSpending += amount;
        } else {
          totalIncome += amount;
        }

        // Category spending
        final category = transaction.category ?? 'Other';
        categoryMap[category] = (categoryMap[category] ?? 0) + amount;

        // Monthly data
        final transactionDate = transaction.date;
        if (transactionDate != null &&
            transactionDate.isAfter(sixMonthsAgo)) {
          final monthKey =
              '${transactionDate.year}-${transactionDate.month.toString().padLeft(2, '0')}';
          final existingData = monthlyMap[monthKey];

          if (existingData != null) {
            monthlyMap[monthKey] = MonthlyData(
              month: monthKey,
              spending:
                  isSpending ? existingData.spending + amount : existingData.spending,
              income: !isSpending ? existingData.income + amount : existingData.income,
            );
          } else {
            monthlyMap[monthKey] = MonthlyData(
              month: monthKey,
              spending: isSpending ? amount : 0,
              income: !isSpending ? amount : 0,
            );
          }
        }

        // Weekly data
        if (transactionDate != null) {
          final dayName = _getDayName(transactionDate.weekday);
          if (isSpending) {
            weeklyMap[dayName] = (weeklyMap[dayName] ?? 0) + amount;
          }
        }
      }

      // Convert category map to list
      final categorySpending = categoryMap.entries.map((e) {
        final percentage = totalSpending > 0 ? (e.value / totalSpending * 100).toDouble() : 0.0;
        return CategorySpending(
          category: e.key,
          amount: e.value,
          percentage: percentage,
        );
      }).toList()
        ..sort((a, b) => b.amount.compareTo(a.amount));

      // Convert monthly map to sorted list
      final monthlyData = monthlyMap.values.toList()
        ..sort((a, b) => a.month.compareTo(b.month));

      // Convert weekly map to list
      final weeklyList = weeklyMap.entries
          .map((e) => WeeklySpending(day: e.key, amount: e.value))
          .toList();

      return AnalyticsData(
        totalSpending: totalSpending,
        totalIncome: totalIncome,
        net: totalIncome - totalSpending,
        categorySpending: categorySpending,
        monthlyData: monthlyData,
        weeklySpending: weeklyList,
      );
    } catch (e) {
      print('Error getting analytics data: $e');
      return AnalyticsData.empty();
    }
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
}
