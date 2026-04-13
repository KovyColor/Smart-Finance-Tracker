/// String extensions
extension StringExtensions on String {
  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return '';
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Check if string is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Check if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if string is a valid phone number
  bool get isValidPhone {
    final phoneRegex = RegExp(r'^\+?[\d\s\-()]{10,}$');
    return phoneRegex.hasMatch(this);
  }

  /// Convert string to slug
  String get toSlug {
    return toLowerCase().replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(RegExp(r'[\s_]+'), '-');
  }

  /// Truncate string with ellipsis
  String truncate(int length, {String ellipsis = '...'}) {
    if (this.length <= length) return this;
    return '${substring(0, length)}$ellipsis';
  }

  /// Check if string contains only numbers
  bool get isNumeric => double.tryParse(this) != null;

  /// Check if string contains only letters
  bool get isAlpha => RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  /// Check if string contains only alphanumeric characters
  bool get isAlphaNumeric => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);

  /// Remove all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Reverse string
  String get reverse => split('').reversed.join('');

  /// Check if string is URL
  bool get isUrl {
    final urlRegex = RegExp(
      r'^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$',
      caseSensitive: false,
    );
    return urlRegex.hasMatch(this);
  }
}

/// DateTime extensions
extension DateTimeExtensions on DateTime {
  /// Format as "MMM dd, yyyy"
  String get formattedDate {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[month - 1]} ${day.toString().padLeft(2, '0')}, $year';
  }

  /// Format as "MMM dd"
  String get formattedDateShort {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[month - 1]} ${day.toString().padLeft(2, '0')}';
  }

  /// Format as "hh:mm a"
  String get formattedTime {
    final hour = this.hour % 12 == 0 ? 12 : this.hour % 12;
    final minute = this.minute.toString().padLeft(2, '0');
    final period = this.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  /// Format as "MMM dd, yyyy hh:mm a"
  String get formattedDateTime {
    return '$formattedDate $formattedTime';
  }

  /// Get time difference in words (e.g., "2 days ago")
  String get timeAgoWithWords {
    final duration = DateTime.now().difference(this);

    if (duration.inSeconds < 60) {
      return 'just now';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes}m ago';
    } else if (duration.inHours < 24) {
      return '${duration.inHours}h ago';
    } else if (duration.inDays < 7) {
      return '${duration.inDays}d ago';
    } else if (duration.inDays < 30) {
      return '${(duration.inDays / 7).floor()}w ago';
    } else if (duration.inDays < 365) {
      return '${(duration.inDays / 30).floor()}m ago';
    } else {
      return '${(duration.inDays / 365).floor()}y ago';
    }
  }

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  /// Get start of day
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  /// Get end of day
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }

  /// Get start of month
  DateTime get startOfMonth {
    return DateTime(year, month, 1);
  }

  /// Get end of month
  DateTime get endOfMonth {
    return DateTime(year, month + 1, 0, 23, 59, 59, 999);
  }

  /// Get start of year
  DateTime get startOfYear {
    return DateTime(year, 1, 1);
  }

  /// Get end of year
  DateTime get endOfYear {
    return DateTime(year, 12, 31, 23, 59, 59, 999);
  }

  /// Add months
  DateTime addMonths(int months) {
    return DateTime(year, month + months, day);
  }

  /// Add years
  DateTime addYears(int years) {
    return DateTime(year + years, month, day);
  }

  /// Check if date is in the same week as another date
  bool isSameWeek(DateTime other) {
    final diff = difference(other).inDays;
    return diff.abs() < 7 && weekday == other.weekday;
  }

  /// Get difference in days between two dates
  int daysSince(DateTime other) {
    return difference(other).inDays;
  }
}

/// Number extensions
extension NumberExtensions on num {
  /// Format as currency
  String toCurrency({String symbol = '\$', int decimals = 2}) {
    return '$symbol${toStringAsFixed(decimals)}';
  }

  /// Format with thousands separator
  String toFormattedString({String separator = ','}) {
    return toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match.group(1)}$separator',
    );
  }

  /// Convert bytes to human readable format
  String get toFileSize {
    const sizes = ['B', 'KB', 'MB', 'GB'];
    var bytes = toDouble();
    var sizeIndex = 0;

    while (bytes >= 1024 && sizeIndex < sizes.length - 1) {
      bytes /= 1024;
      sizeIndex++;
    }

    return '${bytes.toStringAsFixed(2)} ${sizes[sizeIndex]}';
  }

  /// Check if number is positive
  bool get isPositive => this > 0;

  /// Check if number is negative
  bool get isNegative => this < 0;

  /// Check if number is zero
  bool get isZero => this == 0;

  /// Get absolute value
  num get abs => this.abs();

  /// Get modulo
  num mod(num other) => this % other;

  /// Check if number is even
  bool get isEven => toInt() % 2 == 0;

  /// Check if number is odd
  bool get isOdd => toInt() % 2 != 0;

  /// Check if number is between two values
  bool isBetween(num min, num max) => this >= min && this <= max;

  /// Get percentage
  String percentageOf(num total) {
    final percentage = (this / total) * 100;
    return '${percentage.toStringAsFixed(2)}%';
  }
}
