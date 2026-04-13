import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_proj/config/routes/app_routes.dart';
import 'package:final_proj/config/theme/app_colors.dart';
import 'package:final_proj/config/theme/app_text_styles.dart';
import 'package:final_proj/core/base/base_view_model.dart';
import 'package:final_proj/presentation/viewmodels/auth_view_model.dart';
import 'package:final_proj/presentation/widgets/common/common_widgets.dart';

/// Home screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Finance Tracker'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.ANALYTICS);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.SETTINGS);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Dashboard',
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: 16),
            Consumer<AuthViewModel>(
              builder: (context, authViewModel, _) {
                return Text(
                  'User: ${authViewModel.user?.email ?? 'Not logged in'}',
                  style: AppTextStyles.bodyMedium,
                );
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final authViewModel = context.read<AuthViewModel>();
                await authViewModel.logout();
                if (context.mounted) {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.LOGIN);
                }
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Settings screen
class SettingsMenuScreen extends StatelessWidget {
  const SettingsMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Menu'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Preferences'),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.PREFERENCES);
            },
          ),
          ListTile(
            title: const Text('Security'),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.SECURITY);
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.PROFILE);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
            onTap: () async {
              final authViewModel = context.read<AuthViewModel>();
              await authViewModel.logout();
              if (context.mounted) {
                Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.LOGIN);
              }
            },
          ),
        ],
      ),
    );
  }
}

/// Preferences screen
class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(
        child: Text('Preferences - To be implemented'),
      ),
    );
  }
}

/// Security screen
class SecurityScreen extends StatelessWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(
        child: Text('Security - To be implemented'),
      ),
    );
  }
}

/// Profile screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<AuthViewModel>(
              builder: (context, authViewModel, _) {
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        (authViewModel.user?.name ?? 'U').substring(0, 1),
                        style: const TextStyle(
                          fontSize: 24,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      authViewModel.user?.name ?? 'User',
                      style: AppTextStyles.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      authViewModel.user?.email ?? 'email@example.com',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Transactions screen
class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: const Center(child: Text('Transactions Screen - To be implemented')),
    );
  }
}

/// Budgets screen
class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budgets')),
      body: const Center(child: Text('Budgets Screen - To be implemented')),
    );
  }
}

/// Analytics screen
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: const Center(child: Text('Analytics Screen - To be implemented')),
    );
  }
}

/// Reports screen
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: const Center(child: Text('Reports Screen - To be implemented')),
    );
  }
}

/// Not found screen
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('404 - Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            const Text('This page does not exist'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.HOME),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
