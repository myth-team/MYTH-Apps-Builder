import 'package:flutter/material.dart';
import 'package:shopswift_prototype_app/utils/colors.dart'; 
import 'package:shopswift_prototype_app/screens/home_screen.dart'; 
import 'package:shopswift_prototype_app/screens/product_detail_screen.dart'; 
import 'package:shopswift_prototype_app/screens/cart_screen.dart'; 
import 'package:shopswift_prototype_app/screens/profile_screen.dart'; 

void main() {
  runApp(ShopSwiftApp());
}

class ShopSwiftApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'ShopSwift',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
        ),
        fontFamily: 'Roboto',
      ),
      home: HomeScreen(),
    );
  }
}