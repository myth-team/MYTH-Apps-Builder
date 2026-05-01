import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridesync_app/utils/colors.dart'; 
import 'package:ridesync_app/widgets/map_display.dart'; 
import 'package:ridesync_app/widgets/primary_button.dart'; 

class RiderHomeScreen extends StatefulWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onPaymentTap;
  final VoidCallback onHistoryTap;
  final Function(String) onDestinationSelected;

  const RiderHomeScreen({
    super.key,
    required this.onSearchTap,
    required this.onPaymentTap,
    required this.onHistoryTap,
    required this.onDestinationSelected,
  });

  @override
  State<RiderHomeScreen> createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Set<Marker> _markers = {};
  late AnimationController _bottomSheetController;
  late Animation<double> _bottomSheetAnimation;
  bool _showSearchBar = true;
  bool _isLoadingLocation = false;
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
    _initializeAnimations();
    _getCurrentLocation();
  }

  void _initializeMarkers() {
    _markers = {
      MapMarkerHelper.createRiderMarker(
        position: const LatLng(37.7749, -122.4194),
        title: 'Your Location',
      ),
      MapMarkerHelper.createDriverMarker(
        position: const LatLng(37.7755, -122.4180),
        title: 'Nearby Driver',
        snippet: '2 min away',
      ),
      MapMarkerHelper.createDriverMarker(
        position: const LatLng(37.7735, -122.4210),
        title: 'Nearby Driver',
        snippet: '3 min away',
      ),
      MapMarkerHelper.createDriverMarker(
        position: const LatLng(37.7760, -122.4220),
        title: 'Nearby Driver',
        snippet: '4 min away',
      ),
    };
  }

  void _initializeAnimations() {
    _bottomSheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _bottomSheetAnimation = CurvedAnimation(
      parent: _bottomSheetController,
      curve: Curves.easeInOut,
    );

    _bottomSheetController.forward();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() {
        _currentLocation = const LatLng(37.7749, -122.4194);
        _isLoadingLocation = false;
        _updateRiderMarker();
      });
    }
  }

  void _updateRiderMarker() {
    if (_currentLocation != null) {
      _markers = {
        ..._markers.where((m) => m.markerId.value != 'rider'),
        MapMarkerHelper.createRiderMarker(
          position: _currentLocation!,
          title: 'Your Location',
        ),
      };
    }
  }

  @override
  void dispose() {
    _bottomSheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          _buildMap(),
          _buildStatusIndicator(),
          _buildSearchBar(),
          _buildMenuButton(),
          _buildBottomSheet(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return MapDisplay(
      initialPosition: _currentLocation ?? const LatLng(37.7749, -122.4194),
      markers: _markers,
      showMyLocation: true,
      enableMyLocationButton: false,
      onMapCreated: (controller) {
        if (_currentLocation != null) {
          controller.animateCamera(
            CameraUpdate.newLatLngZoom(_currentLocation!, 15),
          );
        }
      },
    );
  }

  Widget _buildStatusIndicator() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      right: 16,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey300.withAlpha(77),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: _isLoadingLocation ? AppColors.warning : AppColors.success,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _isLoadingLocation ? 'Locating...' : 'Online',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 60,
      right: 60,
      child: GestureDetector(
        onTap: widget.onSearchTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey300.withAlpha(77),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Where to?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.home,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      child: GestureDetector(
        onTap: () => _scaffoldKey.currentState?.openDrawer(),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.grey300.withAlpha(77),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.menu,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return AnimatedBuilder(
      animation: _bottomSheetAnimation,
      builder: (context, child) {
        return Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Transform.translate(
            offset: Offset(0, 100 * (1 - _bottomSheetAnimation.value)),
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey300.withAlpha(77),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(),
            _buildQuickActions(),
            _buildRecentRides(),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.grey300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.home,
                  label: 'Home',
                  color: AppColors.primary,
                  onTap: () => widget.onDestinationSelected('Home'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.work,
                  label: 'Work',
                  color: AppColors.secondary,
                  onTap: () => widget.onDestinationSelected('Work'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.shopping_bag,
                  label: 'Shopping',
                  color: AppColors.accent,
                  onTap: () => widget.onDestinationSelected('Shopping'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withAlpha(26),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withAlpha(51)),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentRides() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Rides',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: widget.onHistoryTap,
                child: Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildRecentRideItem(
            location: '123 Main Street',
            destination: 'Downtown Mall',
            price: '\$12.50',
            date: 'Today',
          ),
          const SizedBox(height: 12),
          _buildRecentRideItem(
            location: 'Airport Terminal 2',
            destination: 'City Center Hotel',
            price: '\$45.00',
            date: 'Yesterday',
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRecentRideItem({
    required String location,
    required String destination,
    required String price,
    required String date,
  }) {
    return GestureDetector(
      onTap: widget.onHistoryTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.history,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$location • $date',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 16,
        top: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.borderLight),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: Icons.home,
            label: 'Home',
            isSelected: true,
            onTap: () {},
          ),
          _buildNavItem(
            icon: Icons.payment,
            label: 'Payment',
            isSelected: false,
            onTap: widget.onPaymentTap,
          ),
          _buildNavItem(
            icon: Icons.history,
            label: 'History',
            isSelected: false,
            onTap: widget.onHistoryTap,
          ),
          _buildNavItem(
            icon: Icons.person,
            label: 'Profile',
            isSelected: false,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected ? AppColors.primary : AppColors.grey500,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppColors.primary : AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedBuilder extends AnimatedWidget {
  final Widget? child;
  final Widget Function(BuildContext context, Widget? child) builder;

  const AnimatedBuilder({
    super.key,
    required super.listenable,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}