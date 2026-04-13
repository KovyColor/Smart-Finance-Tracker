import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:final_proj/utils/constants/app_constants.dart';

/// Configured Dio instance for API calls
class DioInstance {
  static final DioInstance _instance = DioInstance._internal();

  late Dio _dio;

  factory DioInstance() {
    return _instance;
  }

  DioInstance._internal() {
    _initializeDio();
  }

  Dio get dio => _dio;

  void _initializeDio() {
    // Try to get API_BASE_URL from environment, with fallback to default
    String baseUrl = AppConstants.baseUrl;
    try {
      baseUrl = dotenv.env['API_BASE_URL'] ?? AppConstants.baseUrl;
    } catch (e) {
      // If dotenv is not initialized (e.g., in tests), use default
      print('Warning: Could not load API_BASE_URL from environment, using default');
    }

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(milliseconds: AppConstants.connectionTimeout),
        receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );

    // Add interceptors
    _dio.interceptors.add(_LoggingInterceptor());
    _dio.interceptors.add(_ErrorInterceptor());
    _dio.interceptors.add(_HeaderInterceptor());
  }

  /// Update authorization header
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Clear authorization header
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Reset Dio instance
  void reset() {
    _initializeDio();
  }
}

/// Logging interceptor for debugging
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('📤 REQUEST: ${options.method} ${options.path}');
    print('Headers: ${options.headers}');
    if (options.data != null) {
      print('Body: ${options.data}');
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('📥 RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
    print('Body: ${response.data}');
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ ERROR: ${err.message}');
    print('Status: ${err.response?.statusCode}');
    return handler.next(err);
  }
}

/// Error interceptor for handling common errors
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // TODO: Handle token refresh on 401
    // TODO: Handle other common errors
    return handler.next(err);
  }
}

/// Header interceptor for adding common headers
class _HeaderInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    // TODO: Add other required headers
    return handler.next(options);
  }
}
