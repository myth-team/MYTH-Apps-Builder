import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project_app/utils/colors.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  String _selectedRideType = 'Economy';

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: _buildMapPlaceholder(),
            ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 20, offset: const Offset(0, -5))],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Where to?', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 16),
                    _buildLocationInput('Pickup', _pickupController, Icons.trip_origin, AppColors.success),
                    const SizedBox(height: 12),
                    _buildLocationInput('Destination', _destinationController, Icons.location_on, AppColors.error),
                    const SizedBox(height: 24),
                    Text('Quick Rides', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                    const SizedBox(height: 12),
                    _buildRideTypesGrid(),
                    const Spacer(),
                    _buildBookRideButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      color: AppColors.surface,
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 64, color: AppColors.textSecondary.withOpacity(0.3)),
                const SizedBox(height: 8),
                Text('Map View', style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 14)),
              ],
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8)]),
              child: IconButton(
                icon: Icon(Icons.menu, color: AppColors.textPrimary),
                onPressed: () => Navigator.pushNamed(context, '/ride_history'),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInput(String hint, TextEditingController controller, IconData icon, Color iconColor) {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: controller,
        style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary),
          prefixIcon: Icon(icon, color: iconColor, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildRideTypesGrid() {
    final rideTypes = [
      {'name': 'Economy', 'price': '\$12', 'icon': Icons.eco},
      {'name': 'Comfort', 'price': '\$18', 'icon': Icons.airline_seat_recline_normal},
      {'name': 'Premium', 'price': '\$25', 'icon': Icons.star},
      {'name': 'XL', 'price': '\$30', 'icon': Icons.airport_shuttle},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 0.8, crossAxisSpacing: 8),
      itemCount: rideTypes.length,
      itemBuilder: (context, index) {
        final ride = rideTypes[index];
        final isSelected = _selectedRideType == ride['name'];
        return GestureDetector(
          onTap: () => setState(() => _selectedRideType = ride['name'] as String),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(ride['icon'] as IconData, color: isSelected ? AppColors.background : AppColors.textSecondary, size: 24),
                const SizedBox(height: 4),
                Text(ride['name'] as String, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w500, color: isSelected ? AppColors.background : AppColors.textPrimary)),
                Text(ride['price'] as String, style: GoogleFonts.poppins(fontSize: 9, color: isSelected ? AppColors.accent : AppColors.textSecondary)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookRideButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, '/driver_selection'),
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        child: Text('Book Ride', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.background)),
      ),
    );
  }
}