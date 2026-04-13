import 'package:flutter/material.dart';
import 'package:final_proj/data/models/budget_goal_model.dart';

class ProgressBar extends StatelessWidget {
  final double progress;
  final String label;
  final Color? backgroundColor;
  final Color? progressColor;

  const ProgressBar({
    Key? key,
    required this.progress,
    required this.label,
    this.backgroundColor,
    this.progressColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Colors.grey.withOpacity(0.3);
    final pgColor = progressColor ?? Colors.blue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress.clamp(0, 1),
            minHeight: 8,
            backgroundColor: bgColor,
            valueColor: AlwaysStoppedAnimation<Color>(pgColor),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${(progress * 100).toStringAsFixed(1)}%',
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}

class BudgetGoalCard extends StatelessWidget {
  final BudgetGoal goal;
  final String currencySymbol;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BudgetGoalCard({
    Key? key,
    required this.goal,
    required this.currencySymbol,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isExceeded = goal.isExceeded;
    final progressColor = isExceeded ? Colors.red : Colors.green;
    final bgColor = isExceeded
        ? Colors.red.withOpacity(0.1)
        : Colors.green.withOpacity(0.1);

    return Card(
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  goal.category,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Row(
                  children: [
                    if (onEdit != null)
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: onEdit,
                        iconSize: 20,
                      ),
                    if (onDelete != null)
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: onDelete,
                        iconSize: 20,
                        color: Colors.red,
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Budget: $currencySymbol${goal.targetAmount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Spent: $currencySymbol${goal.currentSpending.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isExceeded ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ProgressBar(
              progress: goal.progressPercentage / 100,
              label:
                  'Progress: ${goal.progressPercentage.toStringAsFixed(1)}%',
              progressColor: progressColor,
              backgroundColor: Colors.grey.withOpacity(0.2),
            ),
            const SizedBox(height: 8),
            if (!isExceeded)
              Text(
                'Remaining: $currencySymbol${goal.remainingAmount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.green,
                    ),
              )
            else
              Text(
                'Exceeded by: $currencySymbol${(goal.currentSpending - goal.targetAmount).toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.red,
                    ),
              ),
          ],
        ),
      ),
    );
  }
}

class BudgetProgressOverview extends StatelessWidget {
  final List<BudgetGoal> budgetGoals;
  final String currencySymbol;

  const BudgetProgressOverview({
    Key? key,
    required this.budgetGoals,
    required this.currencySymbol,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (budgetGoals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.track_changes, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text('No budget goals set'),
            SizedBox(height: 8),
          ],
        ),
      );
    }

    final exceededCount = budgetGoals.where((g) => g.isExceeded).length;
    final onTrackCount = budgetGoals.length - exceededCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                'On Track',
                onTrackCount.toString(),
                Colors.green,
              ),
              _buildStatItem(
                context,
                'Exceeded',
                exceededCount.toString(),
                Colors.red,
              ),
              _buildStatItem(
                context,
                'Total',
                budgetGoals.length.toString(),
                Colors.blue,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: budgetGoals.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: BudgetGoalCard(
                goal: budgetGoals[index],
                currencySymbol: currencySymbol,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
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
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
