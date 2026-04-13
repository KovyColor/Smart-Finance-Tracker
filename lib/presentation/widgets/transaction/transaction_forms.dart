import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_proj/config/theme/app_colors.dart';
import 'package:final_proj/config/theme/app_text_styles.dart';
import 'package:final_proj/core/base/base_view_model.dart';
import 'package:final_proj/data/models/transaction/transaction_models.dart';
import 'package:final_proj/presentation/viewmodels/transaction_view_model.dart';
import 'package:final_proj/presentation/widgets/auth/auth_widgets.dart';
import 'package:final_proj/presentation/widgets/common/common_widgets.dart';
import 'package:final_proj/presentation/widgets/transaction/transaction_widgets.dart';
import 'package:final_proj/utils/constants/transaction_constants.dart';

/// Add transaction bottom sheet
class AddTransactionBottomSheet extends StatefulWidget {
  final VoidCallback? onSuccess;

  const AddTransactionBottomSheet({
    Key? key,
    this.onSuccess,
  }) : super(key: key);

  @override
  State<AddTransactionBottomSheet> createState() =>
      _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState extends State<AddTransactionBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedType = TransactionConstants.EXPENSE;
  String _selectedCategory = TransactionConstants.expenseCategories[0];
  String _selectedPaymentMethod = TransactionConstants.paymentMethods[0];
  DateTime _selectedDate = DateTime.now();
  bool _isRecurring = false;
  String? _recurringFrequency;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleAddTransaction() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<TransactionViewModel>();
      final success = await viewModel.addTransaction(
        title: _titleController.text.trim(),
        category: _selectedCategory,
        amount: double.parse(_amountController.text),
        type: _selectedType,
        description: _descriptionController.text.trim(),
        date: _selectedDate,
        paymentMethod: _selectedPaymentMethod,
        isRecurring: _isRecurring,
        recurringFrequency: _recurringFrequency,
        notes: _notesController.text.trim(),
      );

