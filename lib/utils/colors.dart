import 'package:flutter/material.dart';

/// MYTH Original Design System — Color Palette
/// A vibrant, modern, and clean color system for the ride-hailing app.
class AppColors {
  AppColors._();

  // ─── Primary Brand Colors ───────────────────────────────────────────────────
  /// Electric Violet — primary CTA, buttons, highlights
  static const Color primary = Color(0xFF6C3BFF);

  /// Deep Indigo — primary dark variant
  static const Color primaryDark = Color(0xFF4A1FD6);

  /// Soft Lavender — primary light / tint
  static const Color primaryLight = Color(0xFFA98AFF);

  /// Ultra-light primary tint for backgrounds
  static const Color primarySurface = Color(0xFFF0EBFF);

  // ─── Secondary / Accent Colors ──────────────────────────────────────────────
  /// Neon Coral — secondary accent, fare estimates, key highlights
  static const Color secondary = Color(0xFFFF5C7A);

  /// Deep Coral — secondary dark variant
  static const Color secondaryDark = Color(0xFFD63854);

  /// Soft Pink — secondary light variant
  static const Color secondaryLight = Color(0xFFFF9BAC);

  /// Ultra-light secondary tint
  static const Color secondarySurface = Color(0xFFFFF0F3);

  // ─── Tertiary / Complementary ───────────────────────────────────────────────
  /// Cyber Teal — online status, success states, map accents
  static const Color tertiary = Color(0xFF00D4AA);

  /// Deep Teal — tertiary dark
  static const Color tertiaryDark = Color(0xFF00A882);

  /// Light Teal — tertiary light
  static const Color tertiaryLight = Color(0xFF80EFDA);

  /// Teal surface tint
  static const Color tertiarySurface = Color(0xFFE6FBF7);

  // ─── Semantic / Status Colors ────────────────────────────────────────────────
  /// Success — confirmed ride, payment success
  static const Color success = Color(0xFF22C55E);
  static const Color successDark = Color(0xFF16A34A);
  static const Color successLight = Color(0xFF86EFAC);
  static const Color successSurface = Color(0xFFF0FDF4);

