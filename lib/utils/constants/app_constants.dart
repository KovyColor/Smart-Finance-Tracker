/// Application-wide constants
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // Network timeouts (in milliseconds)
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // API Configuration
  static const String baseUrl = 'https://api.example.com';

  // Local storage keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String settingsKey = 'app_settings';

  // Features
  static const bool enableAnalytics = true;
  static const bool enableOfflineMode = true;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache duration (in minutes)
  static const int cacheDuration = 60;

  // Auth Configuration
  static const int minPasswordLength = 8;
}
