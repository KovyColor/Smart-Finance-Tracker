/// Transaction-related constants
class TransactionConstants {
  // Private constructor
  TransactionConstants._();

  // Transaction types
  static const String INCOME = 'income';
  static const String EXPENSE = 'expense';

  static const List<String> transactionTypes = [INCOME, EXPENSE];

  // Transaction categories - Expenses
  static const List<String> expenseCategories = [
    'Food & Dining',
    'Shopping',
    'Transportation',
    'Entertainment',
    'Utilities',
    'Healthcare',
    'Education',
    'Subscriptions',
    'Other Expenses',
  ];

  // Transaction categories - Income
  static const List<String> incomeCategories = [
    'Salary',
    'Freelance',
    'Investment',
    'Bonus',
    'Refund',
    'Other Income',
  ];

  // Payment methods
  static const List<String> paymentMethods = [
    'Cash',
    'Credit Card',
    'Debit Card',
    'Bank Transfer',
    'Digital Wallet',
    'Cheque',
    'Other',
  ];

  // Hive box names
  static const String transactionBoxName = 'transactions';
  static const String categoryBoxName = 'transaction_categories';

  // Default currency
  static const String defaultCurrency = 'USD';

  // Transaction statuses
  static const String pending = 'pending';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';

  // Icon map for categories
  static const Map<String, String> categoryIcons = {
    'Food & Dining': '🍔',
    'Shopping': '🛍️',
    'Transportation': '🚗',
    'Entertainment': '🎬',
    'Utilities': '💡',
    'Healthcare': '🏥',
    'Education': '📚',
    'Subscriptions': '📱',
    'Other Expenses': '📦',
    'Salary': '💰',
    'Freelance': '💼',
    'Investment': '📈',
    'Bonus': '🎁',
    'Refund': '↩️',
    'Other Income': '💵',
  };

  // Color codes for categories
  static const Map<String, int> categoryColors = {
    'Food & Dining': 0xFFE74C3C,
    'Shopping': 0xFFC0392B,
    'Transportation': 0xFF3498DB,
    'Entertainment': 0xFF9B59B6,
    'Utilities': 0xFFF39C12,
    'Healthcare': 0xFF1ABC9C,
    'Education': 0xFF2980B9,
    'Subscriptions': 0xFF34495E,
    'Other Expenses': 0xFF95A5A6,
    'Salary': 0xFF27AE60,
    'Freelance': 0xFF16A085,
    'Investment': 0xFF2ECC71,
    'Bonus': 0xFF1E8449,
    'Refund': 0xFF145A32,
    'Other Income': 0xFF239B56,
  };
}
