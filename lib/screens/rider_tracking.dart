import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:new_project_app/utils/colors.dart'; 
import 'package:new_project_app/providers/ride_provider.dart';
import 'package:new_project_app/providers/auth_provider.dart';
import 'package:new_project_app/widgets/ride_state_chip.dart'; 

class RiderTrackingScreen extends StatefulWidget {
  const RiderTrackingScreen({Key? key}) : super(key: key);

  @override
  State<RiderTrackingScreen> createState() => _RiderTrackingScreenState();
}

class _RiderTrackingScreenState extends State<RiderTrackingScreen>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  bool _mapReady = false;
  bool _showCancelConfirm = false;
  bool _isExpanded = false;

  late AnimationController _cardSlideController;
  late Animation<Offset> _cardSlideAnimation;
  late AnimationController _etaPulseController;
  late Animation<double> _etaPulseAnimation;
  late AnimationController _markerBounceController;
  late Animation<double> _markerBounceAnimation;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  StreamController<LatLng> _driverPositionStream =
      StreamController<LatLng>.broadcast();

  LatLng? _lastDriverPosition;

  @override
  void initState() {
    super.initState();

    _cardSlideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _cardSlideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _cardSlideController,
      curve: Curves.easeOutCubic,
    ));

    _etaPulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    _etaPulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _etaPulseController,
        curve: Curves.easeInOut,
      ),
    );
    _etaPulseController.repeat(reverse: true);

    _markerBounceController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _markerBounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _markerBounceController,
        curve: Curves.elasticOut,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cardSlideController.forward();
      _markerBounceController.forward();
      _initTracking();
    });
  }

  void _initTracking() {
    final rideProvider = context.read<RideProvider>();
    _updateMapMarkers(rideProvider);
    _buildRoutePolyline(rideProvider);

    rideProvider.addListener(() {
      if (!mounted) return;
      final driver = rideProvider.assignedDriver;
      if (driver != null) {
        final newPos = driver.currentPosition;
        if (_lastDriverPosition != newPos) {
          _lastDriverPosition = newPos;
          _driverPositionStream.add(newPos);
          _updateMapMarkers(rideProvider);
          _animateMapToDriver(newPos);
        }
      }
    });
  }

  void _updateMapMarkers(RideProvider rideProvider) {
    final driver = rideProvider.assignedDriver;
    final pickup = rideProvider.pickupLocation;
    final dropoff = rideProvider.dropoffLocation;

    Set<Marker> newMarkers = {};

    if (driver != null) {
      newMarkers.add(
        Marker(
          markerId: MarkerId('driver_marker'),
          position: driver.currentPosition,
          rotation: driver.bearing,
          anchor: Offset(0.5, 0.5),
          flat: true,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet,
          ),
          infoWindow: InfoWindow(title: driver.name, snippet: driver.vehicleModel),
        ),
      );
    }

    if (pickup != null) {
      newMarkers.add(
        Marker(
          markerId: MarkerId('pickup_marker'),
          position: pickup,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          infoWindow: InfoWindow(title: 'Pickup'),
        ),
      );
    }

    if (dropoff != null) {
      newMarkers.add(
        Marker(
          markerId: MarkerId('dropoff_marker'),
          position: dropoff,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),
          infoWindow: InfoWindow(title: 'Destination'),
        ),
      );
    }

    if (mounted) {
      setState(() {
        _markers.clear();
        _markers.addAll(newMarkers);
      });
    }
  }

  void _buildRoutePolyline(RideProvider rideProvider) {
    final pickup = rideProvider.pickupLocation;
    final dropoff = rideProvider.dropoffLocation;
    final driver = rideProvider.assignedDriver;

    if (pickup == null || dropoff == null) return;

    List<LatLng> points = [];
    if (driver != null) {
      points.add(driver.currentPosition);
    }
    points.add(pickup);
    points.add(dropoff);

    final polyline = Polyline(
      polylineId: PolylineId('route'),
      color: AppColors.primary,
      width: 4,
      points: points,
      patterns: [],
    );

    if (mounted) {
      setState(() {
        _polylines.clear();
        _polylines.add(polyline);
      });
    }
  }

  void _animateMapToDriver(LatLng position) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(position),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapReady = true;

    final rideProvider = context.read<RideProvider>();
    final driver = rideProvider.assignedDriver;
    final pickup = rideProvider.pickupLocation;

    LatLng initialPos = driver?.currentPosition ??
        pickup ??
        rideProvider.userLocation;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: initialPos,
          zoom: 15.0,
        ),
      ),
    );
  }

  void _showCancelDialog() {
    setState(() {
      _showCancelConfirm = true;
    });
  }

  void _hideCancelDialog() {
    setState(() {
      _showCancelConfirm = false;
    });
  }

  Future<void> _confirmCancel() async {
    final rideProvider = context.read<RideProvider>();
    await rideProvider.cancelRide(reason: 'Rider cancelled');
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  void dispose() {
    _cardSlideController.dispose();
    _etaPulseController.dispose();
    _markerBounceController.dispose();
    _mapController?.dispose();
    _driverPositionStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          _buildMap(),
          _buildTopOverlay(),
          _buildBottomCard(),
          if (_showCancelConfirm) _buildCancelConfirmOverlay(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return Consumer<RideProvider>(
      builder: (context, rideProvider, _) {
        final driver = rideProvider.assignedDriver;
        final pickup = rideProvider.pickupLocation;

        LatLng initialTarget = driver?.currentPosition ??
            pickup ??
            rideProvider.userLocation;

        return GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: initialTarget,
            zoom: 15.0,
          ),
          markers: _markers,
          polylines: _polylines,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          compassEnabled: false,
          mapToolbarEnabled: false,
          tiltGesturesEnabled: false,
          padding: EdgeInsets.only(bottom: _isExpanded ? 360 : 260),
        );
      },
    );
  }

  Widget _buildTopOverlay() {
    return Consumer<RideProvider>(
      builder: (context, rideProvider, _) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildBackButton(),
                SizedBox(width: 12),
                _buildETAChip(rideProvider),
                Spacer(),
                _buildRideStateChip(rideProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowNeutral,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.grey900,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildETAChip(RideProvider rideProvider) {
    final int eta = rideProvider.etaMinutes;
    final String etaText = rideProvider.formatEta(eta);

    return AnimatedBuilder(
      animation: _etaPulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _etaPulseAnimation.value,
          child: child,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowPrimary,
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.access_time_rounded,
              color: AppColors.white,
              size: 16,
            ),
            SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  etaText,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
                Text(
                  'Estimated arrival',
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.8),
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRideStateChip(RideProvider rideProvider) {
    return RideStateChip(
      state: rideProvider.rideState,
      animated: true,
      compact: true,
    );
  }

  Widget _buildBottomCard() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _cardSlideAnimation,
        child: Consumer2<RideProvider, AuthProvider>(
          builder: (context, rideProvider, authProvider, _) {
            final driver = rideProvider.assignedDriver;
            return Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowDark,
                    blurRadius: 32,
                    offset: Offset(0, -8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDragHandle(),
                  if (driver != null) ...[
                    _buildDriverInfoCard(driver, rideProvider),
                    _buildTripInfoRow(rideProvider),
                    if (_isExpanded) _buildExpandedDetails(rideProvider),
                    _buildActionButtons(rideProvider),
                  ] else
                    _buildMatchingState(rideProvider),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return GestureDetector(
      onTap: _toggleExpanded,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMatchingState(RideProvider rideProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        children: [
          _MatchingPulseWidget(),
          SizedBox(height: 16),
          Text(
            'Finding your driver...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.grey900,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please wait while we match you with a nearby driver',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey600,
            ),
          ),
          SizedBox(height: 24),
          _buildCancelButton(),
        ],
      ),
    );
  }

  Widget _buildDriverInfoCard(DriverInfo driver, RideProvider rideProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildDriverAvatar(driver),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      driver.name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.grey900,
                      ),
                    ),
                    Spacer(),
                    _buildRatingBadge(driver.rating),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  driver.vehicleModel,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.grey600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                _buildPlateBadge(driver.vehiclePlate),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverAvatar(DriverInfo driver) {
    return Stack(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowPrimary,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.network(
              driver.avatarUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(
                Icons.person_rounded,
                color: AppColors.white,
                size: 32,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 2,
          right: 2,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.onlineStatus,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingBadge(double rating) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.warningSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            color: AppColors.starActive,
            size: 14,
          ),
          SizedBox(width: 3),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.warningDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlateBadge(String plate) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Text(
        plate,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTripInfoRow(RideProvider rideProvider) {
    final fareEstimate = rideProvider.fareEstimate;
    final fareText = fareEstimate != null
        ? fareEstimate.displayRange
        : 'Calculating...';
    final distance = fareEstimate != null
        ? rideProvider.formatDistance(fareEstimate.distance)
        : '--';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.offWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.borderLight,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            _TripInfoItem(
              icon: Icons.route_rounded,
              iconColor: AppColors.primary,
              label: 'Distance',
              value: distance,
            ),
            _buildVerticalDivider(),
            _TripInfoItem(
              icon: Icons.payments_rounded,
              iconColor: AppColors.secondary,
              label: 'Fare',
              value: fareText,
            ),
            _buildVerticalDivider(),
            _TripInfoItem(
              icon: Icons.access_time_rounded,
              iconColor: AppColors.tertiary,
              label: 'ETA',
              value: rideProvider.formatEta(rideProvider.etaMinutes),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.borderLight,
      margin: EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildExpandedDetails(RideProvider rideProvider) {
    final driver = rideProvider.assignedDriver;
    if (driver == null) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRouteDetails(rideProvider),
          SizedBox(height: 12),
          _buildContactButtons(driver),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildRouteDetails(RideProvider rideProvider) {
    final pickupPlace = rideProvider.pickupPlace;
    final dropoffPlace = rideProvider.dropoffPlace;

    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _RoutePointRow(
            icon: Icons.radio_button_checked_rounded,
            iconColor: AppColors.mapPickup,
            label: 'Pickup',
            address: pickupPlace?.fullAddress ?? 'Current Location',
          ),
          Padding(
            padding: EdgeInsets.only(left: 9),
            child: Column(
              children: List.generate(
                3,
                (i) => Container(
                  width: 2,
                  height: 4,
                  margin: EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ),
          ),
          _RoutePointRow(
            icon: Icons.location_on_rounded,
            iconColor: AppColors.mapDropoff,
            label: 'Destination',
            address: dropoffPlace?.fullAddress ?? 'Destination',
          ),
        ],
      ),
    );
  }

  Widget _buildContactButtons(DriverInfo driver) {
    return Row(
      children: [
        Expanded(
          child: _ContactButton(
            icon: Icons.phone_rounded,
            label: 'Call Driver',
            color: AppColors.success,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calling ${driver.name}...'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _ContactButton(
            icon: Icons.message_rounded,
            label: 'Message',
            color: AppColors.primary,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opening chat with ${driver.name}...'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(RideProvider rideProvider) {
    final isActive = rideProvider.rideState == RideState.active;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          if (!isActive) ...[
            Expanded(child: _buildCancelButton()),
          ] else ...[
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.successSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.success.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.navigation_rounded,
                      color: AppColors.success,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'On Trip — Enjoy the ride!',
                      style: TextStyle(
                        color: AppColors.successDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          SizedBox(width: 12),
          _buildShareButton(),
        ],
      ),
    );
  }

  Widget _buildCancelButton() {
    return GestureDetector(
      onTap: _showCancelDialog,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.errorSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.error.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cancel_outlined,
              color: AppColors.error,
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              'Cancel Ride',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareButton() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sharing trip details...'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.25),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.share_rounded,
          color: AppColors.primary,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildCancelConfirmOverlay() {
    return Container(
      color: AppColors.scrim,
      child: Center(
        child: _CancelConfirmDialog(
          onCancel: _hideCancelDialog,
          onConfirm: _confirmCancel,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private Widgets
// ─────────────────────────────────────────────────────────────────────────────

class _MatchingPulseWidget extends StatefulWidget {
  const _MatchingPulseWidget({Key? key}) : super(key: key);

  @override
  State<_MatchingPulseWidget> createState() => _MatchingPulseWidgetState();
}

class _MatchingPulseWidgetState extends State<_MatchingPulseWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1400),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowPrimary,
                  blurRadius: 20,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              Icons.directions_car_rounded,
              color: AppColors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

class _TripInfoItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _TripInfoItem({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 18,
            ),
          ),
          SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.grey900,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.grey500,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutePointRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String address;

  const _RoutePointRow({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.grey500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                address,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.grey900,
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

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ContactButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CancelConfirmDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const _CancelConfirmDialog({
    Key? key,
    required this.onCancel,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowDark,
              blurRadius: 40,
              offset: Offset(0, 16),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.errorSurface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cancel_rounded,
                  color: AppColors.error,
                  size: 32,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Cancel Ride?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.grey900,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Are you sure you want to cancel your ride? A cancellation fee may apply.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey600,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onCancel,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            'Keep Ride',
                            style: TextStyle(
                              color: AppColors.grey700,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: onConfirm,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.error, AppColors.errorDark],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.error.withOpacity(0.35),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Yes, Cancel',
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
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
// Data model alias for convenience within this file
// ─────────────────────────────────────────────────────────────────────────────

typedef DriverInfo = new_project_app_DriverInfo;

// Avoid re-declaring — use the imported model from ride_provider directly.
// The DriverInfo class is already defined in ride_provider.dart and imported
// via the provider. We reference it directly without re-declaring.

// Removing typedef to avoid conflict — DriverInfo from RideProvider is used directly.