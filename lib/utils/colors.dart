import 'package:flutter/material.dart';

class AppColors {
  // Primary colors - vibrant modern palette
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF5A52D5);
  static const Color primaryLight = Color(0xFF8B85FF);

  // Player colors
  static const Color playerX = Color(0xFFFF6B6B);
  static const Color playerO = Color(0xFF4ECDC4);
  static const Color playerXDark = Color(0xFFE85555);
  static const Color playerODark = Color(0xFF3DBDB4);

  // Background colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFFE9ECEF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFFDEE2E6);

  // Text colors
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textLight = Color(0xFFFFFFFF);

  // Game board colors
  static const Color gridLine = Color(0xFFDEE2E6);
  static const Color gridLineDark = Color(0xFFADB5BD);
  static const Color cellEmpty = Color(0xFFF8F9FA);
  static const Color cellHover = Color(0xFFE9ECEF);

  // Accent and status colors
  static const Color winHighlight = Color(0xFFFFE66D);
  static const Color draw = Color(0xFFFFB347);
  static const Color error = Color(0xFFFF4757);
  static const Color success = Color(0xFF2ED573);

  // Gradient for enhanced visuals
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient playerXGradient = LinearGradient(
    colors: [playerX, playerXDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient playerOGradient = LinearGradient(
    colors: [playerO, playerODark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [background, backgroundDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}