      if (mounted && success) {
        widget.onSuccess?.call();
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = _selectedType == TransactionConstants.INCOME
        ? TransactionConstants.incomeCategories
        : TransactionConstants.expenseCategories;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              'Add Transaction',
              style: AppTextStyles.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Form
            Consumer<TransactionViewModel>(
              builder: (context, viewModel, _) {
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Type selector (Income/Expense)
                      Text(
                        'Transaction Type',
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _TypeButton(
                              label: 'Income',
                              isSelected:
                                  _selectedType == TransactionConstants.INCOME,
                              onPressed: () {
                                setState(() {
                                  _selectedType =
                                      TransactionConstants.INCOME;
                                  _selectedCategory =
                                      TransactionConstants.incomeCategories[0];
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _TypeButton(
                              label: 'Expense',
                              isSelected:
                                  _selectedType == TransactionConstants.EXPENSE,
                              onPressed: () {
                                setState(() {
                                  _selectedType =
                                      TransactionConstants.EXPENSE;
                                  _selectedCategory =
                                      TransactionConstants.expenseCategories[0];
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Category selector
                      Text(
                        'Category',
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      CategorySelector(
                        categories: categories,
                        selectedCategory: _selectedCategory,
                        onCategorySelected: (category) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        isExpense:
                            _selectedType == TransactionConstants.EXPENSE,
                      ),
                      const SizedBox(height: 24),

                      // Title field
                      AuthTextField(
                        controller: _titleController,
                        labelText: 'Title',
                        hintText: 'Enter transaction title',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Title is required';
                          }
                          if (value.length < 3) {
                            return 'Title must be at least 3 characters';
                          }
                          return null;
                        },
                        enabled: viewModel.state !=
                            RequestState.loading,
                      ),
                      const SizedBox(height: 16),

                      // Amount field
                      AuthTextField(
                        controller: _amountController,
                        labelText: 'Amount',
                        hintText: 'Enter amount',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Amount is required';
                          }
                          try {
                            final amount = double.parse(value);
                            if (amount <= 0) {
                              return 'Amount must be greater than 0';
                            }
                          } catch (e) {
                            return 'Invalid amount';
                          }
                          return null;
                        },
                        enabled: viewModel.state !=
                            RequestState.loading,
                      ),
                      const SizedBox(height: 16),

                      // Description field
                      AuthTextField(
                        controller: _descriptionController,
                        labelText: 'Description',
                        hintText: 'Optional description',
                        maxLines: 2,
                        minLines: 2,
                        enabled: viewModel.state !=
                            RequestState.loading,
                      ),
                      const SizedBox(height: 16),

                      // Payment method
                      Text(
                        'Payment Method',
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedPaymentMethod,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedPaymentMethod = value;
                            });
                          }
                        },
                        items: TransactionConstants.paymentMethods
                            .map((method) => DropdownMenuItem(
                                  value: method,
                                  child: Text(method),
                                ))
                            .toList(),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.borderColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.borderColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Date picker
                      Text(
                        'Date',
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() {
                              _selectedDate = date;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.borderColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedDate.toString().split(' ')[0],
                                style: AppTextStyles.bodyMedium,
                              ),
                              const Icon(Icons.calendar_today,
                                  color: AppColors.primary),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Recurring option
                      CheckboxListTile(
                        value: _isRecurring,
                        onChanged: (value) {
                          setState(() {
                            _isRecurring = value ?? false;
                          });
                        },
                        title: Text(
                          'Recurring Transaction',
                          style: AppTextStyles.bodyMedium,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      if (_isRecurring) ...[
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _recurringFrequency ?? 'monthly',
                          onChanged: (value) {
                            setState(() {
                              _recurringFrequency = value;
                            });
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 'daily',
                              child: Text('Daily'),
                            ),
                            DropdownMenuItem(
                              value: 'weekly',
                              child: Text('Weekly'),
                            ),
                            DropdownMenuItem(
                              value: 'monthly',
                              child: Text('Monthly'),
                            ),
                            DropdownMenuItem(
                              value: 'yearly',
                              child: Text('Yearly'),
                            ),
                          ],
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Notes field
                      AuthTextField(
                        controller: _notesController,
                        labelText: 'Notes',
                        hintText: 'Add notes (optional)',
                        maxLines: 2,
                        minLines: 2,
                        enabled: viewModel.state !=
                            RequestState.loading,
                      ),
                      const SizedBox(height: 24),

                      // Error message
                      if (viewModel.state == RequestState.error)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            viewModel.errorMessage ?? 'Failed to add transaction',
                            style: AppTextStyles.bodySmall
                                .copyWith(color: AppColors.error),
                          ),
                        ),
                      if (viewModel.state == RequestState.error)
                        const SizedBox(height: 16),

                      // Add button
                      CustomButton(
                        label: viewModel.state == RequestState.loading
                            ? 'Adding...'
                            : 'Add Transaction',
                        onPressed: viewModel.state != RequestState.loading
                            ? _handleAddTransaction
                            : null,
                        isLoading: viewModel.state == RequestState.loading,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Type selection button
class _TypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _TypeButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.primary : AppColors.surfaceLight,
        foregroundColor:
            isSelected ? AppColors.white : AppColors.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(label),
    );
  }
}

/// Edit transaction bottom sheet
class EditTransactionBottomSheet extends StatefulWidget {
  final TransactionModel transaction;
  final VoidCallback? onSuccess;

  const EditTransactionBottomSheet({
    Key? key,
    required this.transaction,
    this.onSuccess,
  }) : super(key: key);

  @override
  State<EditTransactionBottomSheet> createState() =>
      _EditTransactionBottomSheetState();
}

class _EditTransactionBottomSheetState
    extends State<EditTransactionBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late TextEditingController _notesController;

  late String _selectedType;
  late String _selectedCategory;
  late String _selectedPaymentMethod;
  late DateTime _selectedDate;
  late bool _isRecurring;
  String? _recurringFrequency;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.transaction.title);
    _amountController = TextEditingController(
      text: widget.transaction.amount.toString(),
    );
    _descriptionController = TextEditingController(
      text: widget.transaction.description,
    );
    _notesController = TextEditingController(text: widget.transaction.notes);
    _selectedType = widget.transaction.type;
    _selectedCategory = widget.transaction.category;
    _selectedPaymentMethod = widget.transaction.paymentMethod;
    _selectedDate = widget.transaction.date;
    _isRecurring = widget.transaction.isRecurring;
    _recurringFrequency = widget.transaction.recurringFrequency;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleUpdateTransaction() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<TransactionViewModel>();
      final success = await viewModel.updateTransaction(
        id: widget.transaction.id,
        title: _titleController.text.trim(),
        category: _selectedCategory,
        amount: double.parse(_amountController.text),
        type: _selectedType,
        description: _descriptionController.text.trim(),
        date: _selectedDate,
        paymentMethod: _selectedPaymentMethod,
        isRecurring: _isRecurring,
        recurringFrequency: _recurringFrequency,
        notes: _notesController.text.trim(),
      );

      if (mounted && success) {
        widget.onSuccess?.call();
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = _selectedType == TransactionConstants.INCOME
        ? TransactionConstants.incomeCategories
        : TransactionConstants.expenseCategories;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              'Edit Transaction',
              style: AppTextStyles.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Form (same as AddTransactionBottomSheet, but calls update)
            Consumer<TransactionViewModel>(
              builder: (context, viewModel, _) {
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Type selector
                      Text(
                        'Transaction Type',
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _TypeButton(
                              label: 'Income',
                              isSelected:
                                  _selectedType == TransactionConstants.INCOME,
                              onPressed: () {
                                setState(() {
                                  _selectedType =
                                      TransactionConstants.INCOME;
                                  _selectedCategory =
                                      TransactionConstants.incomeCategories[0];
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _TypeButton(
                              label: 'Expense',
                              isSelected:
                                  _selectedType == TransactionConstants.EXPENSE,
                              onPressed: () {
                                setState(() {
                                  _selectedType =
                                      TransactionConstants.EXPENSE;
                                  _selectedCategory =
                                      TransactionConstants.expenseCategories[0];
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Category selector
                      Text(
                        'Category',
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      CategorySelector(
                        categories: categories,
                        selectedCategory: _selectedCategory,
                        onCategorySelected: (category) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        isExpense:
                            _selectedType == TransactionConstants.EXPENSE,
                      ),
                      const SizedBox(height: 24),

                      // Title field
                      AuthTextField(
                        controller: _titleController,
                        labelText: 'Title',
                        hintText: 'Enter transaction title',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Title is required';
                          }
                          return null;
                        },
                        enabled: viewModel.state != RequestState.loading,
                      ),
                      const SizedBox(height: 16),

                      // Amount field
                      AuthTextField(
                        controller: _amountController,
                        labelText: 'Amount',
                        hintText: 'Enter amount',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Amount is required';
                          }
                          return null;
                        },
                        enabled: viewModel.state != RequestState.loading,
                      ),
                      const SizedBox(height: 16),

                      // Description field
                      AuthTextField(
                        controller: _descriptionController,
                        labelText: 'Description',
                        hintText: 'Optional description',
                        maxLines: 2,
                        minLines: 2,
                        enabled: viewModel.state != RequestState.loading,
                      ),
                      const SizedBox(height: 16),

                      // Payment method
                      Text(
                        'Payment Method',
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedPaymentMethod,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedPaymentMethod = value;
                            });
                          }
                        },
                        items: TransactionConstants.paymentMethods
                            .map((method) => DropdownMenuItem(
                                  value: method,
                                  child: Text(method),
                                ))
                            .toList(),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Notes field
                      AuthTextField(
                        controller: _notesController,
                        labelText: 'Notes',
                        hintText: 'Add notes (optional)',
                        maxLines: 2,
                        minLines: 2,
                        enabled: viewModel.state != RequestState.loading,
                      ),
                      const SizedBox(height: 24),

                      // Error message
                      if (viewModel.state == RequestState.error)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            viewModel.errorMessage ??
                                'Failed to update transaction',
                            style: AppTextStyles.bodySmall
                                .copyWith(color: AppColors.error),
                          ),
                        ),
                      if (viewModel.state == RequestState.error)
                        const SizedBox(height: 16),

                      // Update button
                      CustomButton(
                        label: viewModel.state == RequestState.loading
                            ? 'Updating...'
                            : 'Update Transaction',
                        onPressed: viewModel.state != RequestState.loading
                            ? _handleUpdateTransaction
                            : null,
                        isLoading: viewModel.state == RequestState.loading,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
