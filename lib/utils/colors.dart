import 'package:flutter/material.dart';

class AppColors {
  static Color primaryColor = Color(0xFF6200EE);
  static Color secondaryColor = Color(0xFF03DAC6);
  static Color backgroundColor = Color(0xFFF5F5F5);
  static Color cardColor = Colors.white;
  static Color textPrimary = Color(0xFF212121);
  static Color textSecondary = Color(0xFF757575);
  static Color incrementColor = Color(0xFF4CAF50);
  static Color decrementColor = Color(0xFFF44336);
  static Color resetColor = Color(0xFFFF9800);
  static Color counterPositive = Color(0xFF2E7D32);
  static Color counterNegative = Color(0xFFC62828);
  static Color counterNeutral = Color(0xFF424242);
  
  static ColorScheme get colorScheme => ColorScheme(
    primary: primaryColor,
    secondary: secondaryColor,
    surface: cardColor,
    error: decrementColor,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: textPrimary,
    onError: Colors.white,
    brightness: Brightness.light,
  );
  
  static ThemeData get themeData => ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
  
  static Map<String, Color> get colorMap => {
    'primary': primaryColor,
    'secondary': secondaryColor,
    'background': backgroundColor,
    'card': cardColor,
    'textPrimary': textPrimary,
    'textSecondary': textSecondary,
    'increment': incrementColor,
    'decrement': decrementColor,
    'reset': resetColor,
    'counterPositive': counterPositive,
    'counterNegative': counterNegative,
    'counterNeutral': counterNeutral,
  };
  
  static Color getCounterColor(int value) {
    if (value > 0) return counterPositive;
    if (value < 0) return counterNegative;
    return counterNeutral;
  }
  
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
  
  static LinearGradient get primaryGradient => LinearGradient(
    colors: [
      primaryColor,
      primaryColor.withOpacity(0.8),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static BoxDecoration get containerDecoration => BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [...cardShadow],
  );
  
  static TextStyle get headingStyle => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  
  static TextStyle get bodyStyle => TextStyle(
    fontSize: 16,
    color: textPrimary,
  );
  
  static TextStyle get captionStyle => TextStyle(
    fontSize: 14,
    color: textSecondary,
  );
  
  static TextStyle counterTextStyle(int value) => TextStyle(
    fontSize: 72,
    fontWeight: FontWeight.bold,
    color: getCounterColor(value),
  );
}