import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_proj/data/models/settings_model.dart';

class SettingsService {
  late SharedPreferences _prefs;

  static const String _darkModeKey = 'dark_mode';
  static const String _currencyKey = 'currency';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _budgetAlertsKey = 'budget_alerts';
  static const String _weeklyReportsKey = 'weekly_reports';
  static const String _weeklyReportDayKey = 'weekly_report_day';
  static const String _budgetAlertThresholdKey = 'budget_alert_threshold';

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<AppSettings> loadSettings() async {
    try {
      final isDarkMode = _prefs.getBool(_darkModeKey) ?? false;
      final currencyCode = _prefs.getString(_currencyKey) ?? 'USD';
      final notificationsEnabled = _prefs.getBool(_notificationsKey) ?? true;
      final budgetAlerts = _prefs.getBool(_budgetAlertsKey) ?? true;
      final weeklyReports = _prefs.getBool(_weeklyReportsKey) ?? true;
      final weeklyReportDay = _prefs.getInt(_weeklyReportDayKey) ?? 0;
      final budgetAlertThreshold =
          _prefs.getDouble(_budgetAlertThresholdKey) ?? 80.0;

      Currency currency;
      try {
        currency = Currency.values.byName(currencyCode);
      } catch (e) {
        currency = Currency.USD;
      }

      return AppSettings(
        isDarkMode: isDarkMode,
        currency: currency,
        notificationsEnabled: notificationsEnabled,
        budgetAlerts: budgetAlerts,
        weeklyReports: weeklyReports,
        weeklyReportDay: weeklyReportDay,
        budgetAlertThreshold: budgetAlertThreshold,
      );
    } catch (e) {
      print('Error loading settings: $e');
      return AppSettings.defaults();
    }
  }

  Future<void> saveSettings(AppSettings settings) async {
    try {
      await _prefs.setBool(_darkModeKey, settings.isDarkMode);
      await _prefs.setString(_currencyKey, settings.currency.code);
      await _prefs.setBool(_notificationsKey, settings.notificationsEnabled);
      await _prefs.setBool(_budgetAlertsKey, settings.budgetAlerts);
      await _prefs.setBool(_weeklyReportsKey, settings.weeklyReports);
      await _prefs.setInt(_weeklyReportDayKey, settings.weeklyReportDay);
      await _prefs.setDouble(
          _budgetAlertThresholdKey, settings.budgetAlertThreshold);
    } catch (e) {
      print('Error saving settings: $e');
    }
  }

  Future<void> updateDarkMode(bool isDarkMode) async {
    await _prefs.setBool(_darkModeKey, isDarkMode);
  }

  Future<void> updateCurrency(Currency currency) async {
    await _prefs.setString(_currencyKey, currency.code);
  }

  Future<void> updateNotifications(bool enabled) async {
    await _prefs.setBool(_notificationsKey, enabled);
  }

  Future<void> updateBudgetAlerts(bool enabled) async {
    await _prefs.setBool(_budgetAlertsKey, enabled);
  }

  Future<void> updateWeeklyReports(bool enabled) async {
    await _prefs.setBool(_weeklyReportsKey, enabled);
  }

  Future<void> updateWeeklyReportDay(int day) async {
    await _prefs.setInt(_weeklyReportDayKey, day);
  }

  Future<void> updateBudgetAlertThreshold(double threshold) async {
    await _prefs.setDouble(_budgetAlertThresholdKey, threshold);
  }
}
