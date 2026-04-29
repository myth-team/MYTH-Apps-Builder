import 'package:flutter/material.dart';
import 'package:shopify_pro_app/utils/colors.dart'; 
import 'package:shopify_pro_app/screens/splash_screen.dart'; 
import 'package:shopify_pro_app/screens/home_screen.dart'; 
import 'package:shopify_pro_app/screens/product_detail_screen.dart'; 
import 'package:shopify_pro_app/screens/cart_screen.dart'; 
import 'package:shopify_pro_app/screens/profile_screen.dart'; 
import 'package:shopify_pro_app/screens/categories_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'Shopify Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.background,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}