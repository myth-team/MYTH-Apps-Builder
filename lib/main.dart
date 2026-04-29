import 'package:flutter/material.dart';
import 'package:tictac_vision_app/screens/game_screen.dart'; 

void main() {
  runApp(TicTacVisionApp());
}

class TicTacVisionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'TicTac Vision',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF0A0E1F),
        fontFamily: 'Roboto',
      ),
      home: GameScreen(),
    );
  }
}