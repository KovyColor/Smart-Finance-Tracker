import 'package:final_proj/core/base/base_repository.dart';
import 'package:final_proj/data/models/transaction/transaction_models.dart';
import 'package:final_proj/data/services/hive/hive_transaction_service.dart';

/// Transaction repository - handles local and remote storage
class TransactionRepository extends BaseRepository {
  final HiveTransactionService hiveService;

  TransactionRepository({required this.hiveService});

  /// Add a new transaction
  Future<void> addTransaction(TransactionModel transaction) async {
    return execute(
      operation: () async {
        return await hiveService.addTransaction(transaction);
      },
      errorMessage: 'Failed to add transaction',
    );
  }

  /// Get transaction by ID
  Future<TransactionModel?> getTransaction(String id) async {
    return execute(
      operation: () async {
        return await hiveService.getTransaction(id);
      },
      errorMessage: 'Failed to fetch transaction',
    );
  }

  /// Get all transactions
  Future<List<TransactionModel>> getAllTransactions() async {
    return execute(
      operation: () async {
        return await hiveService.getAllTransactions();
      },
      errorMessage: 'Failed to fetch transactions',
    );
  }

  /// Get transactions for date range
  Future<List<TransactionModel>> getTransactionsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return execute(
      operation: () async {
        return await hiveService.getTransactionsByDateRange(
          startDate: startDate,
          endDate: endDate,
        );
      },
      errorMessage: 'Failed to fetch transactions',
    );
  }

  /// Get transactions by category
  Future<List<TransactionModel>> getTransactionsByCategory(
    String category,
  ) async {
    return execute(
      operation: () async {
        return await hiveService.getTransactionsByCategory(category);
      },
      errorMessage: 'Failed to fetch transactions',
    );
  }

  /// Get transactions by type
  Future<List<TransactionModel>> getTransactionsByType(String type) async {
    return execute(
      operation: () async {
        return await hiveService.getTransactionsByType(type);
      },
      errorMessage: 'Failed to fetch transactions',
    );
  }

  /// Get recent transactions
  Future<List<TransactionModel>> getRecentTransactions({
    int limit = 10,
  }) async {
    return execute(
      operation: () async {
        return await hiveService.getRecentTransactions(limit: limit);
      },
      errorMessage: 'Failed to fetch recent transactions',
    );
  }

  /// Update transaction
  Future<void> updateTransaction(TransactionModel transaction) async {
    return execute(
      operation: () async {
        return await hiveService.updateTransaction(transaction);
      },
      errorMessage: 'Failed to update transaction',
    );
  }

  /// Delete transaction
  Future<void> deleteTransaction(String id) async {
    return execute(
      operation: () async {
        return await hiveService.deleteTransaction(id);
      },
      errorMessage: 'Failed to delete transaction',
    );
  }

  /// Delete transactions by date
  Future<void> deleteTransactionsByDate(DateTime date) async {
    return execute(
      operation: () async {
        return await hiveService.deleteTransactionsByDate(date);
      },
      errorMessage: 'Failed to delete transactions',
    );
  }

  /// Clear all transactions
  Future<void> clearAllTransactions() async {
    return execute(
      operation: () async {
        return await hiveService.clearAllTransactions();
      },
      errorMessage: 'Failed to clear transactions',
    );
  }

  /// Get transaction count
  Future<int> getTransactionCount() async {
    return execute(
      operation: () async {
        return await hiveService.getTransactionCount();
      },
      errorMessage: 'Failed to get transaction count',
    );
  }

  /// Search transactions
  Future<List<TransactionModel>> searchTransactions(String query) async {
    return execute(
      operation: () async {
        return await hiveService.searchTransactions(query);
      },
      errorMessage: 'Failed to search transactions',
    );
  }

  /// Get unsynced transactions (for Firestore)
  Future<List<TransactionModel>> getUnsyncedTransactions() async {
    return execute(
      operation: () async {
        return await hiveService.getUnsyncedTransactions();
      },
      errorMessage: 'Failed to fetch unsynced transactions',
    );
  }

  /// Mark transaction as synced
  Future<void> markTransactionAsSynced(String id) async {
    return execute(
      operation: () async {
        return await hiveService.markTransactionAsSynced(id);
      },
      errorMessage: 'Failed to mark transaction as synced',
    );
  }

  /// Sync transactions to Firestore (TODO: Backend integration)
  Future<void> syncToFirestore({
    required List<TransactionModel> transactions,
  }) async {
    return execute(
      operation: () async {
        // TODO: Implement Firestore sync
        // - Upload transactions to Firestore
        // - Update local sync status
        // - Handle conflicts
        for (final transaction in transactions) {
          await markTransactionAsSynced(transaction.id);
        }
      },
      errorMessage: 'Failed to sync transactions',
    );
  }

  /// Calculate summary for transactions
  Future<TransactionSummary> getTransactionSummary({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return execute(
      operation: () async {
        List<TransactionModel> transactions;

        if (startDate != null && endDate != null) {
          transactions = await hiveService.getTransactionsByDateRange(
            startDate: startDate,
            endDate: endDate,
          );
        } else {
          transactions = await hiveService.getAllTransactions();
        }

        double totalIncome = 0;
        double totalExpense = 0;
        final categoryBreakdown = <String, double>{};

        for (final transaction in transactions) {
          if (transaction.type == 'income') {
            totalIncome += transaction.amount;
          } else {
            totalExpense += transaction.amount;
          }

          categoryBreakdown[transaction.category] =
              (categoryBreakdown[transaction.category] ?? 0) +
                  transaction.amount;
        }

        return TransactionSummary(
          totalIncome: totalIncome,
          totalExpense: totalExpense,
          balance: totalIncome - totalExpense,
          transactionCount: transactions.length,
          categoryBreakdown: categoryBreakdown,
        );
      },
      errorMessage: 'Failed to calculate summary',
    );
  }
}
