import 'package:final_proj/core/base/base_view_model.dart';
import 'package:final_proj/core/errors/error_handler.dart';
import 'package:final_proj/data/models/transaction/transaction_models.dart';
import 'package:final_proj/data/repositories/transaction_repository.dart';
import 'package:uuid/uuid.dart';

/// Transaction ViewModel - handles transaction logic
class TransactionViewModel extends BaseViewModel {
  final TransactionRepository repository;

  List<TransactionModel> _transactions = [];
  List<TransactionModel> _filteredTransactions = [];
  TransactionSummary? _summary;
  TransactionFilter? _currentFilter;

  // Getters
  List<TransactionModel> get transactions => _filteredTransactions.isEmpty
      ? _transactions
      : _filteredTransactions;
  TransactionSummary? get summary => _summary;
  List<TransactionModel> get recentTransactions =>
      _transactions.take(5).toList();
  int get transactionCount => _transactions.length;

  TransactionViewModel({required this.repository});

  /// Initialize - load all transactions
  Future<void> initialize() async {
    setLoading(true);
    try {
      _transactions = await repository.getAllTransactions();
      await _loadSummary();
      setSuccess();
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      setError(ErrorHandler.getUserMessage(exception));
    }
  }

  /// Add new transaction
  Future<bool> addTransaction({
    required String title,
    required String category,
    required double amount,
    required String type,
    required String description,
    required DateTime date,
    required String paymentMethod,
    bool isRecurring = false,
    String? recurringFrequency,
    String? notes,
  }) async {
    setLoading(true);
    try {
      if (title.isEmpty || amount <= 0) {
        setError('Please enter valid transaction details');
        return false;
      }

      final transaction = TransactionModel(
        id: const Uuid().v4(),
        userId: 'current-user-id', // TODO: Get from auth
        title: title,
        category: category,
        amount: amount,
        type: type,
        description: description,
        date: date,
        paymentMethod: paymentMethod,
        isRecurring: isRecurring,
        recurringFrequency: recurringFrequency,
        status: 'completed',
        notes: notes,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repository.addTransaction(transaction);
      _transactions.insert(0, transaction);
      await _loadSummary();
      notifyListeners(); // Notify listeners of state change

      setSuccess(message: 'Transaction added successfully');
      return true;
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      setError(ErrorHandler.getUserMessage(exception));
      return false;
    }
  }

  /// Update existing transaction
  Future<bool> updateTransaction({
    required String id,
    required String title,
    required String category,
    required double amount,
    required String type,
    required String description,
    required DateTime date,
    required String paymentMethod,
    bool isRecurring = false,
    String? recurringFrequency,
    String? notes,
  }) async {
    setLoading(true);
    try {
      if (title.isEmpty || amount <= 0) {
        setError('Please enter valid transaction details');
        return false;
      }

      final transaction = TransactionModel(
        id: id,
        userId: 'current-user-id',
        title: title,
        category: category,
        amount: amount,
        type: type,
        description: description,
        date: date,
        paymentMethod: paymentMethod,
        isRecurring: isRecurring,
        recurringFrequency: recurringFrequency,
        status: 'completed',
        notes: notes,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repository.updateTransaction(transaction);
      final index = _transactions.indexWhere((t) => t.id == id);
      if (index != -1) {
        _transactions[index] = transaction;
      }
      await _loadSummary();
      notifyListeners(); // Notify listeners of state change

      setSuccess(message: 'Transaction updated successfully');
      return true;
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      setError(ErrorHandler.getUserMessage(exception));
      return false;
    }
  }

  /// Delete transaction
  Future<bool> deleteTransaction(String id) async {
    try {
      setLoading(true);
      await repository.deleteTransaction(id);
      _transactions.removeWhere((t) => t.id == id);
      await _loadSummary();
      notifyListeners(); // Notify listeners of state change

      setSuccess(message: 'Transaction deleted');
      return true;
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      setError(ErrorHandler.getUserMessage(exception));
      return false;
    }
  }

  /// Get transaction by ID
  Future<TransactionModel?> getTransaction(String id) async {
    try {
      return await repository.getTransaction(id);
    } catch (e) {
      return null;
    }
  }

  /// Filter transactions
  void filterTransactions(TransactionFilter filter) {
    _currentFilter = filter;
    _filteredTransactions = _transactions.where((transaction) {
      // Type filter
      if (filter.type != null && transaction.type != filter.type) {
        return false;
      }

      // Category filter
      if (filter.category != null && transaction.category != filter.category) {
        return false;
      }

      // Date range filter
      if (filter.startDate != null &&
          transaction.date.isBefore(filter.startDate!)) {
        return false;
      }
      if (filter.endDate != null &&
          transaction.date.isAfter(filter.endDate!)) {
        return false;
      }

      // Amount range filter
      if (filter.minAmount != null && transaction.amount < filter.minAmount!) {
        return false;
      }
      if (filter.maxAmount != null && transaction.amount > filter.maxAmount!) {
        return false;
      }

      // Payment method filter
      if (filter.paymentMethod != null &&
          transaction.paymentMethod != filter.paymentMethod) {
        return false;
      }

      // Search query filter
      if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
        final query = filter.searchQuery!.toLowerCase();
        return transaction.title.toLowerCase().contains(query) ||
            transaction.description.toLowerCase().contains(query) ||
            transaction.category.toLowerCase().contains(query);
      }

      return true;
    }).toList();

    notifyListeners();
  }

  /// Clear filters
  void clearFilters() {
    _currentFilter = null;
    _filteredTransactions = [];
    notifyListeners();
  }

  /// Search transactions
  Future<void> searchTransactions(String query) async {
    try {
      setLoading(true);
      if (query.isEmpty) {
        _filteredTransactions = [];
      } else {
        _filteredTransactions =
            await repository.searchTransactions(query);
      }
      setSuccess();
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      setError(ErrorHandler.getUserMessage(exception));
    }
  }

  /// Get transactions by date range
  Future<void> getTransactionsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    setLoading(true);
    try {
      _filteredTransactions =
          await repository.getTransactionsByDateRange(
        startDate: startDate,
        endDate: endDate,
      );
      setSuccess();
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      setError(ErrorHandler.getUserMessage(exception));
    }
  }

