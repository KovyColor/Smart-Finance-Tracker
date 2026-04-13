import 'package:final_proj/core/base/base_service.dart';
import 'package:final_proj/data/models/auth/auth_models.dart';

/// Firebase authentication service
class FirebaseAuthService extends BaseService {
  UserModel? _currentUser;
  String? _accessToken;
  String? _refreshToken;

  // Getters
  UserModel? get currentUser => _currentUser;
  String? get accessToken => _accessToken;
  bool get isAuthenticated => _currentUser != null && _accessToken != null;

  @override
  Future<void> initialize() async {
    // TODO: Initialize Firebase Auth
    // FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
    //   if (firebaseUser != null) {
    //     _currentUser = UserModel(
    //       uid: firebaseUser.uid,
    //       name: firebaseUser.displayName ?? '',
    //       email: firebaseUser.email ?? '',
    //       emailVerified: firebaseUser.emailVerified,
    //       createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
    //       updatedAt: firebaseUser.metadata.lastSignInTime ?? DateTime.now(),
    //     );
    //   } else {
    //     _currentUser = null;
    //   }
    // });

    print('FirebaseAuthService initialized');
  }

  @override
  Future<void> dispose() async {
    _currentUser = null;
    _accessToken = null;
    _refreshToken = null;
    print('FirebaseAuthService disposed');
  }

  /// Register user with email and password
  Future<AuthResponse> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // TODO: Implement Firebase registration
      // final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );
      //
      // await userCredential.user?.updateDisplayName(name);
      //
      // _currentUser = UserModel(
      //   uid: userCredential.user!.uid,
      //   name: name,
      //   email: email,
      //   emailVerified: false,
      //   createdAt: DateTime.now(),
      //   updatedAt: DateTime.now(),
      // );
      //
      // _accessToken = await userCredential.user?.getIdToken();

      // Placeholder for demo
      _currentUser = UserModel(
        uid: 'demo-uid-${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        emailVerified: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _accessToken = 'demo-token-${DateTime.now().millisecondsSinceEpoch}';

      return AuthResponse(
        user: _currentUser!,
        accessToken: _accessToken!,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Login user with email and password
  Future<AuthResponse> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // TODO: Implement Firebase login
      // final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );
      //
      // _currentUser = UserModel(
      //   uid: userCredential.user!.uid,
      //   name: userCredential.user!.displayName ?? '',
      //   email: userCredential.user!.email ?? '',
      //   emailVerified: userCredential.user!.emailVerified,
      //   createdAt: userCredential.user!.metadata.creationTime ?? DateTime.now(),
      //   updatedAt: userCredential.user!.metadata.lastSignInTime ?? DateTime.now(),
      // );
      //
      // _accessToken = await userCredential.user?.getIdToken();

      // Placeholder for demo
      _currentUser = UserModel(
        uid: 'demo-uid-$email',
        name: email.split('@').first,
        email: email,
        emailVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      );
      _accessToken = 'demo-token-$email-${DateTime.now().millisecondsSinceEpoch}';

      return AuthResponse(
        user: _currentUser!,
        accessToken: _accessToken!,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      // TODO: Implement Firebase password reset
      // await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print('Password reset email sent to $email');
    } catch (e) {
      rethrow;
    }
  }

  /// Reset password with code
  Future<void> resetPassword({
    required String code,
    required String newPassword,
  }) async {
    try {
      // TODO: Implement Firebase password reset confirmation
      // await FirebaseAuth.instance.confirmPasswordReset(
      //   code: code,
      //   newPassword: newPassword,
      // );
      print('Password reset successfully');
    } catch (e) {
      rethrow;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      // TODO: Implement Firebase logout
      // await FirebaseAuth.instance.signOut();
      _currentUser = null;
      _accessToken = null;
      _refreshToken = null;
      print('User logged out');
    } catch (e) {
      rethrow;
    }
  }

  /// Refresh access token
  Future<String> refreshAccessToken() async {
    try {
      // TODO: Implement token refresh
      // _accessToken = await FirebaseAuth.instance.currentUser?.getIdToken(true);
      print('Access token refreshed');
      return _accessToken ?? '';
    } catch (e) {
      rethrow;
    }
  }

  /// Check if user is authenticated
  Future<bool> isUserAuthenticated() async {
    try {
      // TODO: Check Firebase authentication state
      // return FirebaseAuth.instance.currentUser != null;
      return _currentUser != null && _accessToken != null;
    } catch (e) {
      return false;
    }
  }

  /// Get current user
  Future<UserModel?> getCurrentUser() async {
    try {
      // TODO: Fetch current user from Firebase or backend
      return _currentUser;
    } catch (e) {
      return null;
    }
  }
}
