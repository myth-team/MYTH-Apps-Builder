import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:new_project_app/theme/app_theme.dart';
import 'package:new_project_app/screens/home.dart'; 
import 'package:new_project_app/screens/detail.dart'; 
import 'package:new_project_app/screens/booking.dart'; 
import 'package:new_project_app/screens/my_bookings.dart'; 
import 'package:new_project_app/models/booking.dart'; 

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: const NewProjectApp(),
    ),
  );
}

class NewProjectApp extends StatelessWidget {
  const NewProjectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'new_project_app',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => const HomeScreen(),
            );
          case '/detail':
            final hotel = settings.arguments;
            return MaterialPageRoute(
              builder: (_) => DetailScreen(hotel: hotel),
            );
          case '/booking':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => BookingScreen(
                hotel: args['hotel'],
                room: args['room'],
              ),
            );
          case '/my-bookings':
            return MaterialPageRoute(
              builder: (_) => const MyBookingsScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => const HomeScreen(),
            );
        }
      },
    );
  }
}