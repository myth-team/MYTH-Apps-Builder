import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Brand Colors - Vibrant Electric Blue
  static Color primary = Color(0xFF2563EB);
  static Color primaryLight = Color(0xFF3B82F6);
  static Color primaryDark = Color(0xFF1D4ED8);

  // Secondary Accent - Energetic Coral/Orange
  static Color secondary = Color(0xFFF97316);
  static Color secondaryLight = Color(0xFFFB923C);
  static Color secondaryDark = Color(0xFFEA580C);

  // Success & Status Colors
  static Color success = Color(0xFF10B981);
  static Color successLight = Color(0xFFD1FAE5);
  static Color warning = Color(0xFFF59E0B);
  static Color warningLight = Color(0xFFFEF3C7);
  static Color error = Color(0xFFEF4444);
  static Color errorLight = Color(0xFFFEE2E2);
  static Color info = Color(0xFF06B6D4);
  static Color infoLight = Color(0xFFCFFAFE);

  // Neutral Scale - Modern Clean
  static Color neutral900 = Color(0xFF0F172A);
  static Color neutral800 = Color(0xFF1E293B);
  static Color neutral700 = Color(0xFF334155);
  static Color neutral600 = Color(0xFF475569);
  static Color neutral500 = Color(0xFF64748B);
  static Color neutral400 = Color(0xFF94A3B8);
  static Color neutral300 = Color(0xFFCBD5E1);
  static Color neutral200 = Color(0xFFE2E8F0);
  static Color neutral100 = Color(0xFFF1F5F9);
  static Color neutral50 = Color(0xFFF8FAFC);

  // Background Colors
  static Color background = Color(0xFFF8FAFC);
  static Color surface = Colors.white;
  static Color surfaceVariant = Color(0xFFF1F5F9);

  // Map & Location Colors
  static Color mapPin = Color(0xFF2563EB);
  static Color mapPinNearby = Color(0xFF10B981);
  static Color mapRoute = Color(0xFF2563EB);
  static Color mapRouteAlt = Color(0xFF3B82F6);
  static Color destinationPin = Color(0xFFEF4444);

  // Driver Status Colors
  static Color driverAvailable = Color(0xFF10B981);
  static Color driverEnRoute = Color(0xFFF59E0B);
  static Color driverArrived = Color(0xFF06B6D4);
  static Color driverBusy = Color(0xFFEF4444);

  // Ride Type Gradients
  static List<Color> economyGradient = [
    Color(0xFF2563EB),
    Color(0xFF3B82F6),
  ];
  static List<Color> premiumGradient = [
    Color(0xFF7C3AED),
    Color(0xFFA855F7),
  ];
  static List<Color> sharedGradient = [
    Color(0xFF059669),
    Color(0xFF10B981),
  ];
  static List<Color> xlGradient = [
    Color(0xFFDC2626),
    Color(0xFFEF4444),
  ];

  // Special Gradients
  static List<Color> primaryGradient = [
    Color(0xFF2563EB),
    Color(0xFF3B82F6),
    Color(0xFF60A5FA),
  ];
  static List<Color> accentGradient = [
    Color(0xFFF97316),
    Color(0xFFFB923C),
    Color(0xFFFDBA74),
  ];
  static List<Color> darkGradient = [
    Color(0xFF0F172A),
    Color(0xFF1E293B),
    Color(0xFF334155),
  ];
  static List<Color> successGradient = [
    Color(0xFF059669),
    Color(0xFF10B981),
    Color(0xFF34D399),
  ];

  // Overlay & Effects
  static Color scrim = Color(0x990F172A);
  static Color shadow = Color(0x1A0F172A);
  static Color shadowStrong = Color(0x330F172A);

  // Tier Badge Colors
  static Color tierBronze = Color(0xFFCD7F32);
  static Color tierSilver = Color(0xFFC0C0C0);
  static Color tierGold = Color(0xFFFFD700);
  static Color tierPlatinum = Color(0xFFE5E4E2);

  // Rating Colors
  static Color starFilled = Color(0xFFF59E0B);
  static Color starEmpty = Color(0xFFD1D5DB);

  // Payment Method Colors
  static Color cardVisa = Color(0xFF1A1F71);
  static Color cardMastercard = Color(0xFFEB001B);
  static Color walletPay = Color(0xFF000000);
  static Color cash = Color(0xFF10B981);

  // Shimmer Colors
  static Color shimmerBase = Color(0xFFE2E8F0);
  static Color shimmerHighlight = Color(0xFFF8FAFC);

  // Helper Methods
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  static LinearGradient buildGradient(List<Color> colors, {
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      colors: colors,
      begin: begin,
      end: end,
    );
  }

  static LinearGradient buildHorizontalGradient(List<Color> colors) {
    return LinearGradient(
      colors: colors,
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
  }

  static LinearGradient buildVerticalGradient(List<Color> colors) {
    return LinearGradient(
      colors: colors,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  static RadialGradient buildRadialGradient(List<Color> colors) {
    return RadialGradient(
      colors: colors,
      center: Alignment.center,
      radius: 0.8,
    );
  }

  // Semantic color getters for theme adaptation
  static Color get onPrimary => Colors.white;
  static Color get onSecondary => Colors.white;
  static Color get onSurface => neutral900;
  static Color get onBackground => neutral900;
  static Color get onError => Colors.white;
  static Color get onSuccess => Colors.white;

  // Divider and border colors
  static Color get divider => neutral200;
  static Color get border => neutral300;
  static Color get borderFocused => primary;

  // Text colors
  static Color get textPrimary => neutral900;
  static Color get textSecondary => neutral600;
  static Color get textTertiary => neutral400;
  static Color get textInverse => Colors.white;
  static Color get textDisabled => neutral400;

  // Interactive states
  static Color get hover => neutral100;
  static Color get pressed => neutral200;
  static Color get selected => primaryLight.withOpacity(0.12);
  static Color get focused => primary.withOpacity(0.12);
}