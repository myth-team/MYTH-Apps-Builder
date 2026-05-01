import 'package:flutter/material.dart';
import 'package:rideflow_app/theme/app_theme.dart';
import 'package:rideflow_app/screens/auth.dart'; 
import 'package:rideflow_app/screens/rider_home.dart'; 
import 'package:rideflow_app/screens/rider_booking.dart'; 
import 'package:rideflow_app/screens/rider_tracking.dart'; 
import 'package:rideflow_app/screens/rider_payment.dart'; 
import 'package:rideflow_app/screens/driver_home.dart'; 
import 'package:rideflow_app/screens/driver_navigation.dart'; 
import 'package:rideflow_app/screens/driver_earnings.dart'; 

void main() {
  runApp(const RideFlowApp());
}

class RideFlowApp extends StatelessWidget {
  const RideFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'RideFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/auth',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/auth':
            return MaterialPageRoute(
              builder: (_) => const AuthScreen(),
              settings: settings,
            );
          case '/rider_home':
            return MaterialPageRoute(
              builder: (_) => const RiderHomeScreen(),
              settings: settings,
            );
          case '/rider_booking':
            return MaterialPageRoute(
              builder: (_) => const RiderBookingScreen(),
              settings: settings,
            );
          case '/rider_tracking':
            return MaterialPageRoute(
              builder: (_) => const RiderTrackingScreen(),
              settings: settings,
            );
          case '/rider_payment':
            return MaterialPageRoute(
              builder: (_) => const RiderPaymentScreen(),
              settings: settings,
            );
          case '/driver_home':
            return MaterialPageRoute(
              builder: (_) => const DriverHomeScreen(),
              settings: settings,
            );
          case '/driver_navigation':
            return MaterialPageRoute(
              builder: (_) => const DriverNavigationScreen(),
              settings: settings,
            );
          case '/driver_earnings':
            return MaterialPageRoute(
              builder: (_) => const DriverEarningsScreen(),
              settings: settings,
            );
          default:
            return MaterialPageRoute(
              builder: (_) => const AuthScreen(),
              settings: settings,
            );
        }
      },
    );
  }
}