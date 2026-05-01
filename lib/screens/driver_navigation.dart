import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridesync_app/utils/colors.dart'; 
import 'package:ridesync_app/widgets/map_display.dart'; 
import 'package:ridesync_app/widgets/primary_button.dart'; 

class DriverNavigation extends StatefulWidget {
  const DriverNavigation({super.key});

  @override
  State<DriverNavigation> createState() => _DriverNavigationState();
}

class _DriverNavigationState extends State<DriverNavigation> {
  GoogleMapController? _mapController;
  int _currentInstructionIndex = 0;
  TripPhase _currentPhase = TripPhase.toPickup;
  
  final Set<Marker> _markers = {
    Marker(
      markerId: const MarkerId('driver'),
      position: const LatLng(37.7849, -122.4094),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: const InfoWindow(title: 'Your Location'),
    ),
    Marker(
      markerId: const MarkerId('pickup'),
      position: const LatLng(37.7749, -122.4194),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: const InfoWindow(title: 'Pickup', snippet: '123 Main Street'),
    ),
    Marker(
      markerId: const MarkerId('dropoff'),
      position: const LatLng(37.7649, -122.4294),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: const InfoWindow(title: 'Dropoff', snippet: '456 Market Street'),
    ),
  };
  
  final Set<Polyline> _polylines = {
    Polyline(
      polylineId: const PolylineId('route'),
      points: [
        const LatLng(37.7849, -122.4094),
        const LatLng(37.7799, -122.4144),
        const LatLng(37.7749, -122.4194),
        const LatLng(37.7699, -122.4244),
        const LatLng(37.7649, -122.4294),
      ],
      color: AppColors.primary,
      width: 5,
    ),
  };

  final List<NavigationInstruction> _instructions = [
    NavigationInstruction(
      distance: '0.2 mi',
      duration: '1 min',
      instruction: 'Head north on Market Street',
      distanceMeters: 320,
    ),
    NavigationInstruction(
      distance: '0.5 mi',
      duration: '2 min',
      instruction: 'Turn right onto 5th Street',
      distanceMeters: 800,
    ),
    NavigationInstruction(
      distance: '0.3 mi',
      duration: '1 min',
      instruction: 'Turn left onto Main Street',
      distanceMeters: 480,
    ),
    NavigationInstruction(
      distance: '150 ft',
      duration: '30 sec',
      instruction: 'Arrive at destination on the right',
      distanceMeters: 45,
    ),
  ];

  final String _riderName = 'Alice M.';
  final String _pickupLocation = '123 Main Street, San Francisco';
  final String _dropoffLocation = '456 Market Street, San Francisco';
  final String _estimatedArrival = '4 min';
  final double _tripFare = 18.50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapDisplay(
            initialPosition: const LatLng(37.7849, -122.4094),
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (controller) => _mapController = controller,
            showMyLocation: true,
            enableMyLocationButton: false,
            padding: 200,
          ),
          SafeArea(
            child: Column(
              children: [
                _buildCancelButton(),
                const Spacer(),
                _buildNavigationInfo(),
                _buildCurrentInstruction(),
                _buildInstructionList(),
                _buildEndTripButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
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
            child: IconButton(
              icon: Icon(Icons.close, color: AppColors.textPrimary),
              onPressed: () => _showCancelDialog(),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(230),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer, size: 16, color: AppColors.textOnPrimary),
                const SizedBox(width: 4),
                Text(
                  _estimatedArrival,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withAlpha(77),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary,
                child: Text(
                  _riderName.substring(0, 1),
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _riderName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: AppColors.starFilled),
                        const SizedBox(width: 2),
                        Text(
                          '4.9',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${_tripFare.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _currentPhase == TripPhase.toPickup
                          ? AppColors.info.withAlpha(26)
                          : AppColors.success.withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _currentPhase == TripPhase.toPickup ? 'To Pickup' : 'In Trip',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _currentPhase == TripPhase.toPickup
                            ? AppColors.info
                            : AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pickup',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            _pickupLocation,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 4),
                  width: 2,
                  height: 16,
                  color: AppColors.grey300,
                ),
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dropoff',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            _dropoffLocation,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentInstruction() {
    final current = _instructions[_currentInstructionIndex];
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(77),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.textOnPrimary.withAlpha(51),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${_currentInstructionIndex + 1}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textOnPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  current.instruction,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textOnPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.straighten,
                      size: 14,
                      color: AppColors.textOnPrimary.withAlpha(204),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      current.distance,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textOnPrimary.withAlpha(204),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textOnPrimary.withAlpha(204),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      current.duration,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textOnPrimary.withAlpha(204),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: Icon(Icons.chevron_right, color: AppColors.textOnPrimary),
                onPressed: _currentInstructionIndex < _instructions.length - 1
                    ? () => setState(() => _currentInstructionIndex++)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _instructions.length,
        itemBuilder: (context, index) {
          final instruction = _instructions[index];
          final isActive = index == _currentInstructionIndex;
          
          return GestureDetector(
            onTap: () => setState(() => _currentInstructionIndex = index),
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primaryLight.withAlpha(51) : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive ? AppColors.primary : AppColors.borderLight,
                  width: isActive ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.navigation,
                        size: 16,
                        color: isActive ? AppColors.primary : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        instruction.distance,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isActive ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    instruction.instruction,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEndTripButton() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: PrimaryButton(
              text: _currentPhase == TripPhase.toPickup ? 'Arrived at Pickup' : 'End Trip',
              onPressed: () => _handleTripAction(),
              icon: _currentPhase == TripPhase.toPickup ? Icons.check_circle : Icons.flag,
              variant: ButtonVariant.primary,
            ),
          ),
          const SizedBox(width: 12),
          Container(
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
            child: Column(
              children: [
                IconButton(
                  icon: Icon(Icons.chat_bubble_outline, color: AppColors.primary),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.phone, color: AppColors.success),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleTripAction() {
    if (_currentPhase == TripPhase.toPickup) {
      setState(() {
        _currentPhase = TripPhase.inTrip;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Marked as picked up - trip in progress'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      _showEndTripDialog();
    }
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Cancel Trip?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'Are you sure you want to cancel this trip? This may affect your acceptance rate.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No', style: TextStyle(color: AppColors.primary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Yes, Cancel', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showEndTripDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'End Trip?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trip fare: \$${_tripFare.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This will complete the trip and process the payment.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Trip completed! Payment processed.'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: Text('End Trip', style: TextStyle(color: AppColors.textOnPrimary)),
          ),
        ],
      ),
    );
  }
}

enum TripPhase { toPickup, inTrip }

class NavigationInstruction {
  final String distance;
  final String duration;
  final String instruction;
  final int distanceMeters;

  NavigationInstruction({
    required this.distance,
    required this.duration,
    required this.instruction,
    required this.distanceMeters,
  });
}