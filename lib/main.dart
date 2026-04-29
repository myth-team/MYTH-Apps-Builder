import 'package:flutter/material.dart';
import 'package:tap_counter_app/utils/colors.dart'; 
import 'package:tap_counter_app/screens/counter_screen.dart'; 

void main() {
  runApp(const TapCounterApp());
}

class TapCounterApp extends StatelessWidget {
  const TapCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'Tap Countd',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          surface: AppColors.surface,
        ),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),
      home: const CounterScreen(),
    );
  }
}