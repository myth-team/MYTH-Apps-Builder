import 'package:flutter/material.dart';
import 'package:shopswift_prototype_app/utils/colors.dart'; 
import 'package:shopswift_prototype_app/screens/home_screen.dart'; 
import 'package:shopswift_prototype_app/screens/product_detail_screen.dart'; 
import 'package:shopswift_prototype_app/screens/cart_screen.dart'; 
import 'package:shopswift_prototype_app/screens/profile_screen.dart'; 

void main() {
  runApp(ShopSwiftApp());
}

class ShopSwiftApp extends StatefulWidget {
  @override
  _ShopSwiftAppState createState() => _ShopSwiftAppState();
}

class _ShopSwiftAppState extends State<ShopSwiftApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'ShopSwift',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: _isDarkMode ? AppColors.darkBackground : AppColors.background,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
        ),
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.darkBackground,
        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.darkSurface,
        ),
        fontFamily: 'Roboto',
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(onThemeToggle: _toggleTheme, isDarkMode: _isDarkMode),
    );
  }
}