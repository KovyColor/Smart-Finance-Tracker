class AnalyticsData {
  final double totalSpending;
  final double totalIncome;
  final double net;
  final List<CategorySpending> categorySpending;
  final List<MonthlyData> monthlyData;
  final List<WeeklySpending> weeklySpending;

  AnalyticsData({
    required this.totalSpending,
    required this.totalIncome,
    required this.net,
    required this.categorySpending,
    required this.monthlyData,
    required this.weeklySpending,
  });

  factory AnalyticsData.empty() {
    return AnalyticsData(
      totalSpending: 0,
      totalIncome: 0,
      net: 0,
      categorySpending: [],
      monthlyData: [],
      weeklySpending: [],
    );
  }
}

class CategorySpending {
  final String category;
  final double amount;
  final double percentage;

  CategorySpending({
    required this.category,
    required this.amount,
    required this.percentage,
  });
}

class MonthlyData {
  final String month;
  final double spending;
  final double income;

  MonthlyData({
    required this.month,
    required this.spending,
    required this.income,
  });
}

class WeeklySpending {
  final String day;
  final double amount;

  WeeklySpending({
    required this.day,
    required this.amount,
  });
}

class PieChartData {
  final String label;
  final double value;
  final int color;

  PieChartData({
    required this.label,
    required this.value,
    required this.color,
  });
}
