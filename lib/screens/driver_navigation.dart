import 'package:flutter/material.dart';
import 'package:rideflow_app/utils/colors.dart'; 
import 'package:rideflow_app/theme/app_theme.dart';

class DriverNavigationScreen extends StatefulWidget {
  const DriverNavigationScreen({super.key});

  @override
  State<DriverNavigationScreen> createState() => _DriverNavigationScreenState();
}

class _DriverNavigationScreenState extends State<DriverNavigationScreen> {
  String tripStatus = 'en_route_pickup';
  
  final Map<String, dynamic> tripData = {
    'id': 'TRP-001',
    'riderName': 'Alex Johnson',
    'riderPhone': '+1 (555) 123-4567',
    'riderRating': 4.9,
    'pickup': {
      'address': '123 Main Street, Downtown',
      'lat': 37.7749,
      'lng': -122.4194,
    },
    'dropoff': {
      'address': '456 Oak Avenue, Midtown',
      'lat': 37.7849,
      'lng': -122.4094,
    },
    'fare': 15.75,
    'distance': '2.3 miles',
    'estimatedTime': '12 min',
  };

  List<Map<String, dynamic>> directions = [
    {'instruction': 'Head north on Main Street', 'distance': '0.3 mi'},
    {'instruction': 'Turn right onto Oak Avenue', 'distance': '1.2 mi'},
    {'instruction': 'Destination will be on the right', 'distance': '0.8 mi'},
  ];

  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMapPlaceholder(),
          _buildTopBar(),
          _buildTripInfoCard(),
          _buildNavigationInstructions(),
          _buildBottomActionBar(),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 150,
            left: 50,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 280,
            right: 60,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.riderMarker,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 2),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.navigation,
                  size: 80,
                  color: AppColors.primary.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'Navigation Map',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.primary.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Google Maps Navigation',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: _getStatusColor(),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _getStatusColor().withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    _getStatusIcon(),
                    size: 18,
                    color: AppColors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getStatusText(),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.phone),
                color: AppColors.success,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripInfoCard() {
    return Positioned(
      top: 90,
      left: 16,
      right: 16,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tripData['riderName'],
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 14, color: AppColors.accent),
                            const SizedBox(width: 4),
                            Text(
                              '${tripData['riderRating']} rating',
                              style: Theme.of(context).textTheme.bodySmall,
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
                        '\$${tripData['fare'].toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                      Text(
                        tripData['id'],
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Icon(Icons.trip_origin, color: AppColors.success, size: 20),
                          Container(
                            width: 2,
                            height: 20,
                            color: AppColors.divider,
                          ),
                          const Icon(Icons.location_on, color: AppColors.error, size: 20),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tripData['pickup']['address'],
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            tripData['dropoff']['address'],
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
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

  Widget _buildNavigationInstructions() {
    return Positioned(
      bottom: 140,
      left: 16,
      right: 16,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Turn-by-Turn Directions',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.directions_car, size: 16, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          tripData['distance'],
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...directions.asMap().entries.map((entry) {
                final index = entry.key;
                final direction = entry.value;
                final isActive = index == currentStep;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: isActive ? Border.all(color: AppColors.primary, width: 1) : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primary : AppColors.divider,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: isActive
                              ? const Icon(Icons.navigation, color: AppColors.white, size: 18)
                              : Text(
                                  '${index + 1}',
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              direction['instruction'],
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                                color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        direction['distance'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showCancelDialog(),
                  icon: const Icon(Icons.close, size: 20),
                  label: const Text('Cancel Trip'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () => _advanceTripStatus(),
                  icon: Icon(_getButtonIcon(), size: 20),
                  label: Text(_getButtonText()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getButtonColor(),
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (tripStatus) {
      case 'en_route_pickup':
        return AppColors.primary;
      case 'arrived_pickup':
        return AppColors.warning;
      case 'en_route_dropoff':
        return AppColors.primary;
      case 'arrived_dropoff':
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }

  IconData _getStatusIcon() {
    switch (tripStatus) {
      case 'en_route_pickup':
        return Icons.directions_car;
      case 'arrived_pickup':
        return Icons.location_on;
      case 'en_route_dropoff':
        return Icons.directions_car;
      case 'arrived_dropoff':
        return Icons.check_circle;
      default:
        return Icons.directions_car;
    }
  }

  String _getStatusText() {
    switch (tripStatus) {
      case 'en_route_pickup':
        return 'En Route';
      case 'arrived_pickup':
        return 'Arrived';
      case 'en_route_dropoff':
        return 'In Transit';
      case 'arrived_dropoff':
        return 'Complete';
      default:
        return 'En Route';
    }
  }

  Color _getButtonColor() {
    switch (tripStatus) {
      case 'en_route_pickup':
        return AppColors.success;
      case 'arrived_pickup':
        return AppColors.primary;
      case 'en_route_dropoff':
        return AppColors.success;
      case 'arrived_dropoff':
        return AppColors.accent;
      default:
        return AppColors.success;
    }
  }

  IconData _getButtonIcon() {
    switch (tripStatus) {
      case 'en_route_pickup':
        return Icons.location_on;
      case 'arrived_pickup':
        return Icons.directions_car;
      case 'en_route_dropoff':
        return Icons.flag;
      case 'arrived_dropoff':
        return Icons.receipt_long;
      default:
        return Icons.check;
    }
  }

  String _getButtonText() {
    switch (tripStatus) {
      case 'en_route_pickup':
        return 'Arrived at Pickup';
      case 'arrived_pickup':
        return 'Start Trip';
      case 'en_route_dropoff':
        return 'Complete Trip';
      case 'arrived_dropoff':
        return 'End Trip';
      default:
        return 'Continue';
    }
  }

  void _advanceTripStatus() {
    setState(() {
      switch (tripStatus) {
        case 'en_route_pickup':
          tripStatus = 'arrived_pickup';
          break;
        case 'arrived_pickup':
          tripStatus = 'en_route_dropoff';
          break;
        case 'en_route_dropoff':
          tripStatus = 'arrived_dropoff';
          break;
        case 'arrived_dropoff':
          _showCompletionDialog();
          break;
      }
    });
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Trip?'),
        content: const Text('Are you sure you want to cancel this trip? This action may affect your acceptance rate.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Trip'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Cancel Trip'),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: AppColors.success),
            ),
            const SizedBox(width: 12),
            const Text('Trip Complete!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\$${tripData['fare'].toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fare collected from ${tripData['riderName']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildRatingRow(),
                  const SizedBox(height: 12),
                  Text(
                    'Tap to rate rider',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < 5 ? Icons.star : Icons.star_border,
            color: AppColors.accent,
            size: 32,
          ),
          onPressed: () {},
        );
      }),
    );
  }
}