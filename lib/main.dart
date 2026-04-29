import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:duel_duo_app/screens/home_screen.dart'; 
import 'package:duel_duo_app/utils/colors.dart'; 

void main() {
  runApp(
    ProviderScope(
      child: DuelDuoApp(),
    ),
  );
}

class DuelDuoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'Duel Duo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          background: AppColors.background,
        ),
        fontFamily: 'Poppins',
      ),
      home: HomeScreen(),
    );
  }
}