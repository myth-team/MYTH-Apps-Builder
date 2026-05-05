import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scan_fit_app/utils/colors.dart'; 
import 'package:scan_fit_app/controllers/theme_controller.dart';
import 'package:scan_fit_app/screens/home.dart'; 
import 'package:scan_fit_app/screens/day_detail.dart'; 
import 'package:scan_fit_app/screens/profile.dart'; 
import 'package:scan_fit_app/screens/splash.dart'; 
import 'package:scan_fit_app/screens/welcome.dart'; 
import 'package:scan_fit_app/screens/history.dart'; 

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: ScanFitApp(),
    ),
  );
}

class ScanFitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, theme, _) => MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
        title: 'ScanFit',
        debugShowCheckedModeBanner: false,
        themeMode: theme.themeMode,
        theme: _buildLightTheme(),
        darkTheme: _buildDarkTheme(),
        initialRoute: '/splash',
        routes: {
          '/splash': (_) => SplashScreen(),
          '/welcome': (_) => WelcomeScreen(),
          '/': (_) => HomeScreen(),
          '/day_detail': (_) => _DayDetailRoute(),
          '/profile': (_) => ProfileScreen(),
          '/history': (_) => HistoryScreen(history: []),
        },
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        background: AppColors.background,
        error: AppColors.error,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: AppColors.surface,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceDark,
        background: AppColors.backgroundDark,
        error: AppColors.error,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimaryDark),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimaryDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: AppColors.surfaceDark,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondaryDark,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class _DayDetailRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {};
    return DayDetailScreen(args: args);
  }
}