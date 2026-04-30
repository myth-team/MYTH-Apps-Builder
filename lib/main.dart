import 'package:flutter/material.dart';
import 'package:simple_counter_app/screens/home.dart'; 
import 'package:simple_counter_app/utils/colors.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'Simple Counter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        fontFamily: 'Roboto',
      ),
      home: HomeScreen(),
      routes: {
        '/': (context) => HomeScreen(),
      },
    );
  }
}