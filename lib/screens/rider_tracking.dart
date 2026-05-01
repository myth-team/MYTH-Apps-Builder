import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridesync_app/utils/colors.dart'; 
import 'package:ridesync_app/widgets/map_display.dart'; 
import 'package:ridesync_app/widgets/primary_button.dart'; 
import 'package:google_fonts/google_fonts.dart';

class RiderTrackingScreen extends StatefulWidget {
  final String driverName;
  final String driverRating;
  final String vehicleInfo;
  final String licensePlate;
  final String pickupLocation;
  final String dropoffLocation;
  final int etaMinutes;
  final double distanceKm;
  final Function(String) onContactDriver;
  final VoidCallback onCancelTrip;
  final VoidCallback onTripCompleted;

  const RiderTrackingScreen({
    super.key,
    required this.driverName,
    required this.driverRating,
    required this.vehicleInfo,
    required this.licensePlate,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.etaMinutes,
    required this.distanceKm,
    required this.onContactDriver,
    required this.onCancelTrip,
    required this.onTripCompleted,
  });

  @override
  State<RiderTrackingScreen> createState() => _RiderTrackingScreenState();
}

class _RiderTrackingScreenState extends State<RiderTrackingScreen> 
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _showCancelConfirmation = false;
  int _currentEta = 0;
  bool _isDriverArrived = false;

  @override
  void initState() {
    super.initState();
    _currentEta = widget.etaMinutes;
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _simulateEtaUpdate();
  }

  void _simulateEtaUpdate() {
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && _currentEta > 0) {
        setState(() {
          _currentEta = _currentEta > 1 ? _currentEta - 1 : 0;
          if (_currentEta == 0) {
            _isDriverArrived = true;
          }
        });
        _simulateEtaUpdate();
      }
    });
  }

  Set<Marker> _buildMarkers() {
    return {
      MapMarkerHelper.createPickupMarker(
        position: const LatLng(37.7849, -122.4094),
      ),
      MapMarkerHelper.createDropoffMarker(
        position: const LatLng(37.7749, -122.4194),
      ),
      Marker(
        markerId: const MarkerId('driver'),
        position: const LatLng(37.7799, -122.4144),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: widget.driverName, snippet: 'Your driver'),
        rotation: 45.0,
      ),
    };
  }

  Set<Polyline> _buildPolylines() {
    return {
      MapMarkerHelper.createRoutePolyline(
        points: [
          const LatLng(37.7799, -122.4144),
          const LatLng(37.7849, -122.4094),
          const LatLng(37.7749, -122.4194),
        ],
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapDisplay(
            initialPosition: const LatLng(37.7799, -122.4144),
            markers: _buildMarkers(),
            polylines: _buildPolylines(),
            showMyLocation: true,
            enableMyLocationButton: true,
            zoomControlsEnabled: false,
          ),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                const Spacer(),
                _buildEtaCard(),
                _buildDriverInfoCard(),
                _buildContactButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _showCancelConfirmation = true;
              });
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey300.withAlpha(77),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.close,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const Spacer(),
          if (!_isDriverArrived)
            _buildFindingDriverIndicator()
          else
            _buildDriverArrivedIndicator(),
        ],
      ),
    );
  }

  Widget _buildFindingDriverIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Finding driver...',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverArrivedIndicator() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.success,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.success.withAlpha(102),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppColors.textOnPrimary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Driver arrived!',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEtaCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withAlpha(77),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isDriverArrived ? 'Your ride is here!' : 'Arriving in',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          _isDriverArrived ? '0' : '$_currentEta',
                          style: GoogleFonts.poppins(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _isDriverArrived ? '' : 'min',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.straighten,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.distanceKm.toStringAsFixed(1)} km',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.pickupLocation,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
                const SizedBox(width: 12),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.dropoffLocation,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
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
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary,
            child: Text(
              widget.driverName.substring(0, 1).toUpperCase(),
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textOnPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.driverName,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    ...List.generate(5, (index) {
                      return Icon(
                        index < int.parse(widget.driverRating.split('.')[0])
                            ? Icons.star
                            : Icons.star_border,
                        size: 14,
                        color: AppColors.starFilled,
                      );
                    }),
                    const SizedBox(width: 4),
                    Text(
                      widget.driverRating,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.vehicleInfo} • ${widget.licensePlate}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '4.9 ★',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildContactButton(
              icon: Icons.chat_bubble_outline,
              label: 'Chat',
              onTap: () => widget.onContactDriver('chat'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildContactButton(
              icon: Icons.phone,
              label: 'Call',
              onTap: () => widget.onContactDriver('call'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildContactButton(
              icon: Icons.directions,
              label: 'Navigate',
              onTap: () => widget.onContactDriver('navigate'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey300.withAlpha(51),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Cancel Trip?',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to cancel this trip? A cancellation fee may apply.',
          style: GoogleFonts.poppins(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _showCancelConfirmation = false;
              });
            },
            child: Text(
              'Keep Trip',
              style: GoogleFonts.poppins(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onCancelTrip();
            },
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose;
  }
}

class MapMarkerHelper {
  static Marker createPickupMarker({
    required LatLng position,
    VoidCallback? onTap,
  }) {
    return Marker(
      markerId: const MarkerId('pickup'),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      onTap: onTap ?? () {},
    );
  }

  static Marker createDropoffMarker({
    required LatLng position,
    VoidCallback? onTap,
  }) {
    return Marker(
      markerId: const MarkerId('dropoff'),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      onTap: onTap ?? () {},
    );
  }

  static Polyline createRoutePolyline({
    required List<LatLng> points,
    Color color = AppColors.mapRouteActive,
    double width = 4.0,
  }) {
    return Polyline(
      polylineId: const PolylineId('route'),
      points: points,
      color: color,
      width: width,
      geodesic: true,
      endCap: Cap.roundCap,
      startCap: Cap.roundCap,
    );
  }
}