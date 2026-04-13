import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_proj/config/routes/app_routes.dart';
import 'package:final_proj/config/theme/app_colors.dart';
import 'package:final_proj/config/theme/app_text_styles.dart';
import 'package:final_proj/core/base/base_view_model.dart';
import 'package:final_proj/presentation/viewmodels/transaction_view_model.dart';
import 'package:final_proj/presentation/widgets/transaction/transaction_forms.dart';
import 'package:final_proj/presentation/widgets/transaction/transaction_widgets.dart';

/// Home dashboard screen
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionViewModel>().initialize();
    });
  }

  void _showAddTransactionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => AddTransactionBottomSheet(
        onSuccess: () {
          context.read<TransactionViewModel>().refreshTransactions();
        },
      ),
    );
  }

  void _showEditTransactionSheet(String transactionId) async {
    final transaction = await context
        .read<TransactionViewModel>()
        .getTransaction(transactionId);
    if (transaction != null && mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) => EditTransactionBottomSheet(
          transaction: transaction,
          onSuccess: () {
            context.read<TransactionViewModel>().refreshTransactions();
          },
        ),
      );
    }
  }

  void _deleteTransaction(String transactionId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context
                  .read<TransactionViewModel>()
                  .deleteTransaction(transactionId);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.ANALYTICS);
            },
          ),
          IconButton(
            icon: const Icon(Icons.pie_chart),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.BUDGETS);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.SETTINGS);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<TransactionViewModel>().refreshTransactions();
            },
          ),
        ],
      ),
      body: Consumer<TransactionViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.state == RequestState.loading &&
              viewModel.transactionCount == 0) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                context.read<TransactionViewModel>().refreshTransactions(),
            child: ListView(
              children: [
                // Balance card
                if (viewModel.summary != null)
                  BalanceCard(
                    balance: viewModel.summary!.balance,
                    income: viewModel.summary!.totalIncome,
                    expense: viewModel.summary!.totalExpense,
                    isExpanded: true,
                  ),

                const SizedBox(height: 8),

                // Summary widget
                if (viewModel.summary != null)
                  TransactionSummaryWidget(summary: viewModel.summary!),

                const SizedBox(height: 16),

                // Recent transactions header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Transactions',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (viewModel.transactionCount > 5)
                        TextButton(
                          onPressed: () {
                            // Navigate to transactions list
                          },
                          child: Text(
                            'See All',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Transactions list
                if (viewModel.transactions.isEmpty)
                  EmptyTransactionsWidget(
                    onAddTap: _showAddTransactionSheet,
                  )
                else
                  Column(
                    children: viewModel.recentTransactions.map((transaction) {
                      return SwipeableTransactionCard(
                        transaction: transaction,
                        onEdit: () =>
                            _showEditTransactionSheet(transaction.id),
                        onDelete: () =>
                            _deleteTransaction(transaction.id),
                        onTap: () {
                          // Show transaction details
                        },
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTransactionSheet,
        tooltip: 'Add Transaction',
        child: const Icon(Icons.add),
      ),
    );
  }
}
