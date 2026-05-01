import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFF2E7D32); // Forest Green - main brand
  static const Color primaryLight = Color(0xFF60AD5E);
  static const Color primaryDark = Color(0xFF005005);
  
  // Secondary Brand Colors
  static const Color secondary = Color(0xFF1565C0); // Blue - secondary actions
  static const Color secondaryLight = Color(0xFF5E92F3);
  static const Color secondaryDark = Color(0xFF003C8F);
  
  // Accent Colors
  static const Color accent = Color(0xFFFF6F00); // Orange - highlights
  static const Color accentLight = Color(0xFFFFA040);
  static const Color accentDark = Color(0xFFC43E00);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF80E27E);
  static const Color successDark = Color(0xFF087F23);
  
  static const Color warning = Color(0xFFFFC107);
  static const Color warningLight = Color(0xFFFFD54F);
  static const Color warningDark = Color(0xFFC79100);
  
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFFF7961);
  static const Color errorDark = Color(0xFFBA000D);
  
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF6EC6FF);
  static const Color infoDark = Color(0xFF0069C0);
  
  // Neutral / Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFFAFAFA);
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // Grey Scale
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);
  static const Color textOnAccent = Color(0xFFFFFFFF);
  
  // Map Specific Colors
  static const Color mapPinRider = Color(0xFF2196F3);
  static const Color mapPinDriver = Color(0xFF4CAF50);
  static const Color mapRouteActive = Color(0xFF2E7D32);
  static const Color mapRouteInactive = Color(0xFFBDBDBD);
  static const Color mapZoneActive = Color(0x332E7D32);
  static const Color mapZoneInactive = Color(0x1A757575);
  
  // Vehicle Type Colors
  static const Color vehicleEconomy = Color(0xFF78909C);
  static const Color vehicleComfort = Color(0xFF42A5F5);
  static const Color vehicleLuxury = Color(0xFFFFB300);
  static const Color vehicleXL = Color(0xFF8D6E63);
  
  // Driver Status Colors
  static const Color driverOnline = Color(0xFF4CAF50);
  static const Color driverOffline = Color(0xFF9E9E9E);
  static const Color driverEnRoute = Color(0xFFFFC107);
  static const Color driverOnTrip = Color(0xFF2196F3);
  
  // Rider Status Colors
  static const Color riderSearching = Color(0xFFFFC107);
  static const Color riderMatched = Color(0xFF2196F3);
  static const Color riderInTransit = Color(0xFF4CAF50);
  static const Color riderCompleted = Color(0xFF2E7D32);
  static const Color riderCancelled = Color(0xFFF44336);
  
  // Payment Colors
  static const Color paymentPending = Color(0xFFFFC107);
  static const Color paymentCompleted = Color(0xFF4CAF50);
  static const Color paymentFailed = Color(0xFFF44336);
  static const Color paymentRefunded = Color(0xFF9C27B0);
  
  // Overlay Colors
  static const Color overlayDark = Color(0x80000000);
  static const Color overlayLight = Color(0x40FFFFFF);
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  
  // Divider & Border Colors
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFBDBDBD);
  static const Color borderLight = Color(0xFFEEEEEE);
  
  // Rating Star Colors
  static const Color starFilled = Color(0xFFFFC107);
  static const Color starEmpty = Color(0xFFE0E0E0);
  
  // Bottom Sheet & Dialog Colors
  static const Color bottomSheetBackground = Color(0xFFFFFFFF);
  static const Color dialogBackground = Color(0xFFFFFFFF);
  
  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF2E7D32),
    Color(0xFF60AD5E),
  ];
  
  static const List<Color> secondaryGradient = [
    Color(0xFF1565C0),
    Color(0xFF5E92F3),
  ];
  
  static const List<Color> accentGradient = [
    Color(0xFFFF6F00),
    Color(0xFFFFA040),
  ];
  
  static const List<Color> mapRouteGradient = [
    Color(0xFF2E7D32),
    Color(0xFF1565C0),
  ];
  
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkDivider = Color(0xFF3D3D3D);
}

// Extension to easily create MaterialColor from AppColors
extension AppColorsExtension on Color {
  MaterialColor toMaterialColor() {
    return MaterialColor(
      value,
      <int, Color>{
        50: _tintColor(0.95),
        100: _tintColor(0.9),
        200: _tintColor(0.8),
        300: _tintColor(0.7),
        400: _tintColor(0.6),
        500: this,
        600: _tintColor(0.4),
        700: _tintColor(0.3),
        800: _tintColor(0.2),
        900: _tintColor(0.1),
      },
    );
  }
  
  Color _tintColor(double intensity) {
    final r = red + ((255 - red) * intensity).round();
    final g = green + ((255 - green) * intensity).round();
    final b = blue + ((255 - blue) * intensity).round();
    return Color.fromARGB(255, r, g, b);
  }
}

// Theme builder helper
class AppThemeColors {
  static ColorScheme lightColorScheme() {
    return const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.textPrimary,
      secondary: AppColors.secondary,
      onSecondary: AppColors.textOnSecondary,
      secondaryContainer: AppColors.secondaryLight,
      onSecondaryContainer: AppColors.textPrimary,
      tertiary: AppColors.accent,
      onTertiary: AppColors.textOnAccent,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.grey100,
      outline: AppColors.border,
    );
  }
  
  static ColorScheme darkColorScheme() {
    return const ColorScheme.dark(
      primary: AppColors.primaryLight,
      onPrimary: AppColors.textPrimary,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: AppColors.darkTextPrimary,
      secondary: AppColors.secondaryLight,
      onSecondary: AppColors.textPrimary,
      secondaryContainer: AppColors.secondaryDark,
      onSecondaryContainer: AppColors.darkTextPrimary,
      tertiary: AppColors.accentLight,
      onTertiary: AppColors.textPrimary,
      error: AppColors.errorLight,
      onError: Colors.black,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      surfaceContainerHighest: AppColors.darkCard,
      outline: AppColors.darkDivider,
    );
  }
}