import 'package:flutter/material.dart';

/// Application color constants
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Secondary Colors
  static const Color secondary = Color(0xFF10B981); // Emerald
  static const Color secondaryLight = Color(0xFF34D399);
  static const Color secondaryDark = Color(0xFF059669);

  // Accent Colors
  static const Color accent = Color(0xFFF59E0B); // Amber
  static const Color accentLight = Color(0xFFFCD34D);
  static const Color accentDark = Color(0xFFD97706);

  // Error Colors
  static const Color error = Color(0xFFEF4444); // Red
  static const Color errorLight = Color(0xFFFCA5A5);
  static const Color errorDark = Color(0xFFDC2626);

  // Success Colors
  static const Color success = Color(0xFF22C55E); // Green
  static const Color successLight = Color(0xFF86EFAC);
  static const Color successDark = Color(0xFF16A34A);

  // Warning Colors
  static const Color warning = Color(0xFFEAB308); // Yellow
  static const Color warningLight = Color(0xFFFDE047);
  static const Color warningDark = Color(0xFFCA8A04);

  // Info Colors
  static const Color info = Color(0xFF06B6D4); // Cyan
  static const Color infoLight = Color(0xFF06EFFF);
  static const Color infoDark = Color(0xFF0891B2);

  // Neutral Colors - Light Theme
  static const Color neutralLight50 = Color(0xFFFAFAFA);
  static const Color neutralLight100 = Color(0xFFF5F5F5);
  static const Color neutralLight200 = Color(0xFFEEEEEE);
  static const Color neutralLight300 = Color(0xFFE5E5E5);
  static const Color neutralLight400 = Color(0xFFBDBDBD);
  static const Color neutralLight500 = Color(0xFF9E9E9E);
  static const Color neutralLight600 = Color(0xFF757575);
  static const Color neutralLight700 = Color(0xFF616161);
  static const Color neutralLight800 = Color(0xFF424242);
  static const Color neutralLight900 = Color(0xFF212121);

  // Neutral Colors - Dark Theme
  static const Color neutralDark50 = Color(0xFF1A1A1A);
  static const Color neutralDark100 = Color(0xFF2A2A2A);
  static const Color neutralDark200 = Color(0xFF3A3A3A);
  static const Color neutralDark300 = Color(0xFF4A4A4A);
  static const Color neutralDark400 = Color(0xFF6A6A6A);
  static const Color neutralDark500 = Color(0xFF8A8A8A);
  static const Color neutralDark600 = Color(0xFFB0B0B0);
  static const Color neutralDark700 = Color(0xFFD0D0D0);
  static const Color neutralDark800 = Color(0xFFE8E8E8);
  static const Color neutralDark900 = Color(0xFFFFFFFF);

  // Light Theme Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color background = Color(0xFFFAFAFA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceLightAlt = Color(0xFFF9FAFB);
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderColor = Color(0xFFE5E7EB);
  static const Color dividerLight = Color(0xFFD1D5DB);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color hintLight = Color(0xFFCBD5E1);

  // Dark Theme Colors
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color surfaceDarkAlt = Color(0xFF334155);
  static const Color borderDark = Color(0xFF475569);
  static const Color dividerDark = Color(0xFF64748B);
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFFCBD5E1);
  static const Color textTertiaryDark = Color(0xFF94A3B8);
  static const Color hintDark = Color(0xFF64748B);

  // Semantic Colors
  static const Color income = Color(0xFF10B981); // Green
  static const Color expense = Color(0xFFEF4444); // Red
  static const Color transfer = Color(0xFF6366F1); // Indigo
  static const Color pending = Color(0xFFF59E0B); // Amber

  // Gradients
  static const List<Color> gradientPrimary = [
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
  ];

  static const List<Color> gradientSuccess = [
    Color(0xFF10B981),
    Color(0xFF06B6D4),
  ];

  static const List<Color> gradientWarning = [
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
  ];
}
