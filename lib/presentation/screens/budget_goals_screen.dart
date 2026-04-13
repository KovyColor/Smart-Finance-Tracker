import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_proj/data/models/budget_goal_model.dart';
import 'package:final_proj/data/models/settings_model.dart';
import 'package:final_proj/presentation/viewmodels/budget_goal_view_model.dart';
import 'package:final_proj/presentation/viewmodels/settings_view_model.dart';
import 'package:final_proj/presentation/widgets/progress_bar_widget.dart';
import 'package:uuid/uuid.dart';

class BudgetGoalsScreen extends StatefulWidget {
  const BudgetGoalsScreen({Key? key}) : super(key: key);

  @override
  State<BudgetGoalsScreen> createState() => _BudgetGoalsScreenState();
}

class _BudgetGoalsScreenState extends State<BudgetGoalsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<BudgetGoalViewModel>().loadBudgetGoals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Goals'),
        elevation: 0,
      ),
      body: Consumer2<BudgetGoalViewModel, SettingsViewModel>(
        builder: (context, budgetVM, settingsVM, _) {
          if (budgetVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => budgetVM.loadBudgetGoals(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                BudgetProgressOverview(
                  budgetGoals: budgetVM.budgetGoals,
                  currencySymbol: settingsVM.currency.symbol,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBudgetDialog(context);
        },
        tooltip: 'Add Budget Goal',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddBudgetDialog(BuildContext context) {
    final categoryController = TextEditingController();
    final targetController = TextEditingController();
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now().add(Duration(days: 30));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Budget Goal'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  hintText: 'e.g., Food, Entertainment',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: targetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Target Amount',
                  prefixText: '\$ ',
                ),
              ),
              const SizedBox(height: 16),
              StatefulBuilder(
                builder: (context, setState) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Start Date: ${startDate.toString().split(' ')[0]}'),
                    ElevatedButton(
                      onPressed: () async {
                        final selected = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (selected != null) {
                          setState(() => startDate = selected);
                        }
                      },
                      child: const Text('Change Start Date'),
                    ),
                    const SizedBox(height: 12),
                    Text('End Date: ${endDate.toString().split(' ')[0]}'),
                    ElevatedButton(
                      onPressed: () async {
                        final selected = await showDatePicker(
                          context: context,
                          initialDate: endDate,
                          firstDate: startDate,
                          lastDate: DateTime(2030),
                        );
                        if (selected != null) {
                          setState(() => endDate = selected);
                        }
                      },
                      child: const Text('Change End Date'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final category = categoryController.text.trim();
              final target = double.tryParse(targetController.text);

              if (category.isEmpty || target == null || target <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill all fields with valid values'),
                  ),
                );
                return;
              }

              final goal = BudgetGoal(
                id: const Uuid().v4(),
                category: category,
                targetAmount: target,
                currentSpending: 0,
                startDate: startDate,
                endDate: endDate,
                isActive: true,
              );

              context.read<BudgetGoalViewModel>().addBudgetGoal(goal);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Budget goal added successfully')),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
