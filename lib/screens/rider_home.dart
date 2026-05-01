import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rideflow_app/utils/colors.dart'; 

class RiderHomeScreen extends StatefulWidget {
  const RiderHomeScreen({super.key});

  @override
  State<RiderHomeScreen> createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropoffController = TextEditingController();
  bool _isSelectingDropoff = false;
  List<Map<String, dynamic>> _nearbyDrivers = [];
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _loadNearbyDrivers();
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _dropoffController.dispose();
    super.dispose();
  }

  void _loadNearbyDrivers() {
    setState(() {
      _nearbyDrivers = [
        {'id': 1, 'name': 'John D.', 'rating': 4.8, 'distance': 0.3, 'type': 'Economy', 'lat': 37.7749, 'lng': -122.4194},
        {'id': 2, 'name': 'Sarah M.', 'rating': 4.9, 'distance': 0.5, 'type': 'Luxury', 'lat': 37.7751, 'lng': -122.4180},
        {'id': 3, 'name': 'Mike T.', 'rating': 4.7, 'distance': 0.8, 'type': 'XL', 'lat': 37.7745, 'lng': -122.4200},
        {'id': 4, 'name': 'Emma L.', 'rating': 4.6, 'distance': 1.2, 'type': 'Economy', 'lat': 37.7755, 'lng': -122.4175},
      ];
    });
  }

  void _onSearchChanged(String value) {
    if (value.length > 2) {
      setState(() {
        _searchResults = [
          {'name': 'Central Park', 'address': 'New York, NY', 'lat': 40.7829, 'lng': -73.9654},
          {'name': 'Times Square', 'address': 'New York, NY', 'lat': 40.7580, 'lng': -73.9855},
          {'name': 'Empire State Building', 'address': 'New York, NY', 'lat': 40.7484, 'lng': -73.9857},
        ];
      });
    } else {
      setState(() => _searchResults = []);
    }
  }

  void _selectPlace(Map<String, dynamic> place) {
    if (!_isSelectingDropoff) {
      _pickupController.text = place['name'];
      setState(() {
        _isSelectingDropoff = true;
        _searchResults = [];
      });
    } else {
      _dropoffController.text = place['name'];
      setState(() => _searchResults = []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            _buildMapPlaceholder(),
            _buildSearchPanel(),
            _buildBottomDriverList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMapPlaceholder() {
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
                  size: 80,
                  color: AppColors.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Map View',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Google Maps integration here',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                ..._nearbyDrivers.map((driver) => _buildDriverMarker(driver)),
              ],
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton.small(
              onPressed: () {},
              backgroundColor: AppColors.surface,
              child: const Icon(
                Icons.my_location_rounded,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverMarker(Map<String, dynamic> driver) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _getVehicleColor(driver['type']),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: AppColors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                driver['name'],
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${driver['distance']} mi away',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getVehicleColor(String type) {
    switch (type) {
      case 'Luxury':
        return AppColors.luxuryCar;
      case 'XL':
        return AppColors.xlCar;
      default:
        return AppColors.economyCar;
    }
  }

  Widget _buildSearchPanel() {
    return DraggableScrollableSheet(
      initialChildSize: 0.35,
      minChildSize: 0.2,
      maxChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildSearchField(
                controller: _pickupController,
                hint: 'Where to?',
                icon: Icons.trip_origin_rounded,
                iconColor: AppColors.success,
                onChanged: _onSearchChanged,
                isPickup: true,
              ),
              if (_searchResults.isNotEmpty) _buildSearchResults(),
              const SizedBox(height: 8),
              Divider(color: AppColors.divider, indent: 48),
              const SizedBox(height: 8),
              _buildQuickActions(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color iconColor,
    required Function(String) onChanged,
    required bool isPickup,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: iconColor),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: _searchResults.map((result) {
          return InkWell(
            onTap: () => _selectPlace(result),
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result['name'],
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          result['address'],
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionItem(
            icon: Icons.home_rounded,
            label: 'Home',
            onTap: () {},
          ),
        ),
        Expanded(
          child: _buildQuickActionItem(
            icon: Icons.work_rounded,
            label: 'Work',
            onTap: () {},
          ),
        ),
        Expanded(
          child: _buildQuickActionItem(
            icon: Icons.star_rounded,
            label: 'Saved',
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomDriverList() {
    return Positioned(
      bottom: 200,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _nearbyDrivers.length,
          itemBuilder: (context, index) {
            final driver = _nearbyDrivers[index];
            return _buildDriverCard(driver);
          },
        ),
      ),
    );
  }

  Widget _buildDriverCard(Map<String, dynamic> driver) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/rider_booking');
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _getVehicleColor(driver['type']),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.warning,
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            driver['rating'].toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              driver['name'],
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${driver['type']} • ${driver['distance']} mi',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}