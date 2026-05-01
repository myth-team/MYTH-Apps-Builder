import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_swift_app/utils/colors.dart'; 

class RiderHomeScreen extends StatefulWidget {
  const RiderHomeScreen({super.key});

  @override
  State<RiderHomeScreen> createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;
  String _selectedVehicle = 'Economy';
  double _estimatedFare = 12.50;

  final List<Map<String, dynamic>> _vehicleTypes = [
    {'type': 'Economy', 'icon': Icons.directions_car, 'multiplier': 1.0, 'capacity': 4},
    {'type': 'Comfort', 'icon': Icons.airline_seat_recline_normal, 'multiplier': 1.5, 'capacity': 4},
    {'type': 'XL', 'icon': Icons.airline_seat_recline_extra, 'multiplier': 2.0, 'capacity': 6},
    {'type': 'Premium', 'icon': Icons.directions_car_rounded, 'multiplier': 2.5, 'capacity': 3},
  ];

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initMarkers();
  }

  void _initMarkers() {
    _markers.add(Marker(markerId: MarkerId('driver1'), position: LatLng(37.7749, -122.4194), icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)));
    _markers.add(Marker(markerId: MarkerId('driver2'), position: LatLng(37.7755, -122.4200), icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)));
    _markers.add(Marker(markerId: MarkerId('driver3'), position: LatLng(37.7760, -122.4180), icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(target: LatLng(37.7749, -122.4194), zoom: 14),
            markers: _markers,
            onMapCreated: (controller) => _mapController = controller,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          SafeArea(
            child: Column(
              children: [
                _buildSearchBar(),
                const Spacer(),
                _buildVehicleSelector(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 2))]),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: AppColors.textSecondary),
          hintText: 'Where to?',
          hintStyle: TextStyle(color: AppColors.textHint),
          border: InputBorder.none,
          suffixIcon: IconButton(icon: Icon(Icons.tune, color: AppColors.textSecondary), onPressed: () {}),
        ),
      ),
    );
  }

  Widget _buildVehicleSelector() {
    final selected = _vehicleTypes.firstWhere((v) => v['type'] == _selectedVehicle);
    _estimatedFare = 12.50 * (selected['multiplier'] as double);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: const Offset(0, -2))]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$_selectedVehicle • ${selected['capacity']} seats', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              Text('\$${_estimatedFare.toStringAsFixed(2)}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _vehicleTypes.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final vehicle = _vehicleTypes[index];
                final isSelected = vehicle['type'] == _selectedVehicle;
                return GestureDetector(
                  onTap: () => setState(() => _selectedVehicle = vehicle['type']),
                  child: Container(
                    width: 80,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider, width: isSelected ? 2 : 1),
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected ? AppColors.primaryLight.withOpacity(0.2) : AppColors.background,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(vehicle['icon'], size: 28, color: isSelected ? AppColors.primary : AppColors.textSecondary),
                        const SizedBox(height: 4),
                        Text(vehicle['type'], style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? AppColors.primary : AppColors.textSecondary)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.textOnPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () => Navigator.pushNamed(context, '/ride_tracking'),
              child: const Text('Request Ride', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}