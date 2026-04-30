import 'package:flutter/material.dart';
import 'package:gilded_stays_app/utils/colors.dart'; 
import 'package:gilded_stays_app/screens/home_screen.dart'; 

void main() {
  runApp(const GildedStaysApp());
}

class GildedStaysApp extends StatelessWidget {
  const GildedStaysApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'Gilded Stays',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.gold,
        scaffoldBackgroundColor: AppColors.black,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.gold,
          secondary: AppColors.goldLight,
          surface: AppColors.surface,
        ),
        fontFamily: 'Poppins',
      ),
      home: const HomeScreen(),
    );
  }
}