import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:golden_stay_app/utils/colors.dart'; 
import 'package:golden_stay_app/utils/theme.dart'; 
import 'package:golden_stay_app/screens/home.dart'; 
import 'package:golden_stay_app/screens/hotel_detail.dart'; 
import 'package:golden_stay_app/screens/booking.dart'; 
import 'package:golden_stay_app/screens/search.dart'; 
import 'package:golden_stay_app/screens/profile.dart'; 
import 'package:golden_stay_app/screens/settings.dart'; 
import 'package:golden_stay_app/screens/favorites.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const GoldenStayApp());
}

class GoldenStayApp extends StatelessWidget {
  const GoldenStayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'Golden Stay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/hotel_detail': (context) => const HotelDetailScreen(),
        '/booking': (context) => const BookingScreen(),
        '/search': (context) => const SearchScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/favorites': (context) => const FavoritesScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/hotel_detail':
            final hotel = settings.arguments;
            return MaterialPageRoute(
              builder: (context) => HotelDetailScreen(hotel: hotel),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            );
        }
      },
    );
  }
}