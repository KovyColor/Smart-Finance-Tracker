import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:final_proj/core/base/base_service.dart';
import 'package:final_proj/data/models/transaction/transaction_models.dart';
import 'package:final_proj/utils/constants/transaction_constants.dart';

/// Hive storage service for local transaction persistence
class HiveTransactionService extends BaseService {
  late Box<String> _transactionBox;

  @override
  Future<void> initialize() async {
    try {
      _transactionBox = await Hive.openBox<String>(
        TransactionConstants.transactionBoxName,
      );
      print('HiveTransactionService initialized');
    } catch (e) {
      print('Error initializing HiveTransactionService: $e');
      rethrow;
    }
  }

  @override
  Future<void> dispose() async {
    try {
      await _transactionBox.close();
    } catch (e) {
      print('Error disposing HiveTransactionService: $e');
    }
  }

  /// Add a transaction
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await _transactionBox.put(
        transaction.id,
        _encodeTransaction(transaction),
      );
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  /// Get transaction by ID
  Future<TransactionModel?> getTransaction(String id) async {
    try {
      final json = _transactionBox.get(id);
      if (json != null) {
        return TransactionModel.fromJson(_decodeJson(json));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get transaction: $e');
    }
  }

  /// Get all transactions
  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      final transactions = <TransactionModel>[];
      for (final json in _transactionBox.values) {
        transactions.add(TransactionModel.fromJson(_decodeJson(json)));
      }
      // Sort by date descending
      transactions.sort((a, b) => b.date.compareTo(a.date));
      return transactions;
    } catch (e) {
      throw Exception('Failed to get all transactions: $e');
    }
  }

  /// Get transactions for date range
  Future<List<TransactionModel>> getTransactionsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final allTransactions = await getAllTransactions();
      return allTransactions
          .where((t) =>
              t.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
              t.date.isBefore(endDate.add(const Duration(days: 1))))
          .toList();
    } catch (e) {
      throw Exception('Failed to get transactions by date range: $e');
    }
  }

  /// Get transactions by category
  Future<List<TransactionModel>> getTransactionsByCategory(
    String category,
  ) async {
    try {
      final allTransactions = await getAllTransactions();
      return allTransactions.where((t) => t.category == category).toList();
    } catch (e) {
      throw Exception('Failed to get transactions by category: $e');
    }
  }

  /// Get transactions by type (income/expense)
  Future<List<TransactionModel>> getTransactionsByType(String type) async {
    try {
      final allTransactions = await getAllTransactions();
      return allTransactions.where((t) => t.type == type).toList();
    } catch (e) {
      throw Exception('Failed to get transactions by type: $e');
    }
  }

  /// Get recent transactions
  Future<List<TransactionModel>> getRecentTransactions({int limit = 10}) async {
    try {
      final allTransactions = await getAllTransactions();
      return allTransactions.take(limit).toList();
    } catch (e) {
      throw Exception('Failed to get recent transactions: $e');
    }
  }

  /// Update transaction
  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await _transactionBox.put(
        transaction.id,
        _encodeTransaction(transaction.copyWith(
          updatedAt: DateTime.now(),
        )),
      );
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  /// Delete transaction
  Future<void> deleteTransaction(String id) async {
    try {
      await _transactionBox.delete(id);
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }

  /// Delete transactions by date
  Future<void> deleteTransactionsByDate(DateTime date) async {
    try {
      final allTransactions = await getAllTransactions();
      final toDelete = allTransactions
          .where((t) =>
              t.date.year == date.year &&
              t.date.month == date.month &&
              t.date.day == date.day)
          .map((t) => t.id)
          .toList();

      for (final id in toDelete) {
        await _transactionBox.delete(id);
      }
    } catch (e) {
      throw Exception('Failed to delete transactions by date: $e');
    }
  }

  /// Clear all transactions
  Future<void> clearAllTransactions() async {
    try {
      await _transactionBox.clear();
    } catch (e) {
      throw Exception('Failed to clear all transactions: $e');
    }
  }

  /// Get transaction count
  Future<int> getTransactionCount() async {
    try {
      return _transactionBox.length;
    } catch (e) {
      throw Exception('Failed to get transaction count: $e');
    }
  }

  /// Search transactions
  Future<List<TransactionModel>> searchTransactions(String query) async {
    try {
      final allTransactions = await getAllTransactions();
      final lowerQuery = query.toLowerCase();
      return allTransactions
          .where((t) =>
              t.title.toLowerCase().contains(lowerQuery) ||
              t.category.toLowerCase().contains(lowerQuery) ||
              t.description.toLowerCase().contains(lowerQuery))
          .toList();
    } catch (e) {
      throw Exception('Failed to search transactions: $e');
    }
  }

  /// Get unsynced transactions (for Firestore sync)
  Future<List<TransactionModel>> getUnsyncedTransactions() async {
    try {
      final allTransactions = await getAllTransactions();
      return allTransactions
          .where((t) => t.isSyncedToFirestore == false)
          .toList();
    } catch (e) {
      throw Exception('Failed to get unsynced transactions: $e');
    }
  }

  /// Mark transaction as synced
  Future<void> markTransactionAsSynced(String id) async {
    try {
      final transaction = await getTransaction(id);
      if (transaction != null) {
        await updateTransaction(transaction.copyWith(
          isSyncedToFirestore: true,
        ));
      }
    } catch (e) {
      throw Exception('Failed to mark transaction as synced: $e');
    }
  }

  /// Encode transaction to JSON string
  String _encodeTransaction(TransactionModel transaction) {
    // Convert to map and then to JSON string
    final json = transaction.toJson();
    return jsonEncode(json); // Properly encode to JSON string
  }

  /// Decode JSON string to map
  Map<String, dynamic> _decodeJson(String jsonString) {
    // Properly decode JSON string to map
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      print('Error decoding transaction JSON: $e');
      return {};
    }
  }
}
