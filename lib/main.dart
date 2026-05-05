import 'package:flutter/material.dart';
import 'package:scan_fit_app/utils/colors.dart'; 
import 'package:scan_fit_app/screens/home.dart'; 
import 'package:scan_fit_app/screens/day_detail.dart'; 
import 'package:scan_fit_app/screens/profile.dart'; 

void main() {
  runApp(ScanFitApp());
}

class ScanFitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'ScanFit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
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
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => SplashScreen(),
        '/welcome': (_) => WelcomeScreen(),
        '/': (_) => HomeScreen(),
        '/day_detail': (_) => _DayDetailRoute(),
        '/profile': (_) => ProfileScreen(),
      },
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