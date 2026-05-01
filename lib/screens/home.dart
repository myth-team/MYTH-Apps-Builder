import 'package:flutter/material.dart';
import 'package:ridewise_go_app/utils/colors.dart'; 

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          RideBookingTab(),
          _MyTripsPlaceholder(),
          _PaymentPlaceholder(),
          _ProfilePlaceholder(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.local_taxi), label: 'Ride'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Trips'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Pay'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class RideBookingTab extends StatefulWidget {
  const RideBookingTab({super.key});

  @override
  State<RideBookingTab> createState() => _RideBookingTabState();
}

class _RideBookingTabState extends State<RideBookingTab> {
  String? _selectedRideType;
  final _pickupController = TextEditingController();
  final _destController = TextEditingController();

  final _rideTypes = [
    {'id': 'economy', 'name': 'Economy', 'price': '\$12.50', 'icon': Icons.directions_car},
    {'id': 'premium', 'name': 'Premium', 'price': '\$25.00', 'icon': Icons.directions_car_rounded},
    {'id': 'bike', 'name': 'Bike', 'price': '\$8.00', 'icon': Icons.pedal_bike},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Where to?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 20),
            _buildLocationInput('Pickup Location', _pickupController, Icons.trip_origin, AppColors.success),
            const SizedBox(height: 12),
            _buildLocationInput('Destination', _destController, Icons.location_on, AppColors.error),
            const SizedBox(height: 24),
            const Text('Select Ride', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            _buildRideTypeSelector(),
            const SizedBox(height: 24),
            _buildFareEstimate(),
            const SizedBox(height: 24),
            _buildRequestButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInput(String hint, TextEditingController controller, IconData icon, Color iconColor) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: iconColor),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.border)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildRideTypeSelector() {
    return Row(
      children: _rideTypes.map((ride) {
        final isSelected = _selectedRideType == ride['id'];
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedRideType = ride['id']),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent.withValues(alpha: 0.1) : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? AppColors.accent : AppColors.border, width: isSelected ? 2 : 1),
              ),
              child: Column(
                children: [
                  Icon(ride['icon'] as IconData, size: 28, color: isSelected ? AppColors.accent : AppColors.textSecondary),
                  const SizedBox(height: 4),
                  Text(ride['name'] as String, style: TextStyle(fontWeight: FontWeight.w600, color: isSelected ? AppColors.accent : AppColors.textPrimary)),
                  Text(ride['price'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFareEstimate() {
    if (_selectedRideType == null) return const SizedBox.shrink();
    final ride = _rideTypes.firstWhere((r) => r['id'] == _selectedRideType);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Estimated Fare', style: TextStyle(fontSize: 16, color: AppColors.textPrimary)),
          Text(ride['price'] as String, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.info)),
        ],
      ),
    );
  }

  Widget _buildRequestButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _selectedRideType != null ? () => Navigator.pushNamed(context, '/ride_tracking') : null,
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        child: const Text('Request Ride', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _MyTripsPlaceholder extends StatelessWidget {
  const _MyTripsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: AppColors.textLight),
          const SizedBox(height: 16),
          const Text('My Trips', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/my_trips'),
            child: const Text('View All Trips'),
          ),
        ],
      ),
    );
  }
}

class _PaymentPlaceholder extends StatelessWidget {
  const _PaymentPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.payment, size: 64, color: AppColors.textLight),
          const SizedBox(height: 16),
          const Text('Payment Methods', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/payment_methods'),
            child: const Text('Manage Payments'),
          ),
        ],
      ),
    );
  }
}

class _ProfilePlaceholder extends StatelessWidget {
  const _ProfilePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 64, color: AppColors.textLight),
          const SizedBox(height: 16),
          const Text('Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            child: const Text('View Profile'),
          ),
        ],
      ),
    );
  }
}