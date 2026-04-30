import 'package:flutter/material.dart';
import 'package:authflow_pro_app/screens/login.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'AuthFlow Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: LoginScreen(),
    );
  }
}