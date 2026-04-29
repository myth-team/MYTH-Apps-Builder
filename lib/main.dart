import 'package:flutter/material.dart';
import 'package:zee_luxury_jewels_app/screens/splash_screen.dart'; 

void main() {
  runApp(ZeeLuxuryApp());
}

class ZeeLuxuryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'Zee Luxury',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Color(0xFF0A0A0A),
        fontFamily: 'PlayfairDisplay',
      ),
      home: SplashScreen(),
    );
  }
}