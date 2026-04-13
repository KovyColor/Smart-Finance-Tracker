import 'package:dio/dio.dart';
import 'package:final_proj/core/base/base_model.dart';
import 'package:final_proj/core/errors/error_handler.dart';
import 'package:final_proj/core/network/dio_instance.dart';

/// Generic API client for making HTTP requests
class ApiClient {
  final Dio _dio;

  ApiClient({Dio? dio}) : _dio = dio ?? DioInstance().dio;

  /// Perform GET request
  Future<T> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Required Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioException(e);
    }
  }

  /// Perform POST request
  Future<T> post<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioException(e);
    }
  }

  /// Perform PUT request
  Future<T> put<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioException(e);
    }
  }

  /// Perform PATCH request
  Future<T> patch<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioException(e);
    }
  }

  /// Perform DELETE request
  Future<T> delete<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioException(e);
    }
  }

  /// Handle API response
  T _handleResponse<T>(Response response, Function(dynamic)? fromJson) {
    if (response.statusCode == null || response.statusCode! >= 400) {
      throw ErrorResponse.fromJson(response.data ?? {});
    }

    if (fromJson != null) {
      return fromJson(response.data);
    }

    return response.data as T;
  }
}

typedef Required = T Function<T>();
