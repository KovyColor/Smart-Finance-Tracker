import 'package:flutter/foundation.dart';

/// Enum for request states
enum RequestState { initial, loading, success, error }

/// Base ViewModel class with common functionality
abstract class BaseViewModel extends ChangeNotifier {
  RequestState _state = RequestState.initial;
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  RequestState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  // Setters
  set state(RequestState value) {
    _state = value;
    notifyListeners();
  }

  set errorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Update state with loading indicator
  void setLoading(bool isLoading) {
    _isLoading = isLoading;
    if (isLoading) {
      _state = RequestState.loading;
      _errorMessage = null;
    }
    notifyListeners();
  }

  /// Handle success state
  void setSuccess({String? message}) {
    _state = RequestState.success;
    _errorMessage = null;
    _isLoading = false;
    if (message != null) {
      _errorMessage = message;
    }
    notifyListeners();
  }

  /// Handle error state
  void setError(String message) {
    _state = RequestState.error;
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }

  /// Reset to initial state
  void reset() {
    _state = RequestState.initial;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Check if currently loading
  bool get loading => _state == RequestState.loading;

  /// Check if has error
  bool get hasError => _state == RequestState.error;

  /// Check if successful
  bool get isSuccess => _state == RequestState.success;

  /// Dispose resources
  @override
  void dispose() {
    super.dispose();
  }
}
