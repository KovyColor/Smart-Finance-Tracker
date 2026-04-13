class BudgetGoal {
  final String id;
  final String category;
  final double targetAmount;
  final double currentSpending;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  BudgetGoal({
    required this.id,
    required this.category,
    required this.targetAmount,
    required this.currentSpending,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });

  double get progressPercentage {
    if (targetAmount == 0) return 0;
    return (currentSpending / targetAmount * 100).clamp(0, 100);
  }

  bool get isExceeded {
    return currentSpending > targetAmount;
  }

  double get remainingAmount {
    return (targetAmount - currentSpending).clamp(0, double.infinity);
  }

  factory BudgetGoal.empty() {
    return BudgetGoal(
      id: '',
      category: '',
      targetAmount: 0,
      currentSpending: 0,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 30)),
      isActive: true,
    );
  }
}
