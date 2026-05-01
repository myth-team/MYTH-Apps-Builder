import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project_app/utils/colors.dart'; 
import 'package:new_project_app/screens/home.dart'; 
import 'package:new_project_app/screens/driver_selection.dart'; 
import 'package:new_project_app/screens/active_ride.dart'; 
import 'package:new_project_app/screens/ride_history.dart'; 
import 'package:new_project_app/screens/profile.dart'; 

void main() {
  runApp(const NewProjectApp());
}

class NewProjectApp extends StatelessWidget {
  const NewProjectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'Ride App',
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
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/driver_selection': (context) => const DriverSelectionScreen(),
        '/active_ride': (context) => const ActiveRideScreen(),
        '/ride_history': (context) => const RideHistoryScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}