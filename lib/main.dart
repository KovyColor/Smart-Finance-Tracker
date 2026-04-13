import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:final_proj/config/routes/app_routes.dart';
import 'package:final_proj/config/routes/route_generator.dart';
import 'package:final_proj/config/theme/app_theme.dart';
import 'package:final_proj/core/di/service_locator.dart';
import 'package:final_proj/presentation/viewmodels/analytics_view_model.dart';
import 'package:final_proj/presentation/viewmodels/auth_view_model.dart';
import 'package:final_proj/presentation/viewmodels/budget_goal_view_model.dart';
import 'package:final_proj/presentation/viewmodels/settings_view_model.dart';
import 'package:final_proj/presentation/viewmodels/transaction_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables with graceful fallback
  try {
    await dotenv.load();
  } catch (e) {
    // If .env file is not found, continue with default values
    // DioInstance and other services will use AppConstants fallbacks
    print('Warning: .env file not found. Using default configuration from AppConstants.');
  }
  
  // Initialize Hive database before setting up service locator
  await Hive.initFlutter();
  
  // Initialize service locator & dependencies
  await setupServiceLocator();
  
  // Load settings on app startup
  await getIt<SettingsViewModel>().loadSettings();
  
  runApp(
    const SmartFinanceTracker(),
  );
}

class SmartFinanceTracker extends StatelessWidget {
  const SmartFinanceTracker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => getIt<SettingsViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<AuthViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<TransactionViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<AnalyticsViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<BudgetGoalViewModel>(),
        ),
      ],
      child: Consumer<SettingsViewModel>(
        builder: (context, settingsVM, _) {
          return MaterialApp(
            title: 'Smart Finance Tracker',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsVM.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            onGenerateRoute: RouteGenerator.generateRoute,
            initialRoute: AppRoutes.SPLASH,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

/// Alias for backward compatibility with tests
class MyApp extends SmartFinanceTracker {
  const MyApp({Key? key}) : super(key: key);
}


