import 'package:final_proj/core/base/base_view_model.dart';
import 'package:final_proj/core/errors/error_handler.dart';
import 'package:final_proj/data/models/auth/auth_models.dart';
import 'package:final_proj/data/repositories/auth_repository.dart';

/// Auth ViewModel - handles authentication logic
class AuthViewModel extends BaseViewModel {
  final AuthRepository repository;

  UserModel? _user;
  String? _token;

  // Getters
  UserModel? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _user != null && _token != null;

  AuthViewModel({required this.repository});

  /// Login with email and password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    setLoading(true);
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await repository.login(request: request);

      _user = response.user;
      _token = response.accessToken;

      setSuccess(message: 'Login successful');
      return true;
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      setError(ErrorHandler.getUserMessage(exception));
      return false;
    }
  }

  /// Register with email, password, and name
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    setLoading(true);
    try {
      final request = RegisterRequest(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );
      final response = await repository.register(request: request);

      _user = response.user;
      _token = response.accessToken;

      setSuccess(message: 'Registration successful');
      return true;
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      setError(ErrorHandler.getUserMessage(exception));
      return false;
    }
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    setLoading(true);
    try {
      await repository.sendPasswordResetEmail(email);
      setSuccess(message: 'Password reset email sent');
      return true;
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      setError(ErrorHandler.getUserMessage(exception));
      return false;
    }
  }

  /// Reset password with code
  Future<bool> resetPassword({
    required String code,
    required String newPassword,
  }) async {
    setLoading(true);
    try {
      await repository.resetPassword(
        code: code,
        newPassword: newPassword,
      );
      setSuccess(message: 'Password reset successful');
      return true;
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      setError(ErrorHandler.getUserMessage(exception));
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await repository.logout();
      _user = null;
      _token = null;
      reset();
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      setError(ErrorHandler.getUserMessage(exception));
    }
  }

  /// Check authentication status
  Future<void> checkAuthStatus() async {
    try {
      final isAuth = await repository.isAuthenticated();
      if (isAuth) {
        final user = await repository.getCurrentUser();
        _user = user;
        setSuccess();
      } else {
        _user = null;
        _token = null;
        reset();
      }
    } catch (e) {
      _user = null;
      _token = null;
      reset();
    }
  }

  /// Clear user data (for manual logout)
  void clearUserData() {
    _user = null;
    _token = null;
    reset();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
