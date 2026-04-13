import 'package:final_proj/core/base/base_repository.dart';
import 'package:final_proj/data/models/auth/auth_models.dart';
import 'package:final_proj/data/services/firebase_auth_service.dart';

/// Auth repository - handles authentication operations
class AuthRepository extends BaseRepository {
  final FirebaseAuthService authService;

  AuthRepository({required this.authService});

  /// Register user with email and password
  Future<AuthResponse> register({required RegisterRequest request}) async {
    return execute(
      operation: () async {
        if (request.password != request.confirmPassword) {
          throw Exception('Passwords do not match');
        }
        return await authService.registerWithEmail(
          name: request.name,
          email: request.email,
          password: request.password,
        );
      },
      errorMessage: 'Registration failed',
    );
  }

  /// Login user with email and password
  Future<AuthResponse> login({required LoginRequest request}) async {
    return execute(
      operation: () async {
        return await authService.loginWithEmail(
          email: request.email,
          password: request.password,
        );
      },
      errorMessage: 'Login failed',
    );
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    return execute(
      operation: () async {
        return await authService.sendPasswordResetEmail(email);
      },
      errorMessage: 'Failed to send password reset email',
    );
  }

  /// Reset password
  Future<void> resetPassword({
    required String code,
    required String newPassword,
  }) async {
    return execute(
      operation: () async {
        return await authService.resetPassword(
          code: code,
          newPassword: newPassword,
        );
      },
      errorMessage: 'Failed to reset password',
    );
  }

  /// Logout user
  Future<void> logout() async {
    return execute(
      operation: () async {
        return await authService.logout();
      },
      errorMessage: 'Failed to logout',
    );
  }

  /// Refresh access token
  Future<String> refreshAccessToken() async {
    return execute(
      operation: () async {
        return await authService.refreshAccessToken();
      },
      errorMessage: 'Failed to refresh token',
    );
  }

  /// Get current user
  Future<UserModel?> getCurrentUser() async {
    return execute(
      operation: () async {
        return await authService.getCurrentUser();
      },
      errorMessage: 'Failed to fetch current user',
    );
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      return await authService.isUserAuthenticated();
    } catch (e) {
      return false;
    }
  }
}
