import 'package:flutter/material.dart';
import 'package:hsq_towers_app/screens/home_screen.dart'; 
import 'package:hsq_towers_app/utils/colors.dart'; 

void main() {
  runApp(HsqTowersApp());
}

class HsqTowersApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'HSQ Towers',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
      ),
      home: HomeScreen(),
    );
  }
}