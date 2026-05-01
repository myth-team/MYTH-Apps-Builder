import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors - Black & Gold Theme
  static const Color primaryBlack = Color(0xFF1A1A1A);
  static const Color secondaryBlack = Color(0xFF2D2D2D);
  static const Color cardBlack = Color(0xFF252525);
  static const Color surfaceBlack = Color(0xFF0D0D0D);

  // Gold Accents
  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color lightGold = Color(0xFFE8C765);
  static const Color darkGold = Color(0xFFB8962E);
  static const Color goldShadow = Color(0x40D4AF37);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF5F5F5);
  static const Color grey100 = Color(0xFFF0F0F0);
  static const Color grey300 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey900 = Color(0xFF212121);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    colors: [primaryGold, lightGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blackGradient = LinearGradient(
    colors: [primaryBlack, secondaryBlack],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient darkOverlay = LinearGradient(
    colors: [Colors.transparent, Color(0xCC000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}