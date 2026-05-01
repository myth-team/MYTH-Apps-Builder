import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlack = Color(0xFF1A1A1A);
  static const Color darkBlack = Color(0xFF0D0D0D);
  static const Color lightBlack = Color(0xFF2D2D2D);
  
  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color darkGold = Color(0xFFB8860B);
  static const Color lightGold = Color(0xFFFFD700);
  static const Color mutedGold = Color(0xFFBFA456);
  
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF5F5F5);
  static const Color creamWhite = Color(0xFFFAF9F6);
  
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textTertiary = Color(0xFF808080);
  static const Color textDark = Color(0xFF1A1A1A);
  
  static const Color backgroundPrimary = Color(0xFF121212);
  static const Color backgroundSecondary = Color(0xFF1E1E1E);
  static const Color backgroundCard = Color(0xFF252525);
  static const Color backgroundElevated = Color(0xFF2A2A2A);
  
  static const Color divider = Color(0xFF3D3D3D);
  static const Color border = Color(0xFF404040);
  static const Color borderGold = Color(0xFFD4AF37);
  
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  static const Color favoriteRed = Color(0xFFE91E63);
  static const Color starYellow = Color(0xFFFFC107);
  
  static const Color shimmerBase = Color(0xFF2D2D2D);
  static const Color shimmerHighlight = Color(0xFF3D3D3D);
  
  static const Color overlayDark = Color(0x99000000);
  static const Color overlayLight = Color(0x4DFFFFFF);
  
  static const LinearGradient goldGradient = LinearGradient(
    colors: [primaryGold, darkGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient darkGradient = LinearGradient(
    colors: [darkBlack, primaryBlack],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [backgroundCard, backgroundSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [shimmerBase, shimmerHighlight, shimmerBase],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
  );
}

class ColorScheme {
  static Color get primary => AppColors.primaryGold;
  static Color get onPrimary => AppColors.darkBlack;
  static Color get secondary => AppColors.primaryBlack;
  static Color get onSecondary => AppColors.pureWhite;
  static Color get surface => AppColors.backgroundCard;
  static Color get onSurface => AppColors.textPrimary;
  static Color get error => AppColors.error;
  static Color get onError => AppColors.pureWhite;
  static Color get background => AppColors.backgroundPrimary;
  static Color get onBackground => AppColors.textPrimary;
}