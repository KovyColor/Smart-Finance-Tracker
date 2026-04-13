import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:final_proj/main.dart';
import 'package:final_proj/presentation/viewmodels/settings_view_model.dart';
import 'package:final_proj/presentation/viewmodels/auth_view_model.dart';
import 'package:final_proj/presentation/viewmodels/transaction_view_model.dart';
import 'package:final_proj/presentation/viewmodels/analytics_view_model.dart';
import 'package:final_proj/presentation/viewmodels/budget_goal_view_model.dart';
import 'package:final_proj/data/services/settings_service.dart';
import 'package:final_proj/data/repositories/auth_repository.dart';
import 'package:final_proj/data/repositories/transaction_repository.dart';
import 'package:final_proj/data/repositories/analytics_repository.dart';
import 'package:final_proj/data/repositories/budget_goal_repository.dart';
import 'package:final_proj/data/services/firebase_auth_service.dart';
import 'package:final_proj/data/services/hive/hive_transaction_service.dart';
import 'package:get_it/get_it.dart';

void main() {
  group('Smart Finance Tracker App Tests', () {
    setUp(() {
      // Ensure GetIt is reset before each test
      final getIt = GetIt.instance;
      getIt.reset();
      
      // Register dummy implementations to prevent errors
      // These are minimal objects that won't crash when accessed
      try {
        getIt.registerLazySingleton<SettingsViewModel>(
          () => _MinimalSettingsViewModel(),
        );
        getIt.registerLazySingleton<AuthViewModel>(
          () => _MinimalAuthViewModel(),
        );
        getIt.registerLazySingleton<TransactionViewModel>(
          () => _MinimalTransactionViewModel(),
        );
        getIt.registerLazySingleton<AnalyticsViewModel>(
          () => _MinimalAnalyticsViewModel(),
        );
        getIt.registerLazySingleton<BudgetGoalViewModel>(
          () => _MinimalBudgetGoalViewModel(),
        );
      } catch (e) {
        print('Warning: Could not register viewmodels: $e');
      }
    });

    tearDown(() {
      final getIt = GetIt.instance;
      getIt.reset();
    });

    testWidgets('App widget can be created', (WidgetTester tester) async {
      // Just verify that MyApp widget can be instantiated
      const app = MyApp();
      expect(app, isNotNull);
    });

    testWidgets('App launches without crashing', (WidgetTester tester) async {
      // Build our app
      await tester.pumpWidget(const MyApp());

      // Wait for splash screen to finish and navigate
      // Splash screen has a 2-second delay
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify the app was built
      expect(find.byType(MyApp), findsOneWidget);
    });

    testWidgets('App displays MaterialApp', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Wait for splash screen to finish and navigate
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify MaterialApp is present
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}

// Minimal SettingsViewModel - prevents crash due to initialization
class _MinimalSettingsViewModel extends SettingsViewModel {
  _MinimalSettingsViewModel() : super(settingsService: _DummySettingsService());

  @override
  bool get isDarkMode => false;
}

class _DummySettingsService extends SettingsService {
  @override
  Future<void> initialize() async => null;
}

// Minimal AuthViewModel
class _MinimalAuthViewModel extends AuthViewModel {
  _MinimalAuthViewModel() : super(repository: _DummyAuthRepository());
}

class _DummyAuthRepository extends AuthRepository {
  _DummyAuthRepository() : super(authService: _DummyFirebaseAuthService());
}

class _DummyFirebaseAuthService extends FirebaseAuthService {
  @override
  Future<void> initialize() async => null;
}

// Minimal TransactionViewModel
class _MinimalTransactionViewModel extends TransactionViewModel {
  _MinimalTransactionViewModel() : super(repository: _DummyTransactionRepository());
}

class _DummyTransactionRepository extends TransactionRepository {
  _DummyTransactionRepository() : super(hiveService: _DummyHiveTransactionService());
}

class _DummyHiveTransactionService extends HiveTransactionService {
  @override
  Future<void> initialize() async => null;
}

// Minimal AnalyticsViewModel
class _MinimalAnalyticsViewModel extends AnalyticsViewModel {
  _MinimalAnalyticsViewModel() : super(repository: _DummyAnalyticsRepository());
}

class _DummyAnalyticsRepository extends AnalyticsRepository {
  _DummyAnalyticsRepository() : super(hiveService: _DummyHiveTransactionService2());
}

class _DummyHiveTransactionService2 extends HiveTransactionService {
  @override
  Future<void> initialize() async => null;
}

// Minimal BudgetGoalViewModel
class _MinimalBudgetGoalViewModel extends BudgetGoalViewModel {
  _MinimalBudgetGoalViewModel() : super(repository: _DummyBudgetGoalRepository());
}

class _DummyBudgetGoalRepository extends BudgetGoalRepository {}
