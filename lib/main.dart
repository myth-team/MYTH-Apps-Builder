import 'package:flutter/material.dart';
import 'package:elite_eats_app/utils/colors.dart'; 
import 'package:elite_eats_app/screens/splash.dart'; 
import 'package:elite_eats_app/screens/welcome.dart'; 
import 'package:elite_eats_app/screens/home.dart'; 
import 'package:elite_eats_app/screens/detail.dart'; 
import 'package:elite_eats_app/screens/cart.dart'; 
import 'package:elite_eats_app/screens/profile.dart'; 

void main() {
  runApp(const EliteEatsApp());
}

class EliteEatsApp extends StatelessWidget {
  const EliteEatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'Elite Eats',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/welcome': (_) => const WelcomeScreen(),
        '/home': (_) => const HomeScreen(),
        '/detail': (context) => DetailScreen(
          arguments: ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {},
        ),
        '/cart': (_) => const CartScreen(),
      },
    );
  }
}