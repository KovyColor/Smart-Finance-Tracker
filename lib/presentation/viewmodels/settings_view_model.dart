import 'package:flutter/foundation.dart';
import 'package:final_proj/data/models/settings_model.dart';
import 'package:final_proj/data/services/settings_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final SettingsService _settingsService;

  SettingsViewModel({required SettingsService settingsService})
      : _settingsService = settingsService;

  AppSettings _settings = AppSettings.defaults();
  bool _isLoading = false;
  String? _error;

  AppSettings get settings => _settings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool get isDarkMode => _settings.isDarkMode;
  Currency get currency => _settings.currency;
  bool get notificationsEnabled => _settings.notificationsEnabled;
  bool get budgetAlerts => _settings.budgetAlerts;
  bool get weeklyReports => _settings.weeklyReports;
  int get weeklyReportDay => _settings.weeklyReportDay;
  double get budgetAlertThreshold => _settings.budgetAlertThreshold;

  Future<void> loadSettings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _settings = await _settingsService.loadSettings();
      _error = null;
    } catch (e) {
      _error = 'Failed to load settings: ${e.toString()}';
      print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateDarkMode(bool isDarkMode) async {
    try {
      _settings = _settings.copyWith(isDarkMode: isDarkMode);
      await _settingsService.updateDarkMode(isDarkMode);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update dark mode: ${e.toString()}';
      print(_error);
      notifyListeners();
    }
  }

  Future<void> updateCurrency(Currency currency) async {
    try {
      _settings = _settings.copyWith(currency: currency);
      await _settingsService.updateCurrency(currency);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update currency: ${e.toString()}';
      print(_error);
      notifyListeners();
    }
  }

  Future<void> updateNotifications(bool enabled) async {
    try {
      _settings = _settings.copyWith(notificationsEnabled: enabled);
      await _settingsService.updateNotifications(enabled);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update notifications: ${e.toString()}';
      print(_error);
      notifyListeners();
    }
  }

  Future<void> updateBudgetAlerts(bool enabled) async {
    try {
      _settings = _settings.copyWith(budgetAlerts: enabled);
      await _settingsService.updateBudgetAlerts(enabled);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update budget alerts: ${e.toString()}';
      print(_error);
      notifyListeners();
    }
  }

  Future<void> updateWeeklyReports(bool enabled) async {
    try {
      _settings = _settings.copyWith(weeklyReports: enabled);
      await _settingsService.updateWeeklyReports(enabled);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update weekly reports: ${e.toString()}';
      print(_error);
      notifyListeners();
    }
  }

  Future<void> updateWeeklyReportDay(int day) async {
    try {
      _settings = _settings.copyWith(weeklyReportDay: day);
      await _settingsService.updateWeeklyReportDay(day);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update weekly report day: ${e.toString()}';
      print(_error);
      notifyListeners();
    }
  }

  Future<void> updateBudgetAlertThreshold(double threshold) async {
    try {
      _settings = _settings.copyWith(budgetAlertThreshold: threshold);
      await _settingsService.updateBudgetAlertThreshold(threshold);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update budget alert threshold: ${e.toString()}';
      print(_error);
      notifyListeners();
    }
  }

  void refresh() {
    loadSettings();
  }
}
