import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_3_banking_forked_app/utils/colors.dart'; 
import 'package:web_3_banking_forked_app/screens/onboarding/welcome_screen.dart'; 
import 'package:web_3_banking_forked_app/screens/onboarding/auth_screen.dart'; 
import 'package:web_3_banking_forked_app/screens/onboarding/wallet_created_screen.dart'; 
import 'package:web_3_banking_forked_app/screens/main_navigation.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'Web3 Neobank',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.interTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
      ),
      home: WelcomeScreen(),
    );
  }
}