import 'package:flutter/material.dart';

class AppColors {
  static Color primary = const Color(0xFF6C63FF);
  static Color primaryLight = const Color(0xFF9D97FF);
  static Color primaryDark = const Color(0xFF4B44B2);
  
  static Color secondary = const Color(0xFFFF6B6B);
  static Color secondaryLight = const Color(0xFFFF9B9B);
  
  static Color accent = const Color(0xFF00D9A5);
  static Color accentLight = const Color(0xFF4DEDC9);
  
  static Color background = const Color(0xFFF8F9FE);
  static Color surface = Colors.white;
  static Color cardBackground = Colors.white;
  
  static Color textPrimary = const Color(0xFF1A1A2E);
  static Color textSecondary = const Color(0xFF6B6B80);
  static Color textLight = const Color(0xFF9E9EB5);
  
  static Color success = const Color(0xFF00C853);
  static Color warning = const Color(0xFFFFB300);
  static Color error = const Color(0xFFFF5252);
  static Color info = const Color(0xFF2196F3);
  
  static Color divider = const Color(0xFFE8E8F0);
  static Color shadow = const Color(0x1A000000);
  
  static Color economyGreen = const Color(0xFF00C853);
  static Color premiumBlue = const Color(0xFF2979FF);
  static Color bikeOrange = const Color(0xFFFF6D00);
  static Color suvPurple = const Color(0xFF7C4DFF);
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textLight,
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
}

class AppDimens {
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;
  
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusCircle = 100.0;
  
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;
}