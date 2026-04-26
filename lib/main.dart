import 'package:flutter/material.dart';
import 'package:taste_explorer_app/utils/colors.dart'; 
import 'package:taste_explorer_app/screens/welcome_screen.dart'; 

void main() {
  runApp(TasteExplorerApp());
}

class TasteExplorerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'Taste Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
      ),
      home: WelcomeScreen(),
      routes: {
        '/home': (context) => Scaffold(
          body: Center(
            child: Text(
              'Home Screen',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
      },
    );
  }
}