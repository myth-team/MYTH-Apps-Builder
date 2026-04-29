import 'package:flutter/material.dart';
import 'package:meme_stream_app/utils/colors.dart'; 
import 'package:meme_stream_app/screens/meme_screen.dart'; 

void main() {
  runApp(const MemeStreamApp());
}

class MemeStreamApp extends StatelessWidget {
  const MemeStreamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'MemeStream',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
      ),
      home: const MemeScreen(),
    );
  }
}