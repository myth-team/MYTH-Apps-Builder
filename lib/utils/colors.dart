import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF1A1A2E);
  static const Color primaryLight = Color(0xFF16213E);
  static const Color primaryDark = Color(0xFF0F3460);

  // Accent / Secondary
  static const Color accent = Color(0xFFE94560);
  static const Color accentLight = Color(0xFFFF6B6B);
  static const Color accentDark = Color(0xFFC73E54);

  // Backgrounds
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color card = Colors.white;

  // Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Colors.white;

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Ride Status
  static const Color statusRequested = Color(0xFF3B82F6);
  static const Color statusAccepted = Color(0xFF8B5CF6);
  static const Color statusArriving = Color(0xFFF59E0B);
  static const Color statusInTrip = Color(0xFF10B981);
  static const Color statusCompleted = Color(0xFF6B7280);

  // Ride Types
  static const Color economy = Color(0xFF10B981);
  static const Color premium = Color(0xFF8B5CF6);
  static const Color bike = Color(0xFFF59E0B);

  // Divider & Border
  static const Color divider = Color(0xFFE5E7EB);
  static const Color border = Color(0xFFD1D5DB);

  // Misc
  static const Color shadow = Color(0x1A000000);
  static const Color overlay = Color(0x80000000);
  static const Color shimmer = Color(0xFFE5E7EB);
}