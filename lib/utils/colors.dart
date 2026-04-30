import 'package:flutter/material.dart';

class AppColors {
  static final Color primaryColor = Color(0xFF6C63FF);
  static final Color secondaryColor = Color(0xFFFF6584);
  static final Color backgroundColor = Color(0xFFF8F9FE);
  static final Color surfaceColor = Colors.white;
  static final Color textPrimary = Color(0xFF2D3436);
  static final Color textSecondary = Color(0xFF636E72);
  static final Color successColor = Color(0xFF00B894);
  static final Color warningColor = Color(0xFFFDCB6E);
  static final Color errorColor = Color(0xFFE17055);
  static final Color incrementColor = Color(0xFF00B894);
  static final Color decrementColor = Color(0xFFE17055);
  static final Color resetColor = Color(0xFF6C63FF);
  static final Color cardShadow = Color(0x1A000000);
  static final Color counterBackground = Color(0xFFE8EAF6);
  static final Color iconColor = Color(0xFF2D3436);
  static final Color buttonGradientStart = Color(0xFF6C63FF);
  static final Color buttonGradientEnd = Color(0xFF8B7BFF);
}

class ColorUtils {
  static List<Color> get primaryGradient => [
        AppColors.buttonGradientStart,
        AppColors.buttonGradientEnd,
      ];

  static List<Color> get incrementGradient => [
        Color(0xFF00B894),
        Color(0xFF55EFC4),
      ];

  static List<Color> get decrementGradient => [
        Color(0xFFE17055),
        Color(0xFFFDCB6E),
      ];

  static List<Color> get resetGradient => [
        Color(0xFF6C63FF),
        Color(0xFFA29BFE),
      ];

  static ColorScheme get colorScheme => ColorScheme.light(
        primary: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        surface: AppColors.surfaceColor,
        error: AppColors.errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      );

  static BoxDecoration get primaryButtonDecoration => BoxDecoration(
        gradient: LinearGradient(
          colors: [...primaryGradient],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      );

  static BoxDecoration get cardDecoration => BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      );
}