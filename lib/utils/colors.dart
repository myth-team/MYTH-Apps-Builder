import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primary = Color(0xFF1E88E5);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF64B5F6);

  // Secondary/Accent Colors
  static const Color accent = Color(0xFFFF6F00);
  static const Color accentDark = Color(0xFFE65100);
  static const Color accentLight = Color(0xFFFFB74D);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color warning = Color(0xFFFFC107);
  static const Color warningLight = Color(0xFFFFD54F);
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFEF5350);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnAccent = Color(0xFFFFFFFF);

  // Divider & Border Colors
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFF5F5F5);

  // Map & Location Colors
  static const Color mapRoute = Color(0xFF1E88E5);
  static const Color mapRouteAlternative = Color(0xFF7CB342);
  static const Color driverMarker = Color(0xFF4CAF50);
  static const Color riderMarker = Color(0xFFFF6F00);
  static const Color pickupMarker = Color(0xFF4CAF50);
  static const Color dropoffMarker = Color(0xFFE53935);

  // Vehicle Type Colors
  static const Color economyCar = Color(0xFF42A5F5);
  static const Color luxuryCar = Color(0xFF7E57C2);
  static const Color xlCar = Color(0xFF26A69A);

  // Driver Status Colors
  static const Color onlineStatus = Color(0xFF4CAF50);
  static const Color offlineStatus = Color(0xFF9E9E9E);
  static const Color busyStatus = Color(0xFFFF9800);

  // Earnings & Payment Colors
  static const Color earningsPositive = Color(0xFF4CAF50);
  static const Color earningsNegative = Color(0xFFE53935);
  static const Color walletBackground = Color(0xFF1E88E5);

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient walletGradient = LinearGradient(
    colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Overlay colors for modals
  static const Color overlayDark = Color(0x99000000);
  static const Color overlayLight = Color(0x33000000);
}