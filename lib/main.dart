import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:golden_stay_app/utils/colors.dart'; 
import 'package:golden_stay_app/utils/theme.dart'; 
import 'package:golden_stay_app/screens/home.dart'; 
import 'package:golden_stay_app/screens/explore.dart'; 
import 'package:golden_stay_app/screens/detail.dart'; 
import 'package:golden_stay_app/screens/booking.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style for the golden black theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const GoldenStayApp());
}

class GoldenStayApp extends StatelessWidget {
  const GoldenStayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'Golden Stay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => const HomeScreen(),
              settings: settings,
            );
          case '/explore':
            return MaterialPageRoute(
              builder: (_) => const ExploreScreen(),
              settings: settings,
            );
          case '/detail':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (_) => DetailScreen(
                hotelId: args?['hotelId'] as String?,
                hotel: args?['hotel'],
              ),
              settings: settings,
            );
          case '/booking':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (_) => BookingScreen(
                hotel: args?['hotel'],
                selectedRoom: args?['selectedRoom'],
                checkInDate: args?['checkInDate'],
                checkOutDate: args?['checkOutDate'],
                guests: args?['guests'] ?? 1,
                rooms: args?['rooms'] ?? 1,
              ),
              settings: settings,
            );
          default:
            return MaterialPageRoute(
              builder: (_) => const HomeScreen(),
              settings: settings,
            );
        }
      },
    );
  }
}