  /// Warning — surge pricing, low battery, pending state
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningDark = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFCD34D);
  static const Color warningSurface = Color(0xFFFFFBEB);

  /// Error — failed payment, cancelled ride, offline error
  static const Color error = Color(0xFFEF4444);
  static const Color errorDark = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFCA5A5);
  static const Color errorSurface = Color(0xFFFEF2F2);

  /// Info — ETA chip, informational banners
  static const Color info = Color(0xFF3B82F6);
  static const Color infoDark = Color(0xFF2563EB);
  static const Color infoLight = Color(0xFF93C5FD);
  static const Color infoSurface = Color(0xFFEFF6FF);

  // ─── Neutral / Grey Scale ───────────────────────────────────────────────────
  /// Pure White — card backgrounds, modal backgrounds
  static const Color white = Color(0xFFFFFFFF);

  /// Off-White — page backgrounds (light mode)
  static const Color offWhite = Color(0xFFF8F7FC);

  /// Surface Light — subtle card elevation
  static const Color surfaceLight = Color(0xFFF3F1FA);

  /// Border Light — dividers, input borders
  static const Color borderLight = Color(0xFFE4E0F0);

  /// Muted Grey — disabled states, placeholder text
  static const Color grey100 = Color(0xFFF5F4FA);
  static const Color grey200 = Color(0xFFEAE8F5);
  static const Color grey300 = Color(0xFFD4D0E8);
  static const Color grey400 = Color(0xFFB8B3D8);
  static const Color grey500 = Color(0xFF9089BE);

  /// Mid Grey — secondary text, subtitles
  static const Color grey600 = Color(0xFF6B6494);
  static const Color grey700 = Color(0xFF4E4870);

  /// Dark Grey — primary text on light background
  static const Color grey800 = Color(0xFF2D2952);
  static const Color grey900 = Color(0xFF1A1733);

  // ─── Dark Mode / Dark Surface Colors ─────────────────────────────────────────
  /// Dark background — main app background (dark mode)
  static const Color darkBackground = Color(0xFF0F0E1A);

  /// Dark surface — cards, bottom sheets (dark mode)
  static const Color darkSurface = Color(0xFF1C1A2E);

  /// Dark surface elevated — modals, dialogs (dark mode)
  static const Color darkSurfaceElevated = Color(0xFF252340);

  /// Dark border — dividers and borders (dark mode)
  static const Color darkBorder = Color(0xFF312E50);

  /// Dark text primary — headings on dark backgrounds
  static const Color darkTextPrimary = Color(0xFFF0EEFF);

  /// Dark text secondary — subtitles on dark backgrounds
  static const Color darkTextSecondary = Color(0xFFADA8D0);

  // ─── Map-Specific Colors ──────────────────────────────────────────────────────
  /// Driver marker fill — online driver pin
  static const Color mapDriverMarker = Color(0xFF6C3BFF);

  /// Route polyline — active route on map
  static const Color mapRoute = Color(0xFF6C3BFF);

  /// Route polyline — alternate route
  static const Color mapRouteAlt = Color(0xFFB8B3D8);

  /// Pickup marker — green pin
  static const Color mapPickup = Color(0xFF22C55E);

  /// Dropoff marker — red pin
  static const Color mapDropoff = Color(0xFFEF4444);

  /// Map overlay tint (semi-transparent dark overlay)
  static const Color mapOverlay = Color(0x801A1733);

  // ─── Vehicle Type Colors ──────────────────────────────────────────────────────
  /// Economy vehicle card accent
  static const Color vehicleEconomy = Color(0xFF3B82F6);

  /// Luxury vehicle card accent
  static const Color vehicleLuxury = Color(0xFF6C3BFF);

  /// XL vehicle card accent
  static const Color vehicleXL = Color(0xFF00D4AA);

  // ─── Chart / Dashboard Colors ─────────────────────────────────────────────────
  /// Bar chart bar color — primary earnings bar
  static const Color chartBar1 = Color(0xFF6C3BFF);

  /// Bar chart bar color — secondary / comparison bar
  static const Color chartBar2 = Color(0xFFFF5C7A);

  /// Bar chart bar color — tertiary accent
  static const Color chartBar3 = Color(0xFF00D4AA);

  /// Chart grid line
  static const Color chartGrid = Color(0xFFE4E0F0);

  /// Chart axis label
  static const Color chartLabel = Color(0xFF9089BE);

  /// Chart tooltip background
  static const Color chartTooltip = Color(0xFF1C1A2E);

  // ─── Gradient Definitions ─────────────────────────────────────────────────────
  /// Primary gradient — used on hero buttons, onboarding backgrounds
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B5FFF), Color(0xFF6C3BFF), Color(0xFF4A1FD6)],
    stops: [0.0, 0.5, 1.0],
  );

  /// Secondary gradient — used on secondary CTAs, fare display
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF7A92), Color(0xFFFF5C7A), Color(0xFFD63854)],
    stops: [0.0, 0.5, 1.0],
  );

  /// Teal gradient — used for online status, success banners
  static const LinearGradient tealGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00EFBF), Color(0xFF00D4AA), Color(0xFF00A882)],
    stops: [0.0, 0.5, 1.0],
  );

  /// Dark gradient — map overlays, bottom sheet dark headers
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1C1A2E), Color(0xFF0F0E1A)],
    stops: [0.0, 1.0],
  );

  /// Onboarding background gradient
  static const LinearGradient onboardingGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1C1A2E),
      Color(0xFF252340),
      Color(0xFF312E50),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Earnings card gradient
  static const LinearGradient earningsGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6C3BFF), Color(0xFFFF5C7A)],
    stops: [0.0, 1.0],
  );

  /// Wallet balance gradient
  static const LinearGradient walletGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00D4AA), Color(0xFF3B82F6)],
    stops: [0.0, 1.0],
  );

  // ─── Shadow Colors ─────────────────────────────────────────────────────────────
  /// Primary shadow — elevation on primary-colored elements
  static const Color shadowPrimary = Color(0x406C3BFF);

  /// Neutral shadow — standard card shadows
  static const Color shadowNeutral = Color(0x1A1A1733);

  /// Dark shadow — stronger depth on overlays
  static const Color shadowDark = Color(0x400F0E1A);

  // ─── Overlay / Scrim Colors ────────────────────────────────────────────────────
  /// Scrim / modal barrier (semi-transparent dark)
  static const Color scrim = Color(0xCC0F0E1A);

  /// Light scrim — for bottom sheets on light backgrounds
  static const Color scrimLight = Color(0x661A1733);

  // ─── Shimmer Colors (loading skeletons) ───────────────────────────────────────
  /// Shimmer base color
  static const Color shimmerBase = Color(0xFFE4E0F0);

  /// Shimmer highlight color
  static const Color shimmerHighlight = Color(0xFFF5F4FA);

  /// Shimmer base color — dark mode
  static const Color shimmerBaseDark = Color(0xFF252340);

  /// Shimmer highlight color — dark mode
  static const Color shimmerHighlightDark = Color(0xFF312E50);

  // ─── Star Rating Colors ─────────────────────────────────────────────────────
  /// Star active (filled)
  static const Color starActive = Color(0xFFF59E0B);

  /// Star inactive (empty)
  static const Color starInactive = Color(0xFFD4D0E8);

  // ─── Online / Offline Status ─────────────────────────────────────────────────
  /// Driver online indicator
  static const Color onlineStatus = Color(0xFF22C55E);

  /// Driver offline indicator
  static const Color offlineStatus = Color(0xFF9089BE);

  /// Driver busy / on-trip indicator
  static const Color busyStatus = Color(0xFFF59E0B);

  // ─── Helper Methods ───────────────────────────────────────────────────────────

  /// Returns a color with custom opacity without modifying the original constant.
  static Color withAlpha(Color color, double opacity) {
    return color.withOpacity(opacity.clamp(0.0, 1.0));
  }

  /// Returns the text color (white or dark) that best contrasts with [background].
  static Color contrastingTextColor(Color background) {
    final luminance = background.computeLuminance();
    return luminance > 0.4 ? grey900 : white;
  }

  /// Returns vehicle color by type string key.
  static Color vehicleColor(String typeKey) {
    switch (typeKey.toLowerCase()) {
      case 'economy':
        return vehicleEconomy;
      case 'luxury':
        return vehicleLuxury;
      case 'xl':
        return vehicleXL;
      default:
        return primary;
    }
  }

  /// Returns status color for a given ride status string.
  static Color rideStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'confirmed':
        return success;
      case 'pending':
      case 'matching':
        return warning;
      case 'cancelled':
      case 'failed':
        return error;
      case 'completed':
        return info;
      default:
        return grey500;
    }
  }

  /// Returns driver availability status color.
  static Color driverStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'online':
        return onlineStatus;
      case 'offline':
        return offlineStatus;
      case 'busy':
      case 'on_trip':
        return busyStatus;
      default:
        return offlineStatus;
    }
  }

  // ─── Theme-aware Accessors ────────────────────────────────────────────────────

  /// Returns the correct background color for the given [brightness].
  static Color backgroundColor(Brightness brightness) {
    return brightness == Brightness.dark ? darkBackground : offWhite;
  }

  /// Returns the correct surface color for the given [brightness].
  static Color surfaceColor(Brightness brightness) {
    return brightness == Brightness.dark ? darkSurface : white;
  }

  /// Returns the correct primary text color for the given [brightness].
  static Color textPrimary(Brightness brightness) {
    return brightness == Brightness.dark ? darkTextPrimary : grey900;
  }

  /// Returns the correct secondary text color for the given [brightness].
  static Color textSecondary(Brightness brightness) {
    return brightness == Brightness.dark ? darkTextSecondary : grey600;
  }

  /// Returns the correct border color for the given [brightness].
  static Color borderColor(Brightness brightness) {
    return brightness == Brightness.dark ? darkBorder : borderLight;
  }
}