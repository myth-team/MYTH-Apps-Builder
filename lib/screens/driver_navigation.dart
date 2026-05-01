import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:new_project_app/utils/colors.dart'; 
import 'package:new_project_app/providers/ride_provider.dart';
import 'package:new_project_app/widgets/ride_state_chip.dart'; 

class DriverNavigationScreen extends StatefulWidget {
  const DriverNavigationScreen({Key? key}) : super(key: key);

  @override
  State<DriverNavigationScreen> createState() => _DriverNavigationScreenState();
}

class _DriverNavigationScreenState extends State<DriverNavigationScreen>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  bool _hasArrived = false;
  bool _tripStarted = false;
  bool _showTurnOverlay = true;
  int _currentStep = 0;

  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _progressController;
  late Animation<double> _pulseAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _progressAnim;

  Timer? _navigationTimer;
  Timer? _etaUpdateTimer;
  int _simulatedEta = 12;
  double _simulatedProgress = 0.0;

  final List<Map<String, dynamic>> _turnByTurnSteps = [
    {
      'instruction': 'Head north on Market St',
      'distance': '200 m',
      'icon': Icons.straight,
      'color': AppColors.info,
    },
    {
      'instruction': 'Turn right onto 5th Ave',
      'distance': '450 m',
      'icon': Icons.turn_right,
      'color': AppColors.warning,
    },
    {
      'instruction': 'Keep left at the fork',
      'distance': '1.2 km',
      'icon': Icons.fork_left,
      'color': AppColors.primary,
    },
    {
      'instruction': 'Turn left onto Broadway',
      'distance': '300 m',
      'icon': Icons.turn_left,
      'color': AppColors.warning,
    },
    {
      'instruction': 'Arrive at destination',
      'distance': '50 m',
      'icon': Icons.location_on_rounded,
      'color': AppColors.success,
    },
  ];

  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _setupNavigation();
    _startEtaSimulation();
  }

  void _initAnimations() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _pulseAnim = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideAnim = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _progressAnim = Tween<double>(begin: 0, end: 0).animate(_progressController);

    _slideController.forward();
  }

  void _setupNavigation() {
    final rideProvider = context.read<RideProvider>();
    final pickup = rideProvider.pickupLocation ?? const LatLng(37.7749, -122.4194);
    final dropoff = rideProvider.dropoffLocation ?? const LatLng(37.7849, -122.4094);

    _polylines = {
      Polyline(
        polylineId: PolylineId('route_main'),
        color: AppColors.primary,
        width: 5,
        points: _generateRoutePoints(pickup, dropoff),
        patterns: [],
      ),
    };

    _markers = {
      Marker(
        markerId: MarkerId('pickup'),
        position: pickup,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: 'Pickup'),
      ),
      Marker(
        markerId: MarkerId('dropoff'),
        position: dropoff,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: 'Drop-off'),
      ),
    };
  }

  List<LatLng> _generateRoutePoints(LatLng start, LatLng end) {
    final List<LatLng> points = [];
    const int steps = 20;
    for (int i = 0; i <= steps; i++) {
      final double t = i / steps;
      final double lat = start.latitude + (end.latitude - start.latitude) * t;
      final double lng = start.longitude + (end.longitude - start.longitude) * t;
      final double wave = math.sin(t * math.pi * 3) * 0.002;
      points.add(LatLng(lat + wave, lng));
    }
    return points;
  }

  void _startEtaSimulation() {
    _etaUpdateTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_simulatedEta > 0) {
          _simulatedEta = (_simulatedEta - 1).clamp(0, 9999);
        }
        if (_simulatedProgress < 0.95) {
          _simulatedProgress = (_simulatedProgress + 0.06).clamp(0.0, 1.0);
        }
        if (_simulatedProgress > 0.3 && _currentStep < _turnByTurnSteps.length - 1) {
          _currentStep = math.min(
            _currentStep + 1,
            _turnByTurnSteps.length - 1,
          );
        }
      });

      _progressController.animateTo(
        _simulatedProgress,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
      );
    });
  }

  void _onArriveAtPickup() {
    final rideProvider = context.read<RideProvider>();
    setState(() {
      _hasArrived = true;
    });
    rideProvider.driverArriveAtPickup();
    _showArrivalSnack('You have arrived at the pickup location!');
  }

  void _onStartTrip() {
    final rideProvider = context.read<RideProvider>();
    setState(() {
      _tripStarted = true;
      _hasArrived = false;
      _simulatedProgress = 0.0;
      _simulatedEta = 18;
      _currentStep = 0;
    });
    rideProvider.driverBeginTrip();
    _showArrivalSnack('Trip started! Navigate to destination.');
  }

  void _onCompleteTrip() {
    final rideProvider = context.read<RideProvider>();
    rideProvider.driverCompleteTrip();
    _showCompletionDialog();
  }

  void _showArrivalSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(color: AppColors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 30,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.tealGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.tertiary.withOpacity(0.4),
                        blurRadius: 20,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(Icons.check_rounded, color: AppColors.white, size: 36),
                ),
                SizedBox(height: 20),
                Text(
                  'Trip Completed!',
                  style: GoogleFonts.inter(
                    color: AppColors.darkTextPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Great job! Your earnings have been credited.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: AppColors.darkTextSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      'Back to Home',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _progressController.dispose();
    _navigationTimer?.cancel();
    _etaUpdateTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RideProvider>(
      builder: (context, rideProvider, _) {
        final pickup = rideProvider.pickupLocation ?? const LatLng(37.7749, -122.4194);
        final dropoff = rideProvider.dropoffLocation ?? const LatLng(37.7849, -122.4094);
        final midLat = (pickup.latitude + dropoff.latitude) / 2;
        final midLng = (pickup.longitude + dropoff.longitude) / 2;

        return Scaffold(
          backgroundColor: AppColors.darkBackground,
          body: Stack(
            children: [
              // ── Full-screen Map ──────────────────────────────────────────
              Positioned.fill(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(midLat, midLng),
                    zoom: 14.5,
                  ),
                  onMapCreated: (ctrl) => _mapController = ctrl,
                  polylines: _polylines,
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  compassEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  trafficEnabled: true,
                ),
              ),

              // ── Dark gradient overlay at top ─────────────────────────────
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 160,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.darkBackground.withOpacity(0.95),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // ── Top Bar ──────────────────────────────────────────────────
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).maybePop(),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.darkSurface.withOpacity(0.9),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.darkBorder, width: 1),
                            ),
                            child: Icon(Icons.arrow_back_rounded, color: AppColors.white, size: 20),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _tripStarted ? 'Navigating to Destination' : 'Navigate to Pickup',
                                style: GoogleFonts.inter(
                                  color: AppColors.darkTextPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                _tripStarted
                                    ? (rideProvider.dropoffPlace?.primaryText ?? 'Destination')
                                    : (rideProvider.pickupPlace?.primaryText ?? 'Pickup Location'),
                                style: GoogleFonts.inter(
                                  color: AppColors.darkTextSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        RideStateChip(
                          state: rideProvider.rideState,
                          compact: true,
                          animated: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Turn-by-Turn Overlay ─────────────────────────────────────
              if (_showTurnOverlay)
                Positioned(
                  top: 100,
                  left: 16,
                  right: 16,
                  child: SafeArea(
                    child: _TurnByTurnCard(
                      step: _turnByTurnSteps[_currentStep],
                      onDismiss: () => setState(() => _showTurnOverlay = false),
                    ),
                  ),
                ),

              // ── Re-show Turn Overlay Button ──────────────────────────────
              if (!_showTurnOverlay)
                Positioned(
                  top: 100,
                  right: 16,
                  child: SafeArea(
                    child: GestureDetector(
                      onTap: () => setState(() => _showTurnOverlay = true),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.navigation_rounded, color: AppColors.white, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'Directions',
                              style: GoogleFonts.inter(
                                color: AppColors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              // ── Recenter Button ──────────────────────────────────────────
              Positioned(
                bottom: 320,
                right: 16,
                child: GestureDetector(
                  onTap: () {
                    _mapController?.animateCamera(
                      CameraUpdate.newLatLngZoom(
                        _tripStarted ? dropoff : pickup,
                        15.5,
                      ),
                    );
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.darkSurface.withOpacity(0.95),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.darkBorder, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowDark,
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(Icons.my_location_rounded, color: AppColors.primary, size: 22),
                  ),
                ),
              ),

              // ── Bottom Panel ─────────────────────────────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SlideTransition(
                  position: _slideAnim,
                  child: _BottomNavigationPanel(
                    rideProvider: rideProvider,
                    simulatedEta: _simulatedEta,
                    simulatedProgress: _simulatedProgress,
                    hasArrived: _hasArrived,
                    tripStarted: _tripStarted,
                    pulseAnim: _pulseAnim,
                    onArriveAtPickup: _onArriveAtPickup,
                    onStartTrip: _onStartTrip,
                    onCompleteTrip: _onCompleteTrip,
                    currentStep: _currentStep,
                    totalSteps: _turnByTurnSteps.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Turn-by-Turn Card
// ─────────────────────────────────────────────────────────────────────────────

class _TurnByTurnCard extends StatelessWidget {
  final Map<String, dynamic> step;
  final VoidCallback onDismiss;

  const _TurnByTurnCard({
    required this.step,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.darkSurface.withOpacity(0.97),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.darkBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: (step['color'] as Color).withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: (step['color'] as Color).withOpacity(0.4),
                width: 1.2,
              ),
            ),
            child: Icon(
              step['icon'] as IconData,
              color: step['color'] as Color,
              size: 26,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step['instruction'] as String,
                  style: GoogleFonts.inter(
                    color: AppColors.darkTextPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3),
                Row(
                  children: [
                    Icon(Icons.straighten_rounded, color: AppColors.grey500, size: 13),
                    SizedBox(width: 4),
                    Text(
                      step['distance'] as String,
                      style: GoogleFonts.inter(
                        color: AppColors.darkTextSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onDismiss,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.darkSurfaceElevated,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close_rounded, color: AppColors.grey500, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom Navigation Panel
// ─────────────────────────────────────────────────────────────────────────────

class _BottomNavigationPanel extends StatelessWidget {
  final RideProvider rideProvider;
  final int simulatedEta;
  final double simulatedProgress;
  final bool hasArrived;
  final bool tripStarted;
  final Animation<double> pulseAnim;
  final VoidCallback onArriveAtPickup;
  final VoidCallback onStartTrip;
  final VoidCallback onCompleteTrip;
  final int currentStep;
  final int totalSteps;

  const _BottomNavigationPanel({
    required this.rideProvider,
    required this.simulatedEta,
    required this.simulatedProgress,
    required this.hasArrived,
    required this.tripStarted,
    required this.pulseAnim,
    required this.onArriveAtPickup,
    required this.onStartTrip,
    required this.onCompleteTrip,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 30,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.darkBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // ── ETA & Progress Row ────────────────────────────────────
              Row(
                children: [
                  _EtaChip(eta: simulatedEta, tripStarted: tripStarted),
                  SizedBox(width: 12),
                  Expanded(
                    child: _TripProgressBar(
                      progress: simulatedProgress,
                      currentStep: currentStep,
                      totalSteps: totalSteps,
                    ),
                  ),
                  SizedBox(width: 12),
                  _DistanceChip(rideProvider: rideProvider, tripStarted: tripStarted),
                ],
              ),

              SizedBox(height: 18),

              // ── Rider Info ────────────────────────────────────────────
              if (!tripStarted)
                _RiderInfoRow(rideProvider: rideProvider),

              if (!tripStarted) SizedBox(height: 16),

              // ── Route Summary ─────────────────────────────────────────
              _RouteSummaryRow(rideProvider: rideProvider, tripStarted: tripStarted),

              SizedBox(height: 20),

              // ── Action Button ─────────────────────────────────────────
              _ActionButton(
                hasArrived: hasArrived,
                tripStarted: tripStarted,
                pulseAnim: pulseAnim,
                onArriveAtPickup: onArriveAtPickup,
                onStartTrip: onStartTrip,
                onCompleteTrip: onCompleteTrip,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ETA Chip
// ─────────────────────────────────────────────────────────────────────────────

class _EtaChip extends StatelessWidget {
  final int eta;
  final bool tripStarted;

  const _EtaChip({required this.eta, required this.tripStarted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: tripStarted ? AppColors.tealGradient : AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: (tripStarted ? AppColors.tertiary : AppColors.primary).withOpacity(0.35),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            eta <= 0 ? 'Here' : '$eta',
            style: GoogleFonts.inter(
              color: AppColors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            eta <= 0 ? 'Now' : 'min',
            style: GoogleFonts.inter(
              color: AppColors.white.withOpacity(0.8),
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
// Trip Progress Bar
// ─────────────────────────────────────────────────────────────────────────────

class _TripProgressBar extends StatelessWidget {
  final double progress;
  final int currentStep;
  final int totalSteps;

  const _TripProgressBar({
    required this.progress,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step ${currentStep + 1} of $totalSteps',
              style: GoogleFonts.inter(
                color: AppColors.darkTextSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: GoogleFonts.inter(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Stack(
            children: [
              Container(
                height: 8,
                color: AppColors.darkSurfaceElevated,
              ),
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Distance Chip
// ─────────────────────────────────────────────────────────────────────────────

class _DistanceChip extends StatelessWidget {
  final RideProvider rideProvider;
  final bool tripStarted;

  const _DistanceChip({required this.rideProvider, required this.tripStarted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.darkBorder, width: 1),
      ),
      child: Column(
        children: [
          Text(
            tripStarted ? '3.2' : '1.8',
            style: GoogleFonts.inter(
              color: AppColors.darkTextPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            'km',
            style: GoogleFonts.inter(
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
// Rider Info Row
// ─────────────────────────────────────────────────────────────────────────────

class _RiderInfoRow extends StatelessWidget {
  final RideProvider rideProvider;

  const _RiderInfoRow({required this.rideProvider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder, width: 1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sarah Williams',
                  style: GoogleFonts.inter(
                    color: AppColors.darkTextPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.star_rounded, color: AppColors.starActive, size: 14),
                    SizedBox(width: 3),
                    Text(
                      '4.85',
                      style: GoogleFonts.inter(
                        color: AppColors.darkTextSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              _ContactButton(
                icon: Icons.phone_rounded,
                color: AppColors.success,
                onTap: () {},
              ),
              SizedBox(width: 8),
              _ContactButton(
                icon: Icons.message_rounded,
                color: AppColors.primary,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ContactButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Route Summary Row
// ─────────────────────────────────────────────────────────────────────────────

class _RouteSummaryRow extends StatelessWidget {
  final RideProvider rideProvider;
  final bool tripStarted;

  const _RouteSummaryRow({required this.rideProvider, required this.tripStarted});

  @override
  Widget build(BuildContext context) {
    final pickupText = rideProvider.pickupPlace?.primaryText ?? 'Pickup Location';
    final dropoffText = rideProvider.dropoffPlace?.primaryText ?? 'Destination';

    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.darkBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder.withOpacity(0.5), width: 1),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.mapPickup,
                  boxShadow: [
                    BoxShadow(color: AppColors.mapPickup.withOpacity(0.4), blurRadius: 6),
                  ],
                ),
              ),
              Container(
                width: 1.5,
                height: 22,
                color: AppColors.darkBorder,
                margin: EdgeInsets.symmetric(vertical: 3),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: tripStarted ? AppColors.mapDropoff : AppColors.grey500,
                  boxShadow: [
                    BoxShadow(
                      color: (tripStarted ? AppColors.mapDropoff : AppColors.grey500).withOpacity(0.4),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pickupText,
                  style: GoogleFonts.inter(
                    color: AppColors.darkTextPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Text(
                  dropoffText,
                  style: GoogleFonts.inter(
                    color: tripStarted ? AppColors.darkTextPrimary : AppColors.darkTextSecondary,
                    fontSize: 13,
                    fontWeight: tripStarted ? FontWeight.w600 : FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
            child: Text(
              rideProvider.fareEstimate != null
                  ? '\$${rideProvider.fareEstimate!.midFare.toStringAsFixed(2)}'
                  : '\$14.50',
              style: GoogleFonts.inter(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Action Button
// ─────────────────────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final bool hasArrived;
  final bool tripStarted;
  final Animation<double> pulseAnim;
  final VoidCallback onArriveAtPickup;
  final VoidCallback onStartTrip;
  final VoidCallback onCompleteTrip;

  const _ActionButton({
    required this.hasArrived,
    required this.tripStarted,
    required this.pulseAnim,
    required this.onArriveAtPickup,
    required this.onStartTrip,
    required this.onCompleteTrip,
  });

  @override
  Widget build(BuildContext context) {
    String label;
    IconData icon;
    Gradient gradient;
    Color shadowColor;
    VoidCallback onTap;

    if (!tripStarted && !hasArrived) {
      label = 'I\'ve Arrived at Pickup';
      icon = Icons.where_to_vote_rounded;
      gradient = AppColors.tealGradient;
      shadowColor = AppColors.tertiary;
      onTap = onArriveAtPickup;
    } else if (hasArrived && !tripStarted) {
      label = 'Start Trip';
      icon = Icons.play_arrow_rounded;
      gradient = AppColors.primaryGradient;
      shadowColor = AppColors.primary;
      onTap = onStartTrip;
    } else {
      label = 'Complete Trip';
      icon = Icons.flag_rounded;
      gradient = AppColors.secondaryGradient;
      shadowColor = AppColors.secondary;
      onTap = onCompleteTrip;
    }

    return AnimatedBuilder(
      animation: pulseAnim,
      builder: (context, child) {
        return Transform.scale(
          scale: (!tripStarted && !hasArrived) ? pulseAnim.value : 1.0,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.45),
                blurRadius: 20,
                offset: Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.white, size: 22),
              SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: AppColors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}