  /// Get transactions by category
  Future<void> getTransactionsByCategory(String category) async {
    setLoading(true);
    try {
      _filteredTransactions =
          await repository.getTransactionsByCategory(category);
      setSuccess();
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      setError(ErrorHandler.getUserMessage(exception));
    }
  }

  /// Get transactions by type (income/expense)
  Future<void> getTransactionsByType(String type) async {
    setLoading(true);
    try {
      _filteredTransactions =
          await repository.getTransactionsByType(type);
      setSuccess();
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      setError(ErrorHandler.getUserMessage(exception));
    }
  }

  /// Refresh transactions
  Future<void> refreshTransactions() async {
    try {
      _transactions = await repository.getAllTransactions();
      await _loadSummary();
      notifyListeners();
    } catch (e) {
      print('Error refreshing transactions: $e');
    }
  }

  /// Load summary
  Future<void> _loadSummary() async {
    try {
      _summary = await repository.getTransactionSummary();
      notifyListeners();
    } catch (e) {
      print('Error loading summary: $e');
    }
  }

  /// Sync to Firestore
  Future<void> syncToFirestore() async {
    try {
      setLoading(true);
      final unsyncedTransactions =
          await repository.getUnsyncedTransactions();
      if (unsyncedTransactions.isNotEmpty) {
        await repository.syncToFirestore(
          transactions: unsyncedTransactions,
        );
      }
      setSuccess(message: 'Transactions synced');
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      setError(ErrorHandler.getUserMessage(exception));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _transactions.clear();
    _filteredTransactions.clear();
  }
}
