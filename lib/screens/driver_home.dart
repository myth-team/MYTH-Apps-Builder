import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:new_project_app/utils/colors.dart'; 
import 'package:new_project_app/widgets/ride_state_chip.dart'; 
import 'package:new_project_app/providers/auth_provider.dart';
import 'package:new_project_app/providers/ride_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Driver Home Screen
// ─────────────────────────────────────────────────────────────────────────────

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({Key? key}) : super(key: key);

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  bool _isOnline = false;
  bool _showTripRequestModal = false;
  bool _isAccepting = false;
  bool _isDeclining = false;
  Timer? _requestTimer;
  int _requestSecondsRemaining = 25;
  _IncomingTripRequest? _incomingRequest;

  late AnimationController _onlineToggleController;
  late AnimationController _modalSlideController;
  late AnimationController _pulseController;
  late AnimationController _requestTimerController;

  late Animation<double> _modalSlideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _requestTimerAnimation;

  final LatLng _driverPosition = LatLng(37.7749, -122.4194);

  Set<Marker> _markers = {};
  DriverAvailability _availability = DriverAvailability.offline;

  @override
  void initState() {
    super.initState();

    _onlineToggleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    _modalSlideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _requestTimerController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 25),
    );

    _modalSlideAnimation = CurvedAnimation(
      parent: _modalSlideController,
      curve: Curves.easeOutCubic,
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _requestTimerAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _requestTimerController, curve: Curves.linear),
    );

    _buildMarkers();

    // Simulate incoming request after 5 seconds when online
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        _setupMockRequest();
      }
    });
  }

  void _setupMockRequest() {
    _incomingRequest = _IncomingTripRequest(
      tripId: 'trip_mock_001',
      riderName: 'Sarah Johnson',
      riderAvatar: 'https://i.pravatar.cc/150?img=5',
      riderRating: 4.85,
      pickupAddress: '1 Market Street, San Francisco',
      dropoffAddress: '550 Mission Street, San Francisco',
      distance: 2.4,
      estimatedFare: 14.50,
      estimatedDuration: 12,
      pickupLocation: LatLng(37.7937, -122.3965),
      dropoffLocation: LatLng(37.7886, -122.3987),
    );
  }

  void _buildMarkers() {
    _markers = {
      Marker(
        markerId: MarkerId('driver_self'),
        position: _driverPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        infoWindow: InfoWindow(title: 'You'),
      ),
    };
  }

  void _toggleOnlineStatus(bool value) {
    setState(() {
      _isOnline = value;
      _availability =
          value ? DriverAvailability.online : DriverAvailability.offline;
    });

    if (value) {
      _onlineToggleController.forward();
      // Simulate incoming request after going online
      Future.delayed(Duration(seconds: 4), () {
        if (mounted && _isOnline && !_showTripRequestModal) {
          _triggerIncomingRequest();
        }
      });
    } else {
      _onlineToggleController.reverse();
      _dismissRequest();
    }
  }

  void _triggerIncomingRequest() {
    if (_incomingRequest == null) _setupMockRequest();
    setState(() {
      _showTripRequestModal = true;
      _requestSecondsRemaining = 25;
    });
    _modalSlideController.forward(from: 0);
    _requestTimerController.forward(from: 0);
    _startRequestCountdown();
  }

  void _startRequestCountdown() {
    _requestTimer?.cancel();
    _requestTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _requestSecondsRemaining--;
      });
      if (_requestSecondsRemaining <= 0) {
        timer.cancel();
        _dismissRequest();
      }
    });
  }

  void _acceptRequest() async {
    setState(() {
      _isAccepting = true;
    });
    _requestTimer?.cancel();

    await Future.delayed(Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _isAccepting = false;
        _availability = DriverAvailability.busy;
      });
      _dismissRequest();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: AppColors.white, size: 18),
              SizedBox(width: 10),
              Text(
                'Trip accepted! Navigate to pickup.',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(16),
        ),
      );

      Navigator.pushNamed(context, '/driver_navigation');
    }
  }

  void _declineRequest() async {
    setState(() {
      _isDeclining = true;
    });
    _requestTimer?.cancel();
    await Future.delayed(Duration(milliseconds: 400));
    if (mounted) {
      setState(() {
        _isDeclining = false;
      });
      _dismissRequest();
    }
  }

  void _dismissRequest() {
    _requestTimer?.cancel();
    _requestTimerController.stop();
    _modalSlideController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showTripRequestModal = false;
        });
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _applyDarkMapStyle(controller);
  }

  void _applyDarkMapStyle(GoogleMapController controller) {
    controller.setMapStyle('''
[
  {"elementType":"geometry","stylers":[{"color":"#1a1733"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#9089be"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#1a1733"}]},
  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#252340"}]},
  {"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#312e50"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#0f0e1a"}]},
  {"featureType":"poi","stylers":[{"visibility":"off"}]}
]
    ''');
  }

  void _centerOnDriver() {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _driverPosition, zoom: 15),
      ),
    );
  }

  @override
  void dispose() {
    _onlineToggleController.dispose();
    _modalSlideController.dispose();
    _pulseController.dispose();
    _requestTimerController.dispose();
    _requestTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          // ── Full-Screen Map ──────────────────────────────────────────────
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _driverPosition,
                zoom: 14.5,
              ),
              onMapCreated: _onMapCreated,
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
            ),
          ),

          // ── Top Gradient Overlay ─────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 200,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.darkBackground.withOpacity(0.95),
                    AppColors.darkBackground.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),

          // ── Top Bar ──────────────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: _TopBar(
                isOnline: _isOnline,
                availability: _availability,
                onToggleOnline: _toggleOnlineStatus,
                pulseAnimation: _pulseAnimation,
              ),
            ),
          ),

          // ── Right Side Controls ──────────────────────────────────────────
          Positioned(
            right: 16,
            bottom: 260,
            child: Column(
              children: [
                _MapActionButton(
                  icon: Icons.my_location_rounded,
                  onTap: _centerOnDriver,
                  tooltip: 'Center on me',
                ),
                SizedBox(height: 12),
                _MapActionButton(
                  icon: Icons.notifications_rounded,
                  onTap: () {},
                  tooltip: 'Notifications',
                  badgeCount: 2,
                ),
                SizedBox(height: 12),
                _MapActionButton(
                  icon: Icons.bar_chart_rounded,
                  onTap: () => Navigator.pushNamed(context, '/driver_earnings'),
                  tooltip: 'Earnings',
                ),
              ],
            ),
          ),

          // ── Bottom Status Panel ──────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _DriverStatusPanel(
              isOnline: _isOnline,
              availability: _availability,
              onViewEarnings: () =>
                  Navigator.pushNamed(context, '/driver_earnings'),
            ),
          ),

          // ── Incoming Trip Request Modal ───────────────────────────────────
          if (_showTripRequestModal && _incomingRequest != null)
            Positioned.fill(
              child: _TripRequestOverlay(
                request: _incomingRequest!,
                slideAnimation: _modalSlideAnimation,
                timerAnimation: _requestTimerAnimation,
                secondsRemaining: _requestSecondsRemaining,
                isAccepting: _isAccepting,
                isDeclining: _isDeclining,
                onAccept: _acceptRequest,
                onDecline: _declineRequest,
              ),
            ),

          // ── Offline Overlay Hint ─────────────────────────────────────────
          if (!_isOnline)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: IgnorePointer(
                child: Container(
                  color: AppColors.darkBackground.withOpacity(0.35),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Top Bar Widget
// ─────────────────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final bool isOnline;
  final DriverAvailability availability;
  final ValueChanged<bool> onToggleOnline;
  final Animation<double> pulseAnimation;

  const _TopBar({
    required this.isOnline,
    required this.availability,
    required this.onToggleOnline,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar
        Consumer<AuthProvider>(
          builder: (context, auth, _) {
            final name = auth.currentUser?.name ?? 'Driver';
            final avatar = auth.currentUser?.avatarUrl;
            return GestureDetector(
              onTap: () {},
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isOnline
                        ? AppColors.onlineStatus
                        : AppColors.offlineStatus,
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isOnline
                              ? AppColors.onlineStatus
                              : AppColors.offlineStatus)
                          .withOpacity(0.35),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: avatar != null
                      ? Image.network(
                          avatar,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _DefaultAvatar(name: name),
                        )
                      : _DefaultAvatar(name: name),
                ),
              ),
            );
          },
        ),

        SizedBox(width: 12),

        // Status Chip
        DriverStatusChip(
          status: availability,
          animated: true,
          compact: false,
        ),

        Spacer(),

        // Toggle Switch
        _OnlineToggle(
          isOnline: isOnline,
          onToggle: onToggleOnline,
          pulseAnimation: pulseAnimation,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Online Toggle Switch
// ─────────────────────────────────────────────────────────────────────────────

class _OnlineToggle extends StatelessWidget {
  final bool isOnline;
  final ValueChanged<bool> onToggle;
  final Animation<double> pulseAnimation;

  const _OnlineToggle({
    required this.isOnline,
    required this.onToggle,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onToggle(!isOnline),
      child: AnimatedBuilder(
        animation: pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isOnline ? pulseAnimation.value : 1.0,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: isOnline ? AppColors.tealGradient : null,
            color: isOnline ? null : AppColors.darkSurface,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: isOnline
                  ? AppColors.tertiary.withOpacity(0.5)
                  : AppColors.darkBorder,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isOnline
                    ? AppColors.tertiary.withOpacity(0.35)
                    : AppColors.shadowDark,
                blurRadius: isOnline ? 16 : 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: Icon(
                  isOnline
                      ? Icons.power_settings_new_rounded
                      : Icons.power_off_rounded,
                  key: ValueKey(isOnline),
                  color: AppColors.white,
                  size: 18,
                ),
              ),
              SizedBox(width: 8),
              Text(
                isOnline ? 'GO OFFLINE' : 'GO ONLINE',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Map Action Button
// ─────────────────────────────────────────────────────────────────────────────

class _MapActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final int badgeCount;

  const _MapActionButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.darkSurface.withOpacity(0.92),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.darkBorder,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowDark,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: AppColors.primaryLight, size: 20),
            ),
            if (badgeCount > 0)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.darkBackground, width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      badgeCount.toString(),
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Driver Status Panel (Bottom)
// ─────────────────────────────────────────────────────────────────────────────

class _DriverStatusPanel extends StatelessWidget {
  final bool isOnline;
  final DriverAvailability availability;
  final VoidCallback onViewEarnings;

  const _DriverStatusPanel({
    required this.isOnline,
    required this.availability,
    required this.onViewEarnings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        border: Border.all(
          color: AppColors.darkBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 24,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 20, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.darkBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Status row
              Row(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 400),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isOnline
                          ? AppColors.onlineStatus
                          : AppColors.offlineStatus,
                      boxShadow: isOnline
                          ? [
                              BoxShadow(
                                color: AppColors.onlineStatus.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : [],
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    isOnline
                        ? 'You are online & accepting rides'
                        : 'Go online to start accepting rides',
                    style: TextStyle(
                      color: isOnline
                          ? AppColors.darkTextPrimary
                          : AppColors.darkTextSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Stats row
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Today',
                      value: '\$84.20',
                      icon: Icons.attach_money_rounded,
                      color: AppColors.tertiary,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Trips',
                      value: '6',
                      icon: Icons.directions_car_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Rating',
                      value: '4.92',
                      icon: Icons.star_rounded,
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Earnings button
              GestureDetector(
                onTap: onViewEarnings,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.35),
                        blurRadius: 14,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bar_chart_rounded,
                        color: AppColors.white,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'View Earnings Dashboard',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stat Card
// ─────────────────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.18), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: AppColors.darkTextPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: AppColors.darkTextSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Trip Request Overlay
// ─────────────────────────────────────────────────────────────────────────────

class _TripRequestOverlay extends StatelessWidget {
  final _IncomingTripRequest request;
  final Animation<double> slideAnimation;
  final Animation<double> timerAnimation;
  final int secondsRemaining;
  final bool isAccepting;
  final bool isDeclining;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _TripRequestOverlay({
    required this.request,
    required this.slideAnimation,
    required this.timerAnimation,
    required this.secondsRemaining,
    required this.isAccepting,
    required this.isDeclining,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Scrim
        GestureDetector(
          onTap: () {},
          child: Container(
            color: AppColors.scrim.withOpacity(0.5),
          ),
        ),

        // Modal
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, 1),
              end: Offset(0, 0),
            ).animate(slideAnimation),
            child: _TripRequestModal(
              request: request,
              timerAnimation: timerAnimation,
              secondsRemaining: secondsRemaining,
              isAccepting: isAccepting,
              isDeclining: isDeclining,
              onAccept: onAccept,
              onDecline: onDecline,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Trip Request Modal
// ─────────────────────────────────────────────────────────────────────────────

class _TripRequestModal extends StatelessWidget {
  final _IncomingTripRequest request;
  final Animation<double> timerAnimation;
  final int secondsRemaining;
  final bool isAccepting;
  final bool isDeclining;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _TripRequestModal({
    required this.request,
    required this.timerAnimation,
    required this.secondsRemaining,
    required this.isAccepting,
    required this.isDeclining,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 30,
            offset: Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.darkBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Header row
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: AppColors.secondaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.flash_on_rounded,
                            color: AppColors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'NEW TRIP REQUEST',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  // Timer
                  _CountdownTimer(
                    animation: timerAnimation,
                    secondsRemaining: secondsRemaining,
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Timer progress bar
              AnimatedBuilder(
                animation: timerAnimation,
                builder: (context, _) {
                  final double progress = timerAnimation.value;
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: AppColors.darkBorder,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress > 0.4
                            ? AppColors.primary
                            : progress > 0.2
                                ? AppColors.warning
                                : AppColors.error,
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 20),

              // Rider info
              _RiderInfoRow(request: request),

              SizedBox(height: 20),

              // Route info
              _RouteInfo(request: request),

              SizedBox(height: 20),

              // Fare & distance
              _FareDistanceRow(request: request),

              SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  // Decline
                  Expanded(
                    flex: 4,
                    child: GestureDetector(
                      onTap: isDeclining || isAccepting ? null : onDecline,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.darkSurfaceElevated,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.error.withOpacity(0.35),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: isDeclining
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.error),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.close_rounded,
                                      color: AppColors.error,
                                      size: 18,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Decline',
                                      style: TextStyle(
                                        color: AppColors.error,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 14),

                  // Accept
                  Expanded(
                    flex: 6,
                    child: GestureDetector(
                      onTap: isDeclining || isAccepting ? null : onAccept,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: isAccepting ? null : AppColors.tealGradient,
                          color: isAccepting ? AppColors.darkBorder : null,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: isAccepting
                              ? []
                              : [
                                  BoxShadow(
                                    color:
                                        AppColors.tertiary.withOpacity(0.4),
                                    blurRadius: 16,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                        ),
                        child: Center(
                          child: isAccepting
                              ? SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.white),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_rounded,
                                      color: AppColors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Accept Ride',
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.4,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Countdown Timer Circle
// ─────────────────────────────────────────────────────────────────────────────

class _CountdownTimer extends StatelessWidget {
  final Animation<double> animation;
  final int secondsRemaining;

  const _CountdownTimer({
    required this.animation,
    required this.secondsRemaining,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final double progress = animation.value;
        final Color timerColor = progress > 0.4
            ? AppColors.primary
            : progress > 0.2
                ? AppColors.warning
                : AppColors.error;

        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 52,
              height: 52,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 3,
                backgroundColor: AppColors.darkBorder,
                valueColor: AlwaysStoppedAnimation<Color>(timerColor),
              ),
            ),
            Text(
              '$secondsRemaining',
              style: TextStyle(
                color: timerColor,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Rider Info Row
// ─────────────────────────────────────────────────────────────────────────────

class _RiderInfoRow extends StatelessWidget {
  final _IncomingTripRequest request;

  const _RiderInfoRow({required this.request});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 2),
          ),
          child: ClipOval(
            child: Image.network(
              request.riderAvatar,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _DefaultAvatar(name: request.riderName),
            ),
          ),
        ),
        SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                request.riderName,
                style: TextStyle(
                  color: AppColors.darkTextPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.star_rounded, color: AppColors.starActive, size: 14),
                  SizedBox(width: 3),
                  Text(
                    request.riderRating.toStringAsFixed(2),
                    style: TextStyle(
                      color: AppColors.darkTextSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 3,
                    height: 3,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.darkTextSecondary,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.access_time_rounded,
                      color: AppColors.darkTextSecondary, size: 12),
                  SizedBox(width: 3),
                  Text(
                    '${request.estimatedDuration} min trip',
                    style: TextStyle(
                      color: AppColors.darkTextSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.phone_rounded, color: AppColors.primary, size: 18),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Route Info
// ─────────────────────────────────────────────────────────────────────────────

class _RouteInfo extends StatelessWidget {
  final _IncomingTripRequest request;

  const _RouteInfo({required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder, width: 1),
      ),
      child: Column(
        children: [
          _RoutePoint(
            icon: Icons.radio_button_checked_rounded,
            iconColor: AppColors.mapPickup,
            label: 'Pickup',
            address: request.pickupAddress,
          ),
          Padding(
            padding: EdgeInsets.only(left: 9),
            child: Column(
              children: List.generate(
                3,
                (i) => Container(
                  margin: EdgeInsets.symmetric(vertical: 2),
                  width: 2,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.darkBorder,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ),
          ),
          _RoutePoint(
            icon: Icons.location_on_rounded,
            iconColor: AppColors.mapDropoff,
            label: 'Drop-off',
            address: request.dropoffAddress,
          ),
        ],
      ),
    );
  }
}

class _RoutePoint extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String address;

  const _RoutePoint({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: iconColor, size: 20),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.darkTextSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                address,
                style: TextStyle(
                  color: AppColors.darkTextPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Fare & Distance Row
// ─────────────────────────────────────────────────────────────────────────────

class _FareDistanceRow extends StatelessWidget {
  final _IncomingTripRequest request;

  const _FareDistanceRow({required this.request});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              gradient: AppColors.earningsGradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FARE',
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.75),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '\$${request.estimatedFare.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.darkSurfaceElevated,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.darkBorder, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DISTANCE',
                  style: TextStyle(
                    color: AppColors.darkTextSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      request.distance.toStringAsFixed(1),
                      style: TextStyle(
                        color: AppColors.darkTextPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 3),
                    Padding(
                      padding: EdgeInsets.only(bottom: 3),
                      child: Text(
                        'km',
                        style: TextStyle(
                          color: AppColors.darkTextSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Default Avatar
// ─────────────────────────────────────────────────────────────────────────────

class _DefaultAvatar extends StatelessWidget {
  final String name;

  const _DefaultAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final String initial =
        name.isNotEmpty ? name[0].toUpperCase() : 'D';
    return Container(
      color: AppColors.primaryDark,
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data Model
// ─────────────────────────────────────────────────────────────────────────────

class _IncomingTripRequest {
  final String tripId;
  final String riderName;
  final String riderAvatar;
  final double riderRating;
  final String pickupAddress;
  final String dropoffAddress;
  final double distance;
  final double estimatedFare;
  final int estimatedDuration;
  final LatLng pickupLocation;
  final LatLng dropoffLocation;

  const _IncomingTripRequest({
    required this.tripId,
    required this.riderName,
    required this.riderAvatar,
    required this.riderRating,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.distance,
    required this.estimatedFare,
    required this.estimatedDuration,
    required this.pickupLocation,
    required this.dropoffLocation,
  });
}