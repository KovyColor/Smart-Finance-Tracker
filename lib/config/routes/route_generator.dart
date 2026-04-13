import 'package:flutter/material.dart';
import 'package:final_proj/config/routes/app_routes.dart';
import 'package:final_proj/presentation/screens/analytics_screen.dart';
import 'package:final_proj/presentation/screens/settings_screen.dart';
import 'package:final_proj/presentation/screens/budget_goals_screen.dart';
import 'package:final_proj/presentation/views/splash_screen.dart';
import 'package:final_proj/presentation/views/auth/screens/login_screen.dart';
import 'package:final_proj/presentation/views/auth/screens/register_screen.dart';
import 'package:final_proj/presentation/views/auth/screens/forgot_password_screen.dart';
import 'package:final_proj/presentation/views/dashboard/dashboard_screen.dart';
import 'package:final_proj/presentation/views/dashboard/transactions_list_screen.dart';

/// Central route generator for named navigation
class RouteGenerator {
  /// Generate routes based on route name
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Auth routes
      case AppRoutes.SPLASH:
        return _buildRoute(const SplashScreen(), settings);
      case AppRoutes.LOGIN:
        return _buildRoute(const LoginScreen(), settings);
      case AppRoutes.REGISTER:
        return _buildRoute(const RegisterScreen(), settings);
      case AppRoutes.FORGOT_PASSWORD:
        return _buildRoute(const ForgotPasswordScreen(), settings);
      
      // Main app routes
      case AppRoutes.HOME:
        return _buildRoute(const DashboardScreen(), settings);
      case AppRoutes.TRANSACTIONS:
        return _buildRoute(const TransactionsListScreen(), settings);
      
      // Settings routes
      case AppRoutes.ANALYTICS:
        return _buildRoute(const AnalyticsScreen(), settings);
      case AppRoutes.SETTINGS:
        return _buildRoute(const SettingsScreen(), settings);
      case AppRoutes.BUDGETS:
        return _buildRoute(const BudgetGoalsScreen(), settings);
      
      // 404 route
      case AppRoutes.NOT_FOUND:
      default:
        return _buildRoute(
          Scaffold(
            appBar: AppBar(title: const Text('Not Found')),
            body: const Center(
              child: Text('The page you are looking for does not exist.'),
            ),
          ),
          settings,
        );
    }
  }

  /// Build a material page route with fade transition
  static MaterialPageRoute<dynamic> _buildRoute(
    Widget page,
    RouteSettings settings,
  ) {
    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }
}
