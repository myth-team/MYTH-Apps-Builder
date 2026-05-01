import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridenow_go_app/models/ride.dart'; 
import 'package:ridenow_go_app/services/ride_service.dart'; 
import 'package:ridenow_go_app/utils/colors.dart'; 
import 'package:ridenow_go_app/widgets/driver_info_tile.dart'; 
import 'package:ridenow_go_app/widgets/price_tag.dart'; 

class TripActiveScreen extends StatefulWidget {
  final Ride? ride;

  TripActiveScreen({this.ride});

  @override
  _TripActiveScreenState createState() => _TripActiveScreenState();
}

class _TripActiveScreenState extends State<TripActiveScreen>
    with TickerProviderStateMixin {
  final RideService _rideService = RideService.instance;

  Ride? _ride;
  StreamSubscription? _rideSubscription;

  GoogleMapController? _mapController;
  bool _isMapReady = false;

  late AnimationController _progressController;
  double _tripProgress = 0.0;

  bool _showSafetyTools = false;

  @override
  void initState() {
    super.initState();

    _ride = widget.ride;
    _progressController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _setupRideStream();
    _simulateTripProgress();
  }

  void _setupRideStream() {
    _rideSubscription = _rideService.rideStream.listen((ride) {
      if (ride != null && mounted) {
        setState(() {
          _ride = ride;
        });

        if (ride.status == RideStatus.completed) {
          Navigator.of(context).pushReplacementNamed('/payment', arguments: ride);
        }
      }
    });
  }

  void _simulateTripProgress() {
    Timer.periodic(Duration(seconds: 3), (timer) {
      if (!mounted || _tripProgress >= 1.0) {
        timer.cancel();
        return;
      }

      setState(() {
        _tripProgress = (_tripProgress + 0.05).clamp(0.0, 1.0);
      });
    });
  }

  Future<void> _completeTrip() async {
    final completedRide = await _rideService.completeRide(
      finalDistanceKm: _ride?.distanceKm ?? 5.2,
      finalDurationMinutes: _ride?.durationMinutes ?? 18,
    );

    if (completedRide != null && mounted) {
      Navigator.of(context).pushReplacementNamed('/payment', arguments: completedRide);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() {
      _isMapReady = true;
    });

    if (_ride?.pickup != null && _ride?.destination != null) {
      _fitBounds();
    }
  }

  void _fitBounds() {
    if (_ride?.pickup == null || _ride?.destination == null) return;

    final bounds = LatLngBounds(
      southwest: LatLng(
        _ride!.pickup.latitude < _ride!.destination.latitude
            ? _ride!.pickup.latitude
            : _ride!.destination.latitude,
        _ride!.pickup.longitude < _ride!.destination.longitude
            ? _ride!.pickup.longitude
            : _ride!.destination.longitude,
      ),
      northeast: LatLng(
        _ride!.pickup.latitude > _ride!.destination.latitude
            ? _ride!.pickup.latitude
            : _ride!.destination.latitude,
        _ride!.pickup.longitude > _ride!.destination.longitude
            ? _ride!.pickup.longitude
            : _ride!.destination.longitude,
      ),
    );

    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 80),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _progressController.dispose();
    _rideSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(),
          _buildOverlayUI(),
          if (_showSafetyTools) _buildSafetyToolsSheet(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          _ride?.pickup.latitude ?? 37.7749,
          _ride?.pickup.longitude ?? -122.4194,
        ),
        zoom: 15,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      polylines: _buildRoutePolyline(),
      markers: _buildMarkers(),
    );
  }

  Set<Polyline> _buildRoutePolyline() {
    if (_ride?.pickup == null || _ride?.destination == null) return {};

    return {
      Polyline(
        polylineId: PolylineId('route'),
        points: [
          LatLng(_ride!.pickup.latitude, _ride!.pickup.longitude),
          LatLng(_ride!.destination.latitude, _ride!.destination.longitude),
        ],
        color: AppColors.mapRoute,
        width: 5,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ),
    };
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};

    if (_ride?.pickup != null) {
      markers.add(Marker(
        markerId: MarkerId('pickup'),
        position: LatLng(_ride!.pickup.latitude, _ride!.pickup.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));
    }

    if (_ride?.destination != null) {
      markers.add(Marker(
        markerId: MarkerId('destination'),
        position: LatLng(_ride!.destination.latitude, _ride!.destination.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    }

    return markers;
  }

  Widget _buildOverlayUI() {
    return SafeArea(
      child: Column(
        children: [
          _buildTopBar(),
          Spacer(),
          _buildTripInfoCard(),
          _buildProgressBar(),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Show trip details
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.textPrimary,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.success,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'On Trip',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _showSafetyTools = true;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.shield_outlined,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripInfoCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_ride?.driver != null)
            DriverInfoTile(
              driver: _ride!.driver!,
              showEta: false,
              showPhoneAction: true,
              compact: true,
              onPhoneTap: () {
                // Launch phone call
              },
            ),
          if (_ride?.driver != null) Divider(height: 20, color: AppColors.divider),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.route_rounded,
                  value: _ride?.distanceDisplay ?? '--',
                  label: 'Distance',
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.divider,
              ),
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.timer_rounded,
                  value: _ride?.durationDisplay ?? '--',
                  label: 'Duration',
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.divider,
              ),
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.payments_rounded,
                  value: _ride?.fareDisplay ?? '--',
                  label: 'Fare',
                  valueColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String value,
    required String label,
    Color? valueColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.textTertiary,
        ),
        SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trip Progress',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${(_tripProgress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: _tripProgress,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              backgroundColor: AppColors.neutral200,
              minHeight: 8,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _ride?.pickup.shortDisplay ?? 'Start',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                _ride?.destination.shortDisplay ?? 'End',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              icon: Icons.share_location_rounded,
              label: 'Share Trip',
              onTap: () {
                // Share trip status
              },
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: AppColors.buildGradient(AppColors.primaryGradient),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _completeTrip,
                  borderRadius: BorderRadius.circular(14),
                  child: Center(
                    child: Text(
                      'End Trip',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyToolsSheet() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showSafetyTools = false;
          });
        },
        child: Container(
          color: AppColors.scrim,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.neutral300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Safety Tools',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildSafetyTool(
                      icon: Icons.emergency_rounded,
                      title: 'Emergency Assistance',
                      subtitle: 'Call emergency services',
                      color: AppColors.error,
                      onTap: () {
                        // Emergency call
                      },
                    ),
                    SizedBox(height: 12),
                    _buildSafetyTool(
                      icon: Icons.share_rounded,
                      title: 'Share Trip Status',
                      subtitle: 'Send live trip details to contacts',
                      color: AppColors.primary,
                      onTap: () {
                        // Share trip
                      },
                    ),
                    SizedBox(height: 12),
                    _buildSafetyTool(
                      icon: Icons.report_rounded,
                      title: 'Report Issue',
                      subtitle: 'Report a safety concern',
                      color: AppColors.warning,
                      onTap: () {
                        // Report issue
                      },
                    ),
                    SizedBox(height: 12),
                    _buildSafetyTool(
                      icon: Icons.record_voice_over_rounded,
                      title: 'Record Audio',
                      subtitle: 'Start audio recording for safety',
                      color: AppColors.info,
                      onTap: () {
                        // Start recording
                      },
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _showSafetyTools = false;
                          });
                        },
                        child: Text(
                          'Close',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSafetyTool({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textTertiary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}