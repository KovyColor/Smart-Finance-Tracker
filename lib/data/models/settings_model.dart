enum Currency {
  USD,
  EUR,
  GBP,
  JPY,
  INR,
  CAD,
  AUD,
}

extension CurrencyExtension on Currency {
  String get symbol {
    switch (this) {
      case Currency.USD:
        return '\$';
      case Currency.EUR:
        return '€';
      case Currency.GBP:
        return '£';
      case Currency.JPY:
        return '¥';
      case Currency.INR:
        return '₹';
      case Currency.CAD:
        return 'C\$';
      case Currency.AUD:
        return 'A\$';
    }
  }

  String get code {
    return name;
  }
}

class AppSettings {
  final bool isDarkMode;
  final Currency currency;
  final bool notificationsEnabled;
  final bool budgetAlerts;
  final bool weeklyReports;
  final int weeklyReportDay; // 0 = Sunday, 6 = Saturday
  final double budgetAlertThreshold; // percentage (e.g., 80.0)

  AppSettings({
    required this.isDarkMode,
    required this.currency,
    required this.notificationsEnabled,
    required this.budgetAlerts,
    required this.weeklyReports,
    required this.weeklyReportDay,
    required this.budgetAlertThreshold,
  });

  factory AppSettings.defaults() {
    return AppSettings(
      isDarkMode: false,
      currency: Currency.USD,
      notificationsEnabled: true,
      budgetAlerts: true,
      weeklyReports: true,
      weeklyReportDay: 0, // Sunday
      budgetAlertThreshold: 80.0,
    );
  }

  AppSettings copyWith({
    bool? isDarkMode,
    Currency? currency,
    bool? notificationsEnabled,
    bool? budgetAlerts,
    bool? weeklyReports,
    int? weeklyReportDay,
    double? budgetAlertThreshold,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      currency: currency ?? this.currency,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      budgetAlerts: budgetAlerts ?? this.budgetAlerts,
      weeklyReports: weeklyReports ?? this.weeklyReports,
      weeklyReportDay: weeklyReportDay ?? this.weeklyReportDay,
      budgetAlertThreshold: budgetAlertThreshold ?? this.budgetAlertThreshold,
    );
  }
}
