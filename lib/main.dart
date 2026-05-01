import 'package:flutter/material.dart';
import 'package:ridesync_app/utils/colors.dart'; 
import 'package:ridesync_app/screens/splash.dart'; 
import 'package:ridesync_app/screens/auth.dart'; 
import 'package:ridesync_app/screens/role_selection.dart'; 
import 'package:ridesync_app/screens/rider_home.dart'; 
import 'package:ridesync_app/screens/rider_search.dart'; 
import 'package:ridesync_app/screens/rider_select_vehicle.dart'; 
import 'package:ridesync_app/screens/rider_tracking.dart'; 
import 'package:ridesync_app/screens/rider_payment.dart'; 
import 'package:ridesync_app/screens/rider_history.dart'; 
import 'package:ridesync_app/screens/driver_home.dart'; 
import 'package:ridesync_app/screens/driver_navigation.dart'; 
import 'package:ridesync_app/screens/driver_earnings.dart'; 
import 'package:ridesync_app/screens/driver_profile.dart'; 
import 'package:ridesync_app/widgets/vehicle_card.dart'; 

void main() {
  runApp(const RideSyncApp());
}

class RideSyncApp extends StatelessWidget {
  const RideSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'RideSync',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: AppThemeColors.lightColorScheme(),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        cardTheme: CardTheme(
          color: AppColors.cardBackground,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppColors.bottomSheetBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: AppColors.dialogBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.grey900,
          contentTextStyle: TextStyle(color: Colors.white),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: AppNavigator(),
    );
  }
}

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  bool _isAuthenticated = false;
  bool _isRider = true;

  void _onSplashComplete() {
    if (_isAuthenticated) {
      if (_isRider) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RiderHomeScreen(
            onSearchTap: () => Navigator.pushNamed(context, '/rider_search'),
            onPaymentTap: () => Navigator.pushNamed(context, '/rider_payment'),
            onHistoryTap: () => Navigator.pushNamed(context, '/rider_history'),
            onDestinationSelected: (destination) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => RiderSelectVehicleScreen(
                  pickupLocation: 'Current Location',
                  dropoffLocation: destination,
                  distance: 3.2,
                  durationMinutes: 12,
                  onVehicleSelected: (type) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RiderTrackingScreen(
                        driverName: 'John D.',
                        driverRating: '4.9',
                        vehicleInfo: 'Toyota Camry',
                        licensePlate: 'ABC 1234',
                        pickupLocation: 'Current Location',
                        dropoffLocation: destination,
                        etaMinutes: 5,
                        distanceKm: 3.2,
                        onContactDriver: (method) {},
                        onCancelTrip: () => Navigator.pop(context),
                        onTripCompleted: () => Navigator.pushNamed(context, '/rider_payment'),
                      )),
                    );
                  },
                  onCancel: () => Navigator.pop(context),
                )),
              );
            },
          )),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DriverHome()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthScreen(
          onLoginSuccess: () {
            setState(() => _isAuthenticated = true);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RoleSelectionScreen(
                onRoleSelected: (isRider) {
                  setState(() => _isRider = isRider);
                  if (isRider) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RiderHomeScreen(
                        onSearchTap: () => Navigator.pushNamed(context, '/rider_search'),
                        onPaymentTap: () => Navigator.pushNamed(context, '/rider_payment'),
                        onHistoryTap: () => Navigator.pushNamed(context, '/rider_history'),
                        onDestinationSelected: (destination) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => RiderSelectVehicleScreen(
                              pickupLocation: 'Current Location',
                              dropoffLocation: destination,
                              distance: 3.2,
                              durationMinutes: 12,
                              onVehicleSelected: (type) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => RiderTrackingScreen(
                                    driverName: 'John D.',
                                    driverRating: '4.9',
                                    vehicleInfo: 'Toyota Camry',
                                    licensePlate: 'ABC 1234',
                                    pickupLocation: 'Current Location',
                                    dropoffLocation: destination,
                                    etaMinutes: 5,
                                    distanceKm: 3.2,
                                    onContactDriver: (method) {},
                                    onCancelTrip: () => Navigator.pop(context),
                                    onTripCompleted: () => Navigator.pushNamed(context, '/rider_payment'),
                                  )),
                                );
                              },
                              onCancel: () => Navigator.pop(context),
                            )),
                          );
                        },
                      )),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const DriverHome()),
                    );
                  }
                },
              )),
            );
          },
          onSkipToRoleSelection: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RoleSelectionScreen(
                onRoleSelected: (isRider) {
                  setState(() => _isRider = isRider);
                  if (isRider) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RiderHomeScreen(
                        onSearchTap: () => Navigator.pushNamed(context, '/rider_search'),
                        onPaymentTap: () => Navigator.pushNamed(context, '/rider_payment'),
                        onHistoryTap: () => Navigator.pushNamed(context, '/rider_history'),
                        onDestinationSelected: (destination) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => RiderSelectVehicleScreen(
                              pickupLocation: 'Current Location',
                              dropoffLocation: destination,
                              distance: 3.2,
                              durationMinutes: 12,
                              onVehicleSelected: (type) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => RiderTrackingScreen(
                                    driverName: 'John D.',
                                    driverRating: '4.9',
                                    vehicleInfo: 'Toyota Camry',
                                    licensePlate: 'ABC 1234',
                                    pickupLocation: 'Current Location',
                                    dropoffLocation: destination,
                                    etaMinutes: 5,
                                    distanceKm: 3.2,
                                    onContactDriver: (method) {},
                                    onCancelTrip: () => Navigator.pop(context),
                                    onTripCompleted: () => Navigator.pushNamed(context, '/rider_payment'),
                                  )),
                                );
                              },
                              onCancel: () => Navigator.pop(context),
                            )),
                          );
                        },
                      )),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const DriverHome()),
                    );
                  }
                },
              )),
            );
          },
        )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      onComplete: _onSplashComplete,
      isAuthenticated: _isAuthenticated,
    );
  }
}

class AppRoutes {
  static const String splash = '/';
  static const String auth = '/auth';
  static const String roleSelection = '/role_selection';
  static const String riderHome = '/rider_home';
  static const String riderSearch = '/rider_search';
  static const String riderSelectVehicle = '/rider_select_vehicle';
  static const String riderTracking = '/rider_tracking';
  static const String riderPayment = '/rider_payment';
  static const String riderHistory = '/rider_history';
  static const String driverHome = '/driver_home';
  static const String driverNavigation = '/driver_navigation';
  static const String driverEarnings = '/driver_earnings';
  static const String driverProfile = '/driver_profile';
}