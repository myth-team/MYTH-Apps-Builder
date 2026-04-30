import 'package:flutter/material.dart';
import 'package:ridelink_app/utils/colors.dart'; 
import 'package:ridelink_app/screens/welcome_screen.dart'; 
import 'package:ridelink_app/screens/home_screen.dart'; 
import 'package:ridelink_app/screens/ride_search_screen.dart'; 
import 'package:ridelink_app/screens/login_screen.dart'; 

void main() {
  runApp(const RideLinkApp());
}

class RideLinkApp extends StatelessWidget {
  const RideLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'RideLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        fontFamily: 'Poppins',
      ),
      home: const WelcomeScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/ride-search': (context) => const RideSearchScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}