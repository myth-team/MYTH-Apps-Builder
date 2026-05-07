import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylebook_salon_app/providers/app_state.dart';
import 'package:stylebook_salon_app/screens/home.dart'; 
import 'package:stylebook_salon_app/screens/stylist_detail.dart'; 
import 'package:stylebook_salon_app/screens/booking_flow.dart'; 
import 'package:stylebook_salon_app/screens/bookings.dart'; 
import 'package:stylebook_salon_app/screens/explore.dart'; 
import 'package:stylebook_salon_app/screens/profile.dart'; 
import 'package:stylebook_salon_app/screens/settings.dart'; 
import 'package:stylebook_salon_app/utils/colors.dart'; 

void main() {
  runApp(const StyleBookApp());
}

class StyleBookApp extends StatelessWidget {
  const StyleBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..init(),
      child: Consumer<AppState>(
        builder: (context, appState, _) => MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
          title: 'StyleBook',
          debugShowCheckedModeBanner: false,
          theme: _buildTheme(appState.isDarkMode),
          home: const _Shell(),
          routes: {
            '/home': (_) => const _Shell(),
            '/stylist_detail': (_) => const StylistDetailScreen(),
            '/booking_flow': (_) => const BookingFlowScreen(),
            '/bookings': (_) => const BookingsScreen(),
            '/explore': (_) => const ExploreScreen(),
            '/profile': (_) => const ProfileScreen(),
            '/settings': (_) => const SettingsScreen(),
          },
        ),
      ),
    );
  }

  ThemeData _buildTheme(bool isDark) {
    final base = isDark ? ThemeData.dark() : ThemeData.light();
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      scaffoldBackgroundColor: isDark ? const Color(0xFF121212) : AppColors.background,
      appBarTheme: AppBarThemeData(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : AppColors.surface,
        foregroundColor: isDark ? Colors.white : AppColors.textPrimary,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: isDark ? Colors.white54 : AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF2C2C2C) : AppColors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF2C2C2C) : AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _Shell extends StatelessWidget {
  const _Shell();

  final _screens = const [
    HomeScreen(),
    BookingsScreen(),
    ExploreScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentTab = context.watch<AppState>().currentTab;

    return Scaffold(
      body: IndexedStack(
        index: currentTab,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        onTap: (i) => context.read<AppState>().setCurrentTab(i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), activeIcon: Icon(Icons.calendar_today), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), activeIcon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}