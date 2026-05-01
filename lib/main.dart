import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rideflow_app/screens/rider_home.dart'; 
import 'package:rideflow_app/screens/driver_home.dart'; 
import 'package:rideflow_app/screens/ride_booking.dart'; 
import 'package:rideflow_app/screens/ride_tracking.dart'; 
import 'package:rideflow_app/screens/payment.dart'; 
import 'package:rideflow_app/utils/colors.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.surface,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const RideFlowApp());
}

/// RideFlow Application Entry Point
/// 
/// Main application widget that configures:
/// - Theme and color scheme
/// - Navigation routing
/// - Global app settings
class RideFlowApp extends StatelessWidget {
  const RideFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
      title: 'RideFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      onGenerateRoute: _onGenerateRoute,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _buildRoute(
          builder: (_) => const AppEntryPoint(),
          settings: settings,
        );
      case '/rider_home':
        return _buildRoute(
          builder: (_) => const RiderHomeScreen(),
          settings: settings,
        );
      case '/driver_home':
        return _buildRoute(
          builder: (_) => const DriverHomeScreen(),
          settings: settings,
        );
      case '/ride_booking':
        return _buildRoute(
          builder: (_) => const RideBookingScreen(),
          settings: settings,
        );
      case '/ride_tracking':
        return _buildRoute(
          builder: (_) => const RideTrackingScreen(),
          settings: settings,
        );
      case '/payment':
        return _buildRoute(
          builder: (_) => const PaymentScreen(),
          settings: settings,
        );
      default:
        return _buildRoute(
          builder: (_) => const AppEntryPoint(),
          settings: settings,
        );
    }
  }

  Route<dynamic> _buildRoute({
    required WidgetBuilder builder,
    required RouteSettings settings,
  }) {
    return MaterialPageRoute(
      builder: builder,
      settings: settings,
    );
  }
}

/// App Entry Point - Landing screen for selecting rider or driver mode
/// In production, this would be replaced with authentication flow
class AppEntryPoint extends StatelessWidget {
  const AppEntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(),
              // App Logo and Branding
              _buildLogoSection(),
              const Spacer(),
              // Mode Selection Buttons
              _buildModeSelection(context),
              const SizedBox(height: 32),
              // Version info
              _buildVersionInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        // App Icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: const Icon(
            Icons.directions_car_rounded,
            color: Colors.white,
            size: 50,
          ),
        ),
        const SizedBox(height: 24),
        // App Name
        Text(
          'RideFlow',
          style: AppTextStyles.headlineLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        // Tagline
        Text(
          'Your ride, your way',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildModeSelection(BuildContext context) {
    return Column(
      children: [
        // Rider Mode Button
        _buildModeCard(
          context: context,
          title: 'Rider',
          subtitle: 'Book rides, track your driver, and pay easily',
          icon: Icons.person_outline,
          gradient: AppColors.primaryGradient,
          onTap: () => Navigator.pushNamed(context, '/rider_home'),
        ),
        const SizedBox(height: 16),
        // Driver Mode Button
        _buildModeCard(
          context: context,
          title: 'Driver',
          subtitle: 'Accept trips, earn money, and grow your business',
          icon: Icons.drive_eta_outlined,
          gradient: AppColors.successGradient,
          onTap: () => Navigator.pushNamed(context, '/driver_home'),
        ),
      ],
    );
  }

  Widget _buildModeCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.large,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: AppRadius.large,
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: AppRadius.medium,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVersionInfo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: AppRadius.full,
          ),
          child: Text(
            'Version 1.0.0',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'By continuing, you agree to our Terms of Service and Privacy Policy',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textTertiary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}