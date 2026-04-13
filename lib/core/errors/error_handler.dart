import 'package:dio/dio.dart';
import 'package:final_proj/core/errors/app_exception.dart';

/// Centralized error handling utility
class ErrorHandler {
  // Private constructor to prevent instantiation
  ErrorHandler._();

  /// Handle Dio exceptions and convert to AppException
  static AppException handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'Connection timeout. Please check your internet connection.',
          code: error.type.toString(),
          originalException: error,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Server error occurred';

        if (statusCode == 401) {
          return AuthenticationException(
            message: 'Your session has expired. Please login again.',
            code: 'UNAUTHORIZED',
            originalException: error,
          );
        } else if (statusCode == 403) {
          return AuthorizationException(
            message: 'You do not have permission to access this resource.',
            code: 'FORBIDDEN',
            originalException: error,
          );
        } else if (statusCode == 404) {
          return ServerException(
            message: 'Resource not found.',
            statusCode: statusCode,
            code: 'NOT_FOUND',
            originalException: error,
          );
        } else if (statusCode == 422 || statusCode == 400) {
          return ValidationException(
            message: message ?? 'Validation failed. Please check your input.',
            code: 'VALIDATION_ERROR',
            originalException: error,
          );
        } else if (statusCode != null && statusCode >= 500) {
          return ServerException(
            message: 'Server error occurred. Please try again later.',
            statusCode: statusCode,
            code: 'SERVER_ERROR',
            originalException: error,
          );
        } else {
          return ServerException(
            message: message ?? 'An error occurred',
            statusCode: statusCode,
            originalException: error,
          );
        }

      case DioExceptionType.cancel:
        return NetworkException(
          message: 'Request was cancelled',
          code: 'CANCELLED',
          originalException: error,
        );

      case DioExceptionType.unknown:
        if (error.error is! Exception) {
          return NoInternetException(originalException: error);
        }
        return NetworkException(
          message: 'An unexpected network error occurred',
          originalException: error,
        );

      case DioExceptionType.badCertificate:
        return NetworkException(
          message: 'Certificate validation failed',
          code: 'BAD_CERTIFICATE',
          originalException: error,
        );

      case DioExceptionType.connectionError:
        return NoInternetException(originalException: error);
    }
    
    // This should never be reached due to exhaustive switch, but required for compilation
    return UnknownException(
      message: 'Unknown Dio error occurred',
      originalException: error,
    );
  }

  /// Handle generic exceptions
  static AppException handleException(Object error, {String? message}) {
    if (error is AppException) {
      return error;
    }

    if (error is DioException) {
      return handleDioException(error);
    }

    if (error is FormatException) {
      return DataParsingException(
        message: 'Failed to parse response data',
        originalException: error,
      );
    }

    return UnknownException(
      message: message ?? 'An unexpected error occurred: $error',
      originalException: error,
    );
  }

  /// Get user-friendly error message
  static String getUserMessage(AppException exception) {
    if (exception is ValidationException) {
      return exception.message;
    }
    if (exception is NoInternetException) {
      return 'Please check your internet connection';
    }
    if (exception is AuthenticationException) {
      return 'Please log in to continue';
    }
    if (exception is AuthorizationException) {
      return 'You do not have permission for this action';
    }
    if (exception is ServerException) {
      return 'Server error: ${exception.message}';
    }
    if (exception is NetworkException) {
      return 'Network error: ${exception.message}';
    }

    return exception.message;
  }

  /// Log error for debugging
  static void logError(AppException exception) {
    // TODO: Integrate with logging service
    print('Error: ${exception.message}');
    print('Code: ${exception.code}');
    if (exception.originalException != null) {
      print('Original: ${exception.originalException}');
    }
  }
}
