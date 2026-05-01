import 'package:flutter/material.dart';
import 'package:ride_swift_app/utils/colors.dart'; 
import 'package:ride_swift_app/screens/auth.dart'; 
import 'package:ride_swift_app/screens/rider_home.dart'; 
import 'package:ride_swift_app/screens/ride_tracking.dart'; 
import 'package:ride_swift_app/screens/driver_home.dart'; 
import 'package:ride_swift_app/screens/trip_requests.dart'; 
import 'package:ride_swift_app/screens/payment_history.dart'; 

void main() => runApp(const RideSwiftApp());

class RideSwiftApp extends StatelessWidget {
  const RideSwiftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'RideSwift',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: const AuthScreen(),
      routes: {
        '/auth': (_) => const AuthScreen(),
        '/rider_home': (_) => const RiderHomeScreen(),
        '/ride_tracking': (_) => const RideTrackingScreen(),
        '/driver_home': (_) => const DriverHomeScreen(),
        '/trip_requests': (_) => const TripRequestsScreen(),
        '/payment_history': (_) => const PaymentHistoryPage(),
      },
    );
  }
}