import 'package:equatable/equatable.dart';

/// Base model class that provides value equality and immutability
abstract class BaseModel extends Equatable {
  const BaseModel();

  /// Convert model to JSON
  Map<String, dynamic> toJson();

  /// Get model copy with modifications
  @override
  List<Object?> get props => [];
}

/// Base response model for API responses
class ApiResponse<T> extends Equatable {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;

  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
  });

  /// Create from JSON
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      message: json['message'],
      statusCode: json['statusCode'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data,
      'message': message,
      'statusCode': statusCode,
    };
  }

  @override
  List<Object?> get props => [success, data, message, statusCode];
}

/// Pagination metadata model
class PaginationMeta extends Equatable {
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final int totalPages;

  const PaginationMeta({
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
  });

  /// Create from JSON
  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['currentPage'] ?? 1,
      pageSize: json['pageSize'] ?? 20,
      totalItems: json['totalItems'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'pageSize': pageSize,
      'totalItems': totalItems,
      'totalPages': totalPages,
    };
  }

  /// Check if there are more pages
  bool get hasNextPage => currentPage < totalPages;

  /// Get next page number
  int get nextPage => currentPage + 1;

  @override
  List<Object?> get props => [currentPage, pageSize, totalItems, totalPages];
}

/// Paginated response model
class PaginatedResponse<T> extends Equatable {
  final List<T> items;
  final PaginationMeta pagination;

  const PaginatedResponse({
    required this.items,
    required this.pagination,
  });

  /// Create from JSON
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    final items = (json['items'] as List<dynamic>?)
        ?.map((item) => fromJsonT(item))
        .toList() ??
        [];

    return PaginatedResponse(
      items: items,
      pagination: PaginationMeta.fromJson(json['pagination'] ?? {}),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'items': items,
      'pagination': pagination.toJson(),
    };
  }

  @override
  List<Object?> get props => [items, pagination];
}

/// Error response model
class ErrorResponse extends Equatable {
  final String message;
  final String? code;
  final Map<String, dynamic>? errors;
  final int? statusCode;

  const ErrorResponse({
    required this.message,
    this.code,
    this.errors,
    this.statusCode,
  });

  /// Create from JSON
  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      message: json['message'] ?? 'An error occurred',
      code: json['code'],
      errors: json['errors'],
      statusCode: json['statusCode'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'code': code,
      'errors': errors,
      'statusCode': statusCode,
    };
  }

  @override
  List<Object?> get props => [message, code, errors, statusCode];
}
