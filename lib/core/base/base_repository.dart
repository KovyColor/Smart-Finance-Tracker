import 'package:final_proj/core/errors/app_exception.dart';
import 'package:final_proj/core/errors/error_handler.dart';

/// Base repository class providing common error handling
abstract class BaseRepository {
  /// Safely execute async operation with error handling
  Future<T> execute<T>({
    required Future<T> Function() operation,
    String? errorMessage,
  }) async {
    try {
      return await operation();
    } catch (e) {
      final exception = ErrorHandler.handleException(
        e,
        message: errorMessage,
      );
      ErrorHandler.logError(exception);
      rethrow;
    }
  }

  /// Safely execute async operation with retry logic
  Future<T> executeWithRetry<T>({
    required Future<T> Function() operation,
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 1),
    String? errorMessage,
  }) async {
    int attempts = 0;
    late AppException lastException;

    while (attempts < maxRetries) {
      try {
        attempts++;
        return await operation();
      } catch (e) {
        lastException = ErrorHandler.handleException(e);

        if (attempts < maxRetries) {
          await Future.delayed(retryDelay);
        }
      }
    }

    ErrorHandler.logError(lastException);
    throw lastException;
  }
}
