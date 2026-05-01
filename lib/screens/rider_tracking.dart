import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rideflow_app/utils/colors.dart'; 

class RiderTrackingScreen extends StatefulWidget {
  const RiderTrackingScreen({super.key});

  @override
  State<RiderTrackingScreen> createState() => _RiderTrackingScreenState();
}

class _RiderTrackingScreenState extends State<RiderTrackingScreen>
    with TickerProviderStateMixin {
  String _tripStatus = 'driver_assigned';
  double _driverLat = 37.7749;
  double _driverLng = -122.4194;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, String>> _tripStatusSteps = [
    {'status': 'driver_assigned', 'label': 'Driver Assigned'},
    {'status': 'driver_en_route', 'label': 'Driver En Route'},
    {'status': 'driver_arrived', 'label': 'Driver Arrived'},
    {'status': 'trip_in_progress', 'label': 'In Transit'},
    {'status': 'trip_completed', 'label': 'Completed'},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _simulateDriverMovement();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _simulateDriverMovement() async {
    while (_tripStatus != 'trip_completed') {
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        setState(() {
          _driverLat += 0.0005;
          _driverLng += 0.0005;
          _updateTripStatus();
        });
      }
    }
  }

  void _updateTripStatus() {
    switch (_tripStatus) {
      case 'driver_assigned':
        setState(() => _tripStatus = 'driver_en_route');
        break;
      case 'driver_en_route':
        if (_driverLat > 37.7760) {
          setState(() => _tripStatus = 'driver_arrived');
        }
        break;
      case 'driver_arrived':
        setState(() => _tripStatus = 'trip_in_progress');
        break;
      case 'trip_in_progress':
        if (_driverLat > 37.7780) {
          setState(() => _tripStatus = 'trip_completed');
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _buildMapView(),
          _buildStatusHeader(),
          _buildDriverInfoPanel(),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return Container(
      color: AppColors.primaryLight.withOpacity(0.3),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.map_rounded,
                  size: 100,
                  color: AppColors.primary.withOpacity(0.4),
                ),
                const SizedBox(height: 16),
                Text(
                  'Live Tracking Map',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'Driver location updates via WebSocket',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          _buildDriverMarker(),
          _buildRouteLine(),
        ],
      ),
    );
  }

  Widget _buildDriverMarker() {
    return Center(
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.directions_car_rounded,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRouteLine() {
    return Positioned(
      bottom: 300,
      left: 40,
      right: 40,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 60,
                    color: AppColors.primary,
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pickup',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 48,
                      child: VerticalDivider(
                        color: AppColors.primary.withOpacity(0.5),
                        width: 1,
                        thickness: 2,
                        indent: 4,
                        endIndent: 4,
                      ),
                    ),
                    Text(
                      'Dropoff',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '123 Main St',
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                  const SizedBox(height: 48),
                  Text(
                    'Downtown Terminal',
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusHeader() {
    return Positioned(
      top: 50,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _getStatusColor().withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getStatusIcon(),
                color: _getStatusColor(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getStatusTitle(),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _getStatusSubtitle(),
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
                color: _getStatusColor().withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _getStatusTime(),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getStatusColor(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverInfoPanel() {
    return Positioned(
      bottom: 140,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John D.',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.warning,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '4.8',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '• Toyota Camry',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
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
                    color: AppColors.primaryLight.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.phone_rounded,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoChip(
                    icon: Icons.confirmation_number_rounded,
                    label: 'ABC 1234',
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoChip(
                    icon: Icons.speed_rounded,
                    label: '5 min away',
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showCancelDialog(),
                  icon: const Icon(Icons.close_rounded),
                  label: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppColors.error),
                    foregroundColor: AppColors.error,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.chat_rounded, color: AppColors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Contact Driver',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
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

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cancel Trip?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to cancel this trip? A cancellation fee may apply.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Keep Trip',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (_tripStatus) {
      case 'driver_assigned':
        return AppColors.info;
      case 'driver_en_route':
        return AppColors.warning;
      case 'driver_arrived':
        return AppColors.success;
      case 'trip_in_progress':
        return AppColors.primary;
      case 'trip_completed':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon() {
    switch (_tripStatus) {
      case 'driver_assigned':
        return Icons.person_rounded;
      case 'driver_en_route':
        return Icons.directions_car_rounded;
      case 'driver_arrived':
        return Icons.check_circle_rounded;
      case 'trip_in_progress':
        return Icons.route_rounded;
      case 'trip_completed':
        return Icons.flag_rounded;
      default:
        return Icons.help_rounded;
    }
  }

  String _getStatusTitle() {
    switch (_tripStatus) {
      case 'driver_assigned':
        return 'Driver Assigned';
      case 'driver_en_route':
        return 'Driver En Route';
      case 'driver_arrived':
        return 'Driver Arrived';
      case 'trip_in_progress':
        return 'In Transit';
      case 'trip_completed':
        return 'Trip Completed';
      default:
        return 'Unknown';
    }
  }

  String _getStatusSubtitle() {
    switch (_tripStatus) {
      case 'driver_assigned':
        return 'John is on the way';
      case 'driver_en_route':
        return 'Arriving in 5 minutes';
      case 'driver_arrived':
        return 'Driver is waiting';
      case 'trip_in_progress':
        return 'Heading to destination';
      case 'trip_completed':
        return 'Thank you for riding!';
      default:
        return '';
    }
  }

  String _getStatusTime() {
    switch (_tripStatus) {
      case 'driver_assigned':
        return '5 min';
      case 'driver_en_route':
        return '4 min';
      case 'driver_arrived':
        return 'Now';
      case 'trip_in_progress':
        return '8 min';
      case 'trip_completed':
        return 'Done';
      default:
        return '';
    }
  }
}