import 'package:final_proj/data/models/budget_goal_model.dart';

class BudgetGoalRepository {
  // In-memory storage for this example
  // In production, this should use Hive or another persistent storage
  final List<BudgetGoal> _budgetGoals = [];

  Future<List<BudgetGoal>> getAllBudgetGoals() async {
    return _budgetGoals;
  }

  Future<BudgetGoal?> getBudgetGoal(String id) async {
    try {
      return _budgetGoals.firstWhere((goal) => goal.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addBudgetGoal(BudgetGoal goal) async {
    _budgetGoals.add(goal);
  }

  Future<void> updateBudgetGoal(BudgetGoal goal) async {
    final index = _budgetGoals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _budgetGoals[index] = goal;
    }
  }

  Future<void> deleteBudgetGoal(String id) async {
    _budgetGoals.removeWhere((goal) => goal.id == id);
  }

  Future<List<BudgetGoal>> getActiveBudgetGoals() async {
    final now = DateTime.now();
    return _budgetGoals
        .where((goal) =>
            goal.isActive &&
            goal.startDate.isBefore(now) &&
            goal.endDate.isAfter(now))
        .toList();
  }

  Future<List<BudgetGoal>> getExceededBudgets() async {
    final active = await getActiveBudgetGoals();
    return active.where((goal) => goal.isExceeded).toList();
  }
}
