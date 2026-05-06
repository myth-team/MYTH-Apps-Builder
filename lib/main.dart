import 'package:flutter/material.dart';
import 'package:styleme_salon_app/utils/colors.dart'; 
import 'package:styleme_salon_app/screens/home.dart'; 
import 'package:styleme_salon_app/screens/services.dart'; 
import 'package:styleme_salon_app/screens/stylists.dart'; 
import 'package:styleme_salon_app/screens/booking.dart'; 
import 'package:styleme_salon_app/screens/my_appointments.dart'; 

void main() {
  runApp(const StyleMeApp());
}

class StyleMeApp extends StatelessWidget {
  const StyleMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'StyleMe Salon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
        appBarTheme: const AppBarThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: AppColors.cardBg,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: AppColors.primary),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: AppColors.textOnPrimary,
          unselectedLabelColor: AppColors.textOnPrimary,
          indicatorColor: AppColors.accent,
        ),
      ),
      home: const HomeScreen(),
      routes: {
        '/services': (context) => const ServicesScreen(),
        '/stylists': (context) => const StylistsScreen(),
        '/booking': (context) => const BookingScreen(),
        '/my_appointments': (context) => const MyAppointmentsScreen(),
      },
    );
  }
}