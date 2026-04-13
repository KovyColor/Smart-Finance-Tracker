import 'package:flutter/foundation.dart';
import 'package:final_proj/data/models/analytics_model.dart';
import 'package:final_proj/data/repositories/analytics_repository.dart';

class AnalyticsViewModel extends ChangeNotifier {
  final AnalyticsRepository _repository;

  AnalyticsViewModel({required AnalyticsRepository repository})
      : _repository = repository;

  AnalyticsData _analyticsData = AnalyticsData.empty();
  bool _isLoading = false;
  String? _error;

  AnalyticsData get analyticsData => _analyticsData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<PieChartData> get pieChartData {
    return _analyticsData.categorySpending
        .map((category) => PieChartData(
              label: category.category,
              value: category.amount,
              color: _getColorForCategory(category.category),
            ))
        .toList();
  }

  List<MonthlyData> get monthlyChartData => _analyticsData.monthlyData;

  List<WeeklySpending> get weeklyChartData => _analyticsData.weeklySpending;

  double get totalSpending => _analyticsData.totalSpending;
  double get totalIncome => _analyticsData.totalIncome;
  double get netAmount => _analyticsData.net;

  Future<void> loadAnalyticsData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _analyticsData = await _repository.getAnalyticsData();
      _error = null;
    } catch (e) {
      _error = 'Failed to load analytics data: ${e.toString()}';
      print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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

  void refresh() {
    loadAnalyticsData();
  }
}
