import 'package:flutter/material.dart';
import 'package:new_project_app/utils/colors.dart'; 

class RideBookingScreen extends StatefulWidget {
  @override
  _RideBookingScreenState createState() => _RideBookingScreenState();
}

class _RideBookingScreenState extends State<RideBookingScreen> {
  String _selectedRideType = 'Economy';
  final List<Map<String, dynamic>> _rideTypes = [
    {
      'name': 'Economy',
      'price': '\$18.50',
      'eta': '3 min',
      'icon': Icons.local_taxi_rounded,
      'seats': 4,
    },
    {
      'name': 'Premium',
      'price': '\$32.00',
      'eta': '5 min',
      'icon': Icons.airport_shuttle_rounded,
      'seats': 4,
    },
    {
      'name': 'Bike',
      'price': '\$12.00',
      'eta': '2 min',
      'icon': Icons.motorcycle_rounded,
      'seats': 1,
    },
    {
      'name': 'XL',
      'price': '\$45.00',
      'eta': '7 min',
      'icon': Icons.directions_car_filled_rounded,
      'seats': 6,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Map Placeholder Area
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  // Map Background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFE8EAF6),
                          Color(0xFFC5CAE9),
                          Color(0xFF9FA8DA),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map_outlined,
                            size: 64,
                            color: AppColors.primary.withOpacity(0.3),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Interactive Map View',
                            style: TextStyle(
                              color: AppColors.primary.withOpacity(0.5),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Route Line (decorative)
                  CustomPaint(
                    size: Size.infinite,
                    painter: RoutePainter(),
                  ),
                  // Pickup Pin
                  Positioned(
                    top: 120,
                    left: 80,
                    child: _buildMapPin(
                      color: AppColors.primary,
                      label: 'Pickup',
                    ),
                  ),
                  // Destination Pin
                  Positioned(
                    bottom: 180,
                    right: 60,
                    child: _buildMapPin(
                      color: AppColors.accent,
                      label: 'Drop',
                    ),
                  ),
                  // Top Bar
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: AppColors.textPrimary,
                              size: 22,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Enter destination...',
                                  style: TextStyle(
                                    color: AppColors.textTertiary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Bottom Sheet
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 30,
                    offset: Offset(0, -10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag Handle
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textTertiary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Location Inputs
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _buildLocationInput(
                          icon: Icons.trip_origin_rounded,
                          iconColor: AppColors.success,
                          label: 'Current Location',
                          value: '123 Main Street, New York',
                        ),
                        SizedBox(height: 12),
                        _buildLocationInput(
                          icon: Icons.location_on_rounded,
                          iconColor: AppColors.accent,
                          label: 'Destination',
                          value: 'Times Square, Manhattan',
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Ride Type Selection
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Ride',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              color: AppColors.textSecondary,
                              size: 18,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '1',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _rideTypes.length,
                      itemBuilder: (context, index) {
                        final ride = _rideTypes[index];
                        final isSelected = _selectedRideType == ride['name'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRideType = ride['name'];
                            });
                          },
                          child: Container(
                            width: 100,
                            margin: EdgeInsets.only(right: 12),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(20),
                              border: isSelected
                                  ? Border.all(color: AppColors.primary, width: 2)
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  ride['icon'],
                                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                  size: 32,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  ride['name'],
                                  style: TextStyle(
                                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  ride['eta'],
                                  style: TextStyle(
                                    color: AppColors.textTertiary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Payment & Price
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.credit_card_rounded,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '•••• 4242',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.textSecondary,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _rideTypes.firstWhere((r) => r['name'] == _selectedRideType)['price'],
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Total fare',
                              style: TextStyle(
                                color: AppColors.textTertiary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Book Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.local_taxi_rounded,
                              size: 22,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Confirm Ride',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapPin({required Color color, required String label}) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 4),
        Icon(
          Icons.location_on,
          color: color,
          size: 36,
        ),
      ],
    );
  }

  Widget _buildLocationInput({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.3)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(100, 160);
    path.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.3,
      size.width - 80,
      size.height - 220,
    );

    // Draw dashed line effect
    final dashPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.5)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final dashPath = Path();
    dashPath.moveTo(100, 160);
    dashPath.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.3,
      size.width - 80,
      size.height - 220,
    );

    canvas.drawPath(dashPath, dashPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}