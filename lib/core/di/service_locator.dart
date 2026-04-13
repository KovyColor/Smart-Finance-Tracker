import 'package:get_it/get_it.dart';
import 'package:final_proj/core/network/api_client.dart';
import 'package:final_proj/core/network/dio_instance.dart';
import 'package:final_proj/data/repositories/analytics_repository.dart';
import 'package:final_proj/data/repositories/auth_repository.dart';
import 'package:final_proj/data/repositories/budget_goal_repository.dart';
import 'package:final_proj/data/repositories/transaction_repository.dart';
import 'package:final_proj/data/services/firebase_auth_service.dart';
import 'package:final_proj/data/services/hive/hive_transaction_service.dart';
import 'package:final_proj/data/services/notification_service.dart';
import 'package:final_proj/data/services/settings_service.dart';
import 'package:final_proj/presentation/viewmodels/analytics_view_model.dart';
import 'package:final_proj/presentation/viewmodels/auth_view_model.dart';
import 'package:final_proj/presentation/viewmodels/budget_goal_view_model.dart';
import 'package:final_proj/presentation/viewmodels/settings_view_model.dart';
import 'package:final_proj/presentation/viewmodels/transaction_view_model.dart';

final getIt = GetIt.instance;

/// Initialize and register all dependencies
Future<void> setupServiceLocator() async {
  // Network
  getIt.registerSingleton<DioInstance>(DioInstance());
  getIt.registerSingleton<ApiClient>(ApiClient());

  // Auth Services
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  await getIt<FirebaseAuthService>().initialize();

  // Auth Repository
  getIt.registerSingleton<AuthRepository>(
    AuthRepository(authService: getIt<FirebaseAuthService>()),
  );

  // Auth ViewModel
  getIt.registerSingleton<AuthViewModel>(
    AuthViewModel(repository: getIt<AuthRepository>()),
  );

  // Transaction Services
  getIt.registerSingleton<HiveTransactionService>(HiveTransactionService());
  await getIt<HiveTransactionService>().initialize();

  // Transaction Repository
  getIt.registerSingleton<TransactionRepository>(
    TransactionRepository(hiveService: getIt<HiveTransactionService>()),
  );

  // Transaction ViewModel
  getIt.registerSingleton<TransactionViewModel>(
    TransactionViewModel(repository: getIt<TransactionRepository>()),
  );

  // Settings Service & ViewModel
  getIt.registerSingleton<SettingsService>(SettingsService());
  await getIt<SettingsService>().initialize();

  getIt.registerSingleton<SettingsViewModel>(
    SettingsViewModel(settingsService: getIt<SettingsService>()),
  );

  // Notification Service
  getIt.registerSingleton<NotificationService>(NotificationService());
  await getIt<NotificationService>().initialize();

  // Analytics Repository & ViewModel
  getIt.registerSingleton<AnalyticsRepository>(
    AnalyticsRepository(hiveService: getIt<HiveTransactionService>()),
  );

  getIt.registerSingleton<AnalyticsViewModel>(
    AnalyticsViewModel(repository: getIt<AnalyticsRepository>()),
  );

  // Budget Goal Repository & ViewModel
  getIt.registerSingleton<BudgetGoalRepository>(BudgetGoalRepository());

  getIt.registerSingleton<BudgetGoalViewModel>(
    BudgetGoalViewModel(repository: getIt<BudgetGoalRepository>()),
  );
}

/// Unregister and clean up dependencies
Future<void> cleanupServiceLocator() async {
  await getIt.reset();
}
