import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_proj/data/models/settings_model.dart';
import 'package:final_proj/presentation/viewmodels/settings_view_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Load settings when screen initializes
    Future.microtask(() {
      context.read<SettingsViewModel>().loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: Consumer<SettingsViewModel>(
        builder: (context, settingsVM, _) {
          if (settingsVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: [
              // Display Settings Section
              _buildSectionTitle(context, 'Display'),
              _buildThemeToggle(context, settingsVM),
              const Divider(),

              // Currency Settings Section
              _buildSectionTitle(context, 'Currency'),
              _buildCurrencyDropdown(context, settingsVM),
              const Divider(),

              // Notification Settings Section
              _buildSectionTitle(context, 'Notifications'),
              _buildNotificationToggle(context, settingsVM),
              _buildBudgetAlertsToggle(context, settingsVM),
              _buildWeeklyReportsToggle(context, settingsVM),
              if (settingsVM.weeklyReports)
                _buildWeeklyReportDayPicker(context, settingsVM),
              const Divider(),

              // Budget Settings Section
              _buildSectionTitle(context, 'Budget'),
              _buildBudgetThresholdSlider(context, settingsVM),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context, SettingsViewModel settingsVM) {
    return ListTile(
      leading: Icon(
        settingsVM.isDarkMode ? Icons.dark_mode : Icons.light_mode,
        color: Theme.of(context).primaryColor,
      ),
      title: const Text('Dark Mode'),
      subtitle: Text(
        settingsVM.isDarkMode ? 'Enabled' : 'Disabled',
      ),
      trailing: Switch(
        value: settingsVM.isDarkMode,
        onChanged: (value) {
          settingsVM.updateDarkMode(value);
        },
      ),
    );
  }

  Widget _buildCurrencyDropdown(
      BuildContext context, SettingsViewModel settingsVM) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Select Currency',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          DropdownButton<Currency>(
            isExpanded: true,
            value: settingsVM.currency,
            items: Currency.values.map((Currency currency) {
              return DropdownMenuItem<Currency>(
                value: currency,
                child: Text('${currency.code} ${currency.symbol}'),
              );
            }).toList(),
            onChanged: (Currency? value) {
              if (value != null) {
                settingsVM.updateCurrency(value);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationToggle(
      BuildContext context, SettingsViewModel settingsVM) {
    return ListTile(
      leading: Icon(
        Icons.notifications,
        color: Theme.of(context).primaryColor,
      ),
      title: const Text('Notifications'),
      subtitle: Text(
        settingsVM.notificationsEnabled ? 'Enabled' : 'Disabled',
      ),
      trailing: Switch(
        value: settingsVM.notificationsEnabled,
        onChanged: (value) {
          settingsVM.updateNotifications(value);
        },
      ),
    );
  }

  Widget _buildBudgetAlertsToggle(
      BuildContext context, SettingsViewModel settingsVM) {
    return ListTile(
      leading: Icon(
        Icons.notifications_active,
        color: Theme.of(context).primaryColor,
      ),
      title: const Text('Budget Alerts'),
      subtitle: Text(
        settingsVM.budgetAlerts ? 'Enabled' : 'Disabled',
      ),
      trailing: Switch(
        value: settingsVM.budgetAlerts && settingsVM.notificationsEnabled,
        onChanged: settingsVM.notificationsEnabled
            ? (value) {
                settingsVM.updateBudgetAlerts(value);
              }
            : null,
      ),
    );
  }

  Widget _buildWeeklyReportsToggle(
      BuildContext context, SettingsViewModel settingsVM) {
    return ListTile(
      leading: Icon(
        Icons.assessment,
        color: Theme.of(context).primaryColor,
      ),
      title: const Text('Weekly Reports'),
      subtitle: Text(
        settingsVM.weeklyReports ? 'Enabled' : 'Disabled',
      ),
      trailing: Switch(
        value: settingsVM.weeklyReports && settingsVM.notificationsEnabled,
        onChanged: settingsVM.notificationsEnabled
            ? (value) {
                settingsVM.updateWeeklyReports(value);
              }
            : null,
      ),
    );
  }

  Widget _buildWeeklyReportDayPicker(
      BuildContext context, SettingsViewModel settingsVM) {
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Report Day',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          DropdownButton<int>(
            isExpanded: true,
            value: settingsVM.weeklyReportDay,
            items: List.generate(7, (index) {
              return DropdownMenuItem<int>(
                value: index,
                child: Text(days[index]),
              );
            }),
            onChanged: (int? value) {
              if (value != null) {
                settingsVM.updateWeeklyReportDay(value);
              }
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildBudgetThresholdSlider(
      BuildContext context, SettingsViewModel settingsVM) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Budget Alert Threshold',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '${settingsVM.budgetAlertThreshold.toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: settingsVM.budgetAlertThreshold,
            min: 10.0,
            max: 100.0,
            divisions: 9,
            label: '${settingsVM.budgetAlertThreshold.toStringAsFixed(0)}%',
            onChanged: (value) {
              settingsVM.updateBudgetAlertThreshold(value);
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Alert when spending reaches this percentage of budget',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }
}
