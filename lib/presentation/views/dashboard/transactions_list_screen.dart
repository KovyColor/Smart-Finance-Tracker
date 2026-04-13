import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_proj/config/theme/app_colors.dart';
import 'package:final_proj/config/theme/app_text_styles.dart';
import 'package:final_proj/core/base/base_view_model.dart';
import 'package:final_proj/data/models/transaction/transaction_models.dart';
import 'package:final_proj/presentation/viewmodels/transaction_view_model.dart';
import 'package:final_proj/presentation/widgets/transaction/transaction_forms.dart';
import 'package:final_proj/presentation/widgets/transaction/transaction_widgets.dart';
import 'package:final_proj/utils/constants/transaction_constants.dart';

/// Transactions list screen
class TransactionsListScreen extends StatefulWidget {
  const TransactionsListScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsListScreen> createState() => _TransactionsListScreenState();
}

class _TransactionsListScreenState extends State<TransactionsListScreen> {
  final _searchController = TextEditingController();
  String? _filterType;
  String? _filterCategory;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => _FilterDialog(
        selectedType: _filterType,
        selectedCategory: _filterCategory,
        onApply: (type, category, startDate, endDate) {
          setState(() {
            _filterType = type;
            _filterCategory = category;
            _startDate = startDate;
            _endDate = endDate;
          });

          final filter = TransactionFilter(
            type: type,
            category: category,
            startDate: startDate,
            endDate: endDate,
          );

          context.read<TransactionViewModel>().filterTransactions(filter);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                context.read<TransactionViewModel>().searchTransactions(value);
              },
              decoration: InputDecoration(
                hintText: 'Search transactions...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context
                              .read<TransactionViewModel>()
                              .clearFilters();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.borderColor),
                ),
              ),
            ),
          ),

          // Active filters display
          if (_filterType != null || _filterCategory != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                children: [
                  if (_filterType != null)
                    Chip(
                      label: Text(_filterType!),
                      onDeleted: () {
                        setState(() {
                          _filterType = null;
                        });
                      },
                    ),
                  if (_filterCategory != null)
                    Chip(
                      label: Text(_filterCategory!),
                      onDeleted: () {
                        setState(() {
                          _filterCategory = null;
                        });
                      },
                    ),
                ],
              ),
            ),

          // Transactions list
          Expanded(
            child: Consumer<TransactionViewModel>(
              builder: (context, viewModel, _) {
                if (viewModel.state == RequestState.loading &&
                    viewModel.transactions.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (viewModel.transactions.isEmpty) {
                  return EmptyTransactionsWidget(
                    onAddTap: _showAddTransactionSheet,
                  );
                }

                return ListView.builder(
                  itemCount: viewModel.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = viewModel.transactions[index];
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
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTransactionSheet,
        tooltip: 'Add Transaction',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Filter dialog
class _FilterDialog extends StatefulWidget {
  final String? selectedType;
  final String? selectedCategory;
  final Function(String?, String?, DateTime?, DateTime?)? onApply;

  const _FilterDialog({
    this.selectedType,
    this.selectedCategory,
    this.onApply,
  });

  @override
  State<_FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<_FilterDialog> {
  late String? _selectedType;
  late String? _selectedCategory;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.selectedType;
    _selectedCategory = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Transactions'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transaction type filter
            Text(
              'Transaction Type',
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<String?>(
              value: _selectedType,
              isExpanded: true,
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('All'),
                ),
                const DropdownMenuItem(
                  value: TransactionConstants.INCOME,
                  child: Text('Income'),
                ),
                const DropdownMenuItem(
                  value: TransactionConstants.EXPENSE,
                  child: Text('Expense'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                  _selectedCategory = null;
                });
              },
            ),
            const SizedBox(height: 16),

            // Category filter
            if (_selectedType != null) ...[
              Text(
                'Category',
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButton<String?>(
                value: _selectedCategory,
                isExpanded: true,
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('All'),
                  ),
                  ...((_selectedType == TransactionConstants.INCOME
                          ? TransactionConstants.incomeCategories
                          : TransactionConstants.expenseCategories)
                      .map((cat) =>
                          DropdownMenuItem(
                            value: cat,
                            child: Text(cat),
                          ))
                      .toList()),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
            ],
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
            widget.onApply?.call(
              _selectedType,
              _selectedCategory,
              _startDate,
              _endDate,
            );
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
