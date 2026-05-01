import 'package:flutter/material.dart';
import 'package:golden_stay_app/utils/colors.dart'; 

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryGold,
      scaffoldBackgroundColor: AppColors.primaryBlack,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryGold,
        secondary: AppColors.lightGold,
        surface: AppColors.lightBlack,
        error: Colors.redAccent,
        onPrimary: AppColors.primaryBlack,
        onSecondary: AppColors.primaryBlack,
        onSurface: AppColors.pureWhite,
        onError: AppColors.pureWhite,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryBlack,
        foregroundColor: AppColors.primaryGold,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.primaryGold,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
        iconTheme: IconThemeData(
          color: AppColors.primaryGold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkBlack,
        selectedItemColor: AppColors.primaryGold,
        unselectedItemColor: AppColors.mutedGold,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkBlack,
        indicatorColor: AppColors.primaryGold.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: AppColors.primaryGold,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            );
          }
          return const TextStyle(
            color: AppColors.mutedGold,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: AppColors.primaryGold,
            );
          }
          return const IconThemeData(
            color: AppColors.mutedGold,
          );
        }),
      ),
      cardTheme: CardTheme(
        color: AppColors.lightBlack,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGold,
          foregroundColor: AppColors.primaryBlack,
          elevation: 4,
          shadowColor: AppColors.primaryGold.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryGold,
          side: const BorderSide(color: AppColors.primaryGold, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryGold,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryGold,
        foregroundColor: AppColors.primaryBlack,
        elevation: 6,
        shape: CircleBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightBlack,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.mutedGold, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGold, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
        labelStyle: const TextStyle(
          color: AppColors.mutedGold,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: TextStyle(
          color: AppColors.mutedGold.withValues(alpha: 0.7),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: const TextStyle(
          color: Colors.redAccent,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        prefixIconColor: AppColors.primaryGold,
        suffixIconColor: AppColors.mutedGold,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.primaryGold,
        size: 24,
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.mutedGold.withValues(alpha: 0.3),
        thickness: 1,
        space: 24,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightBlack,
        selectedColor: AppColors.primaryGold,
        disabledColor: AppColors.lightBlack.withValues(alpha: 0.5),
        labelStyle: const TextStyle(
          color: AppColors.pureWhite,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        secondaryLabelStyle: const TextStyle(
          color: AppColors.primaryBlack,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.mutedGold),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryGold,
        linearTrackColor: AppColors.lightBlack,
        circularTrackColor: AppColors.lightBlack,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primaryGold,
        inactiveTrackColor: AppColors.lightBlack,
        thumbColor: AppColors.primaryGold,
        overlayColor: AppColors.primaryGold.withValues(alpha: 0.2),
        valueIndicatorColor: AppColors.primaryGold,
        valueIndicatorTextStyle: const TextStyle(
          color: AppColors.primaryBlack,
          fontWeight: FontWeight.w600,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryGold;
          }
          return AppColors.mutedGold;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryGold.withValues(alpha: 0.5);
          }
          return AppColors.lightBlack;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryGold;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.primaryBlack),
        side: const BorderSide(color: AppColors.mutedGold, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryGold;
          }
          return AppColors.mutedGold;
        }),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.lightBlack,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          color: AppColors.pureWhite,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: const TextStyle(
          color: AppColors.pureWhite,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.lightBlack,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        showDragHandle: true,
        dragHandleColor: AppColors.mutedGold,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightBlack,
        contentTextStyle: const TextStyle(
          color: AppColors.pureWhite,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.pureWhite,
          fontSize: 57,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
        ),
        displayMedium: TextStyle(
          color: AppColors.pureWhite,
          fontSize: 45,
          fontWeight: FontWeight.w400,
        ),
        displaySmall: TextStyle(
          color: AppColors.pureWhite,
          fontSize: 36,
          fontWeight: FontWeight.w400,
        ),
        headlineLarge: TextStyle(
          color: AppColors.pureWhite,
          fontSize: 32,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: AppColors.pureWhite,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: AppColors.pureWhite,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: AppColors.pureWhite,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
        titleMedium: TextStyle(
          color: AppColors.pureWhite,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
        titleSmall: TextStyle(
          color: AppColors.pureWhite,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(
          color: AppColors.pureWhite,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          color: AppColors.pureWhite,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        bodySmall: TextStyle(
          color: AppColors.mutedGold,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
        ),
        labelLarge: TextStyle(
          color: AppColors.pureWhite,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          color: AppColors.pureWhite,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          color: AppColors.mutedGold,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return lightTheme;
  }
}

extension ThemeExtensions on ThemeData {
  Color get goldAccent => AppColors.primaryGold;
  Color get darkGold => AppColors.darkGold;
  Color get lightGoldAccent => AppColors.lightGold;
  Color get blackPrimary => AppColors.primaryBlack;
  Color get blackDark => AppColors.darkBlack;
  Color get blackLight => AppColors.lightBlack;
  
  BoxDecoration get goldGradient => BoxDecoration(
    gradient: const LinearGradient(
      colors: [AppColors.primaryGold, AppColors.darkGold],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
  );
  
  BoxDecoration get darkCardDecoration => BoxDecoration(
    color: AppColors.lightBlack,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: AppColors.mutedGold.withValues(alpha: 0.2),
      width: 1,
    ),
  );
  
  BoxDecoration get goldenBorderCard => BoxDecoration(
    color: AppColors.lightBlack,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: AppColors.primaryGold,
      width: 1.5,
    ),
  );
  
  TextStyle get goldTextStyle => const TextStyle(
    color: AppColors.primaryGold,
    fontWeight: FontWeight.w600,
  );
  
  TextStyle get headingStyle => const TextStyle(
    color: AppColors.pureWhite,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
  
  TextStyle get subheadingStyle => const TextStyle(
    color: AppColors.pureWhite,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.25,
  );
  
  TextStyle get bodyTextStyle => const TextStyle(
    color: AppColors.pureWhite,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  
  TextStyle get captionStyle => const TextStyle(
    color: AppColors.mutedGold,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
  
  TextStyle get priceTextStyle => const TextStyle(
    color: AppColors.primaryGold,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );
  
  List<BoxShadow> get goldShadow => [
    BoxShadow(
      color: AppColors.primaryGold.withValues(alpha: 0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
  
  List<BoxShadow> get softShadow => [
    BoxShadow(
      color: AppColors.darkBlack.withValues(alpha: 0.5),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}