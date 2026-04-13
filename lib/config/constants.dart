/// Global application constants
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // API Configuration
  static const String baseUrl = 'https://api.smartfinancetracker.com';
  static const String apiVersion = 'v1';
  static const int connectionTimeout = 30000; // milliseconds
  static const int receiveTimeout = 30000; // milliseconds

  // Local Storage Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserData = 'user_data';
  static const String keyUserPreferences = 'user_preferences';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyBiometricEnabled = 'biometric_enabled';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyLastSyncTime = 'last_sync_time';

  // Pagination
  static const int pageSize = 20;
  static const int initialPage = 1;

  // Validation Rules
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;

  // Animation Durations
  static const Duration animationDurationShort = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);

  // Retry Configuration
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 1);

  // Currency Codes
  static const String currencyUSD = 'USD';
  static const String currencyEUR = 'EUR';
  static const String currencyGBP = 'GBP';
  static const String currencyINR = 'INR';

  // Date Formats
  static const String dateFormatLong = 'MMMM dd, yyyy';
  static const String dateFormatShort = 'MMM dd, yyyy';
  static const String timeFormatHMS = 'h:mm:ss a';
  static const String dateTimeFormat = 'MMM dd, yyyy h:mm a';

  // Asset Paths
  static const String assetImagesPath = 'assets/images/';
  static const String assetIconsPath = 'assets/icons/';
  static const String assetAnimationsPath = 'assets/animations/';

  // Default Values
  static const double defaultBudgetAmount = 0.0;
  static const int defaultTransactionLimit = 100;

  // Transaction Categories
  static const List<String> expenseCategories = [
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Bills & Utilities',
    'Healthcare',
    'Education',
    'Travel',
    'Personal Care',
    'Other',
  ];

  static const List<String> incomeCategories = [
    'Salary',
    'Freelance',
    'Investment',
    'Bonus',
    'Refund',
    'Gift',
    'Other',
  ];

  // Analytics
  static const int analyticsDaysDefault = 30;
  static const int analyticsMaxDays = 365;
}
