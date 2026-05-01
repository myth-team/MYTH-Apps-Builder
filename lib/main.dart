import 'package:flutter/material.dart';
import 'package:ridenow_go_app/screens/home.dart'; 
import 'package:ridenow_go_app/screens/ride_request.dart'; 
import 'package:ridenow_go_app/screens/trip_active.dart'; 
import 'package:ridenow_go_app/screens/payment.dart'; 
import 'package:ridenow_go_app/screens/profile.dart'; 
import 'package:ridenow_go_app/screens/driver_rating.dart'; 
import 'package:ridenow_go_app/utils/colors.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(RideNowGoApp());
}

class RideNowGoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'RideNow Go',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          background: AppColors.background,
          error: AppColors.error,
          onPrimary: AppColors.onPrimary,
          onSecondary: AppColors.onSecondary,
          onSurface: AppColors.onSurface,
          onBackground: AppColors.onBackground,
          onError: AppColors.onError,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surface,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          iconTheme: IconThemeData(
            color: AppColors.textPrimary,
          ),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
        ),
        cardTheme: CardTheme(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        dividerTheme: DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceVariant,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.primary),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.neutral800,
          contentTextStyle: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          behavior: SnackBarBehavior.floating,
        ),
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/home': (context) => HomeScreen(),
        '/ride_request': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          return RideRequestScreen(initialRide: args is Ride ? args : null);
        },
        '/trip_active': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          return TripActiveScreen(ride: args is Ride ? args : null);
        },
        '/payment': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          return PaymentScreen(ride: args is Ride ? args : null);
        },
        '/profile': (context) => ProfileScreen(),
        '/driver_rating': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          return DriverRatingScreen(ride: args is Ride ? args : null);
        },
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => HomeScreen(),
        );
      },
    );
  }
}