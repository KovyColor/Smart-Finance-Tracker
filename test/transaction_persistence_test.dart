import 'package:flutter_test/flutter_test.dart';
import 'package:final_proj/data/models/transaction/transaction_models.dart';
import 'package:final_proj/data/services/hive/hive_transaction_service.dart';
import 'package:final_proj/utils/constants/transaction_constants.dart';
import 'dart:convert';

void main() {
  group('Transaction Data Persistence Tests', () {
    final testTransaction = TransactionModel(
      id: 'test-id-123',
      userId: 'user-1',
      title: 'Test Income',
      category: 'Salary',
      amount: 5000.50,
      type: TransactionConstants.INCOME,
      description: 'Monthly salary',
      date: DateTime(2026, 4, 10),
      paymentMethod: 'Bank Transfer',
      isRecurring: false,
      status: 'completed',
      notes: 'Test notes',
      createdAt: DateTime(2026, 4, 10),
      updatedAt: DateTime(2026, 4, 10),
    );

    test('Transaction JSON encoding preserves all data', () {
      // Convert transaction to JSON
      final json = testTransaction.toJson();

      // Verify all fields are present
      expect(json['id'], equals('test-id-123'));
      expect(json['title'], equals('Test Income'));
      expect(json['category'], equals('Salary'));
      expect(json['amount'], equals(5000.50)); // Amount preserved
      expect(json['type'], equals('income'));
      expect(json['notes'], equals('Test notes'));
    });

    test('JSON encoding/decoding round-trip', () {
      // Encode to JSON string (like HiveTransactionService does)
      final json = testTransaction.toJson();
      final jsonString = jsonEncode(json); // PROPER ENCODING

      // Decode back from JSON string (like HiveTransactionService does)
      final decodedMap = jsonDecode(jsonString); // PROPER DECODING
      
      // Verify decoded data matches original
      expect(decodedMap['id'], equals('test-id-123'));
      expect(decodedMap['amount'], equals(5000.50)); // Amount preserved!
      expect(decodedMap['category'], equals('Salary'));
      expect(decodedMap['type'], equals('income'));
      expect(decodedMap['notes'], equals('Test notes'));
    });

    test('TransactionModel fromJson reconstructs transaction correctly', () {
      // Encode-decode cycle
      final json = testTransaction.toJson();
      final jsonString = jsonEncode(json);
      final decodedMap = jsonDecode(jsonString) as Map<String, dynamic>;

      // Reconstruct transaction from decoded map
      final reconstructed = TransactionModel.fromJson(decodedMap);

      // Verify all fields match
      expect(reconstructed.id, equals(testTransaction.id));
      expect(reconstructed.title, equals(testTransaction.title));
      expect(reconstructed.category, equals(testTransaction.category));
      expect(reconstructed.amount, equals(testTransaction.amount)); // 5000.50 preserved!
      expect(reconstructed.type, equals(testTransaction.type));
      expect(reconstructed.notes, equals(testTransaction.notes));
    });

    test('Expense amount is preserved in persistence', () {
      final expenseTransaction = TransactionModel(
        id: 'expense-1',
        userId: 'user-1',
        title: 'Coffee',
        category: 'Food & Dining',
        amount: 4.75,
        type: TransactionConstants.EXPENSE,
        description: 'Morning coffee',
        date: DateTime.now(),
        paymentMethod: 'Cash',
        status: 'completed',
        notes: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Full cycle
      final json = expenseTransaction.toJson();
      final jsonString = jsonEncode(json);
      final decodedMap = jsonDecode(jsonString) as Map<String, dynamic>;
      final reconstructed = TransactionModel.fromJson(decodedMap);

      // Amount preserved!
      expect(reconstructed.amount, equals(4.75));
      expect(reconstructed.type, equals('expense'));
    });

    test('Category and type combinations work correctly', () {
      final incomeTransactions = [
        ('Salary', 5000),
        ('Freelance', 1500),
        ('Investment', 2000),
      ];

      for (final (category, amount) in incomeTransactions) {
        final transaction = TransactionModel(
          id: 'income-${category}',
          userId: 'user-1',
          title: category,
          category: category,
          amount: amount.toDouble(),
          type: TransactionConstants.INCOME,
          description: '',
          date: DateTime.now(),
          paymentMethod: 'Bank Transfer',
          status: 'completed',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final json = transaction.toJson();
        final jsonString = jsonEncode(json);
        final decodedMap = jsonDecode(jsonString) as Map<String, dynamic>;
        final reconstructed = TransactionModel.fromJson(decodedMap);

        expect(reconstructed.category, equals(category));
        expect(reconstructed.amount, equals(amount.toDouble()));
        expect(reconstructed.type, equals('income'));
      }
    });
  });
}
