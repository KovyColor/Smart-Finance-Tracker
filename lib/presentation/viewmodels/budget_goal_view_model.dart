import 'package:flutter/foundation.dart';
import 'package:final_proj/data/models/budget_goal_model.dart';
import 'package:final_proj/data/repositories/budget_goal_repository.dart';

class BudgetGoalViewModel extends ChangeNotifier {
  final BudgetGoalRepository _repository;

  BudgetGoalViewModel({required BudgetGoalRepository repository})
      : _repository = repository;

  List<BudgetGoal> _budgetGoals = [];
  bool _isLoading = false;
  String? _error;

  List<BudgetGoal> get budgetGoals => _budgetGoals;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadBudgetGoals() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _budgetGoals = await _repository.getAllBudgetGoals();
      _error = null;
    } catch (e) {
      _error = 'Failed to load budget goals: ${e.toString()}';
      print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBudgetGoal(BudgetGoal goal) async {
    try {
      await _repository.addBudgetGoal(goal);
      _budgetGoals.add(goal);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add budget goal: ${e.toString()}';
      print(_error);
      notifyListeners();
    }
  }

  Future<void> updateBudgetGoal(BudgetGoal goal) async {
    try {
      await _repository.updateBudgetGoal(goal);
      final index = _budgetGoals.indexWhere((g) => g.id == goal.id);
      if (index != -1) {
        _budgetGoals[index] = goal;
      }
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update budget goal: ${e.toString()}';
      print(_error);
      notifyListeners();
    }
  }

  Future<void> deleteBudgetGoal(String id) async {
    try {
      await _repository.deleteBudgetGoal(id);
      _budgetGoals.removeWhere((goal) => goal.id == id);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete budget goal: ${e.toString()}';
      print(_error);
      notifyListeners();
    }
  }

  Future<void> loadActiveBudgetGoals() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _budgetGoals = await _repository.getActiveBudgetGoals();
      _error = null;
    } catch (e) {
      _error = 'Failed to load active budget goals: ${e.toString()}';
      print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<BudgetGoal>> getExceededBudgets() async {
    try {
      return await _repository.getExceededBudgets();
    } catch (e) {
      print('Failed to get exceeded budgets: $e');
      return [];
    }
  }

  void refresh() {
    loadBudgetGoals();
  }
}
