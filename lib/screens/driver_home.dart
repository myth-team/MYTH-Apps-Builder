import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridesync_app/utils/colors.dart'; 
import 'package:ridesync_app/widgets/map_display.dart'; 
import 'package:ridesync_app/widgets/trip_request_card.dart'; 
import 'package:ridesync_app/widgets/primary_button.dart'; 

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  bool _isOnline = false;
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  double _currentRating = 4.8;
  int _totalTrips = 1247;
  
  final List<RiderRequest> _nearbyRequests = [
    RiderRequest(
      id: '1',
      pickupLocation: '123 Main Street',
      dropoffLocation: '456 Market Street',
      distance: 0.8,
      estimatedFare: 18.50,
      estimatedTime: '3 min',
      riderName: 'Alice M.',
      riderRating: 4.9,
      passengerCount: 1,
    ),
    RiderRequest(
      id: '2',
      pickupLocation: '789 Oak Avenue',
      dropoffLocation: '101 Pine Street',
      distance: 1.2,
      estimatedFare: 25.00,
      estimatedTime: '5 min',
      riderName: 'Bob K.',
      riderRating: 4.7,
      passengerCount: 2,
    ),
    RiderRequest(
      id: '3',
      pickupLocation: '202 Broadway',
      dropoffLocation: '303 Mission Street',
      distance: 2.1,
      estimatedFare: 32.75,
      estimatedTime: '8 min',
      riderName: 'Charlie D.',
      riderRating: 5.0,
      passengerCount: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
  }

  void _initializeMarkers() {
    _markers.add(
      Marker(
        markerId: const MarkerId('driver'),
        position: const LatLng(37.7749, -122.4194),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'You are here'),
      ),
    );
  }

  void _toggleOnlineStatus() {
    setState(() {
      _isOnline = !_isOnline;
    });
  }

  void _acceptRequest(RiderRequest request) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Accepted request from ${request.riderName}'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _declineRequest(RiderRequest request) {
    setState(() {
      _nearbyRequests.removeWhere((r) => r.id == request.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapDisplay(
            initialPosition: const LatLng(37.7749, -122.4194),
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (controller) => _mapController = controller,
            showMyLocation: true,
            enableMyLocationButton: true,
            floatingActionButton: _buildOnlineToggleFAB(),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildTopStatusBar(),
                const Spacer(),
                if (_isOnline && _nearbyRequests.isNotEmpty)
                  _buildRequestCards(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopStatusBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withAlpha(77),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isOnline ? AppColors.driverOnline : AppColors.driverOffline,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _isOnline ? 'Online' : 'Offline',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _isOnline ? AppColors.driverOnline : AppColors.driverOffline,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, size: 16, color: AppColors.starFilled),
                const SizedBox(width: 4),
                Text(
                  '$_currentRating',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.directions_car, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  '$_totalTrips',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildOnlineToggleFAB() {
    return Positioned(
      right: 16,
      bottom: 180,
      child: FloatingActionButton.extended(
        onPressed: _toggleOnlineStatus,
        backgroundColor: _isOnline ? AppColors.error : AppColors.primary,
        icon: Icon(
          _isOnline ? Icons.toggle_on : Icons.toggle_off,
          color: AppColors.textOnPrimary,
        ),
        label: Text(
          _isOnline ? 'Go Offline' : 'Go Online',
          style: TextStyle(
            color: AppColors.textOnPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCards() {
    return Container(
      height: 320,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.9),
        itemCount: _nearbyRequests.length,
        itemBuilder: (context, index) {
          final request = _nearbyRequests[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TripRequestCard(
              pickupLocation: request.pickupLocation,
              dropoffLocation: request.dropoffLocation,
              distance: request.distance,
              estimatedFare: '\$${request.estimatedFare.toStringAsFixed(2)}',
              estimatedTime: request.estimatedTime,
              riderName: request.riderName,
              riderRating: request.riderRating.toString(),
              passengerCount: request.passengerCount,
              isExpanded: true,
              onAccept: () => _acceptRequest(request),
              onDecline: () => _declineRequest(request),
            ),
          );
        },
      ),
    );
  }
}

class RiderRequest {
  final String id;
  final String pickupLocation;
  final String dropoffLocation;
  final double distance;
  final double estimatedFare;
  final String estimatedTime;
  final String riderName;
  final double riderRating;
  final int passengerCount;

  RiderRequest({
    required this.id,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.distance,
    required this.estimatedFare,
    required this.estimatedTime,
    required this.riderName,
    required this.riderRating,
    required this.passengerCount,
  });
}