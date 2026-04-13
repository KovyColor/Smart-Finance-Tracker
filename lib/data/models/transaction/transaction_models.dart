import 'package:final_proj/core/base/base_model.dart';

/// Transaction model
class TransactionModel extends BaseModel {
  final String id;
  final String userId;
  final String title;
  final String category;
  final double amount;
  final String type; // 'income' or 'expense'
  final String description;
  final DateTime date;
  final String paymentMethod;
  final bool isRecurring;
  final String? recurringFrequency; // daily, weekly, monthly, yearly
  final String? attachmentUrl;
  final String status; // pending, completed, cancelled
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool? isSyncedToFirestore;

  const TransactionModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.category,
    required this.amount,
    required this.type,
    required this.description,
    required this.date,
    required this.paymentMethod,
    this.isRecurring = false,
    this.recurringFrequency,
    this.attachmentUrl,
    this.status = 'completed',
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.isSyncedToFirestore = false,
  });

  /// Create from JSON
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      type: json['type'] ?? 'expense',
      description: json['description'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      paymentMethod: json['paymentMethod'] ?? 'Cash',
      isRecurring: json['isRecurring'] ?? false,
      recurringFrequency: json['recurringFrequency'],
      attachmentUrl: json['attachmentUrl'],
      status: json['status'] ?? 'completed',
      notes: json['notes'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      isSyncedToFirestore: json['isSyncedToFirestore'] ?? false,
    );
  }

  /// Convert to JSON
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'category': category,
      'amount': amount,
      'type': type,
      'description': description,
      'date': date.toIso8601String(),
      'paymentMethod': paymentMethod,
      'isRecurring': isRecurring,
      'recurringFrequency': recurringFrequency,
      'attachmentUrl': attachmentUrl,
      'status': status,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isSyncedToFirestore': isSyncedToFirestore,
    };
  }

  /// Create a copy with modifications
  TransactionModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? category,
    double? amount,
    String? type,
    String? description,
    DateTime? date,
    String? paymentMethod,
    bool? isRecurring,
    String? recurringFrequency,
    String? attachmentUrl,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSyncedToFirestore,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      description: description ?? this.description,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringFrequency: recurringFrequency ?? this.recurringFrequency,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSyncedToFirestore: isSyncedToFirestore ?? this.isSyncedToFirestore,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    category,
    amount,
    type,
    description,
    date,
    paymentMethod,
    isRecurring,
    recurringFrequency,
    attachmentUrl,
    status,
    notes,
    createdAt,
    updatedAt,
    isSyncedToFirestore,
  ];
}

/// Transaction filter model
class TransactionFilter extends BaseModel {
  final String? type;
  final String? category;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? minAmount;
  final double? maxAmount;
  final String? paymentMethod;
  final String? searchQuery;

  const TransactionFilter({
    this.type,
    this.category,
    this.startDate,
    this.endDate,
    this.minAmount,
    this.maxAmount,
    this.paymentMethod,
    this.searchQuery,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'category': category,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'minAmount': minAmount,
      'maxAmount': maxAmount,
      'paymentMethod': paymentMethod,
      'searchQuery': searchQuery,
    };
  }

  @override
  List<Object?> get props => [
    type,
    category,
    startDate,
    endDate,
    minAmount,
    maxAmount,
    paymentMethod,
    searchQuery,
  ];
}

/// Transaction summary model
class TransactionSummary extends BaseModel {
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final int transactionCount;
  final Map<String, double> categoryBreakdown;

  const TransactionSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.transactionCount,
    required this.categoryBreakdown,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'balance': balance,
      'transactionCount': transactionCount,
      'categoryBreakdown': categoryBreakdown,
    };
  }

  @override
  List<Object?> get props => [
    totalIncome,
    totalExpense,
    balance,
    transactionCount,
    categoryBreakdown,
  ];
}
