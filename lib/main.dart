import 'package:flutter/material.dart';
import 'package:secure_sign_app/utils/colors.dart'; 
import 'package:secure_sign_app/screens/login_page.dart'; 

void main() {
  runApp(const SecureSignApp());
}

class SecureSignApp extends StatelessWidget {
  const SecureSignApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'SecureSign',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Poppins',
      ),
      home: const LoginPage(),
    );
  }
}