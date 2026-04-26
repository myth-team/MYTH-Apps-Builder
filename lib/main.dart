import 'package:flutter/material.dart';
import 'package:secure_entry_app/utils/colors.dart'; 
import 'package:secure_entry_app/screens/login_screen.dart'; 

void main() {
  runApp(const SecureEntryApp());
}

class SecureEntryApp extends StatelessWidget {
  const SecureEntryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'Secure Entry App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}