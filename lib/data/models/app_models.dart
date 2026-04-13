import 'package:final_proj/core/base/base_model.dart';
import 'package:equatable/equatable.dart';

/// User model - example model for the data layer
class UserModel extends BaseModel {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final String? phone;
  final String? bio;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    this.phone,
    this.bio,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'],
      phone: json['phone'],
      bio: json['bio'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'phone': phone,
      'bio': bio,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy with modifications
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    String? phone,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    profileImage,
    phone,
    bio,
    createdAt,
    updatedAt,
  ];
}

/// Transaction model - example model for the data layer
class TransactionModel extends BaseModel {
  final String id;
  final String userId;
  final String title;
  final String category;
  final double amount;
  final String type; // 'income' or 'expense'
  final String? description;
  final DateTime date;
  final String? paymentMethod;
  final bool isRecurring;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TransactionModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.category,
    required this.amount,
    required this.type,
    this.description,
    required this.date,
    this.paymentMethod,
    this.isRecurring = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from JSON
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      type: json['type'] ?? 'expense',
      description: json['description'],
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      paymentMethod: json['paymentMethod'],
      isRecurring: json['isRecurring'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
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
    DateTime? createdAt,
    DateTime? updatedAt,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    createdAt,
    updatedAt,
  ];
}

/// Budget model - example model for the data layer
class BudgetModel extends BaseModel {
  final String id;
  final String userId;
  final String category;
  final double limit;
  final double spent;
  final String currency;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BudgetModel({
    required this.id,
    required this.userId,
    required this.category,
    required this.limit,
    required this.spent,
    required this.currency,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from JSON
  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      category: json['category'] ?? '',
      limit: (json['limit'] as num?)?.toDouble() ?? 0.0,
      spent: (json['spent'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'USD',
      startDate: DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['endDate'] ?? '') ?? DateTime.now(),
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'category': category,
      'limit': limit,
      'spent': spent,
      'currency': currency,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Get remaining budget
  double get remaining => limit - spent;

  /// Get budget percentage used (0-100)
  double get percentageUsed => (spent / limit) * 100;

  /// Check if budget is exceeded
  bool get isExceeded => spent > limit;

  /// Create a copy with modifications
  BudgetModel copyWith({
    String? id,
    String? userId,
    String? category,
    double? limit,
    double? spent,
    String? currency,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      limit: limit ?? this.limit,
      spent: spent ?? this.spent,
      currency: currency ?? this.currency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    category,
    limit,
    spent,
    currency,
    startDate,
    endDate,
    isActive,
    createdAt,
    updatedAt,
  ];
}
