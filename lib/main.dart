import 'package:flutter/material.dart';
import 'package:gilded_stays_app/screens/home.dart'; 
import 'package:gilded_stays_app/screens/detail.dart'; 
import 'package:gilded_stays_app/utils/colors.dart'; 

void main() {
  runApp(
    GildedStaysApp(),
  );
}

class GildedStaysApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'Gilded Stays',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primaryBlack,
        accentColor: AppColors.primaryGold,
        scaffoldBackgroundColor: AppColors.secondaryBlack,
        textTheme: TextTheme(
          headline6: TextStyle(color: AppColors.textGold, fontWeight: FontWeight.bold),
          bodyText2: TextStyle(color: Colors.white),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primaryBlack,
          elevation: 0,
        ),
      ),
      home: HomeScreen(),
      routes: {
        '/detail': (context) => DetailScreen(),
      },
    );
  }
}