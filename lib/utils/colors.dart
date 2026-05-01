import 'package:flutter/material.dart';

class AppColors {
  // Primary Golden Theme Colors
  static const Color primary = Color(0xFFD4AF37); // Metallic Gold
  static const Color primaryLight = Color(0xFFF5D78E); // Light Gold
  static const Color primaryDark = Color(0xFFAA8C2C); // Dark Gold

  // Background Colors (Black/Dark Theme)
  static const Color background = Color(0xFF0A0A0A); // Near Black
  static const Color backgroundSecondary = Color(0xFF141414); // Dark Gray
  static const Color surface = Color(0xFF1E1E1E); // Card Surface
  static const Color surfaceLight = Color(0xFF2A2A2A); // Light Surface

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF); // White
  static const Color textSecondary = Color(0xFFB0B0B0); // Light Gray
  static const Color textMuted = Color(0xFF707070); // Muted Gray

  // Accent Colors
  static const Color accent = Color(0xFFD4AF37); // Gold Accent
  static const Color success = Color(0xFF4CAF50); // Green
  static const Color error = Color(0xFFE53935); // Red
  static const Color warning = Color(0xFFFFC107); // Amber

  // Gradient Colors
  static const LinearGradient goldGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [background, backgroundSecondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [surface, surfaceLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}