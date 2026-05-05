import 'package:flutter/material.dart';

class AppColors {
  static Color primary = Color(0xFF6C63FF);
  static Color secondary = Color(0xFF00BFA6);
  static Color accent = Color(0xFFFF6584);
  static Color background = Color(0xFFF8F9FE);
  static Color surface = Colors.white;
  static Color textPrimary = Color(0xFF2D3142);
  static Color textSecondary = Color(0xFF9CA3AF);
  static Color success = Color(0xFF4CAF50);
  static Color warning = Color(0xFFFFA726);
  static Color error = Color(0xFFEF5350);
  static Color ringBg = Color(0xFFE8E8F0);
  static Color surfaceDark = Color(0xFF1E1E2E);
  static Color backgroundDark = Color(0xFF12121A);
  static Color textPrimaryDark = Color(0xFFF1F1F6);
  static Color textSecondaryDark = Color(0xFF8E8E93);

  static LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF00BFA6), Color(0xFF00E5FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}