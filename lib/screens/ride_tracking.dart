import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_swift_app/utils/colors.dart'; 

class RideTrackingScreen extends StatefulWidget {
  const RideTrackingScreen({super.key});

  @override
  State<RideTrackingScreen> createState() => _RideTrackingScreenState();
}

class _RideTrackingScreenState extends State<RideTrackingScreen> {
  GoogleMapController? _mapController;
  bool _tripCompleted = false;
  int _rating = 0;

  final Set<Marker> _markers = {
    const Marker(markerId: MarkerId('driver'), position: LatLng(37.7849, -122.4094), icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)),
    const Marker(markerId: MarkerId('pickup'), position: LatLng(37.7749, -122.4194), icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)),
    const Marker(markerId: MarkerId('dropoff'), position: LatLng(37.7949, -122.3994), icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)),
  };

  final LatLng _driverPosition = const LatLng(37.7849, -122.4094);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _driverPosition, zoom: 14),
            markers: _markers,
            onMapCreated: (controller) => _mapController = controller,
            myLocationEnabled: true,
          ),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                const Spacer(),
                _buildTripDetails(),
              ],
            ),
          ),
          if (_tripCompleted) _buildRatingDialog(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.surface,
            child: IconButton(icon: Icon(Icons.arrow_back, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context)),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(20)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.circle, size: 8, color: Colors.white), SizedBox(width: 6), Text('On Trip', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripDetails() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 28, backgroundColor: AppColors.primaryLight, child: Icon(Icons.person, size: 32, color: AppColors.primary)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('John D.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    Text('Toyota Camry • ABC 1234', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                    Row(children: List.generate(5, (i) => Icon(Icons.star, size: 16, color: i < 4 ? AppColors.warning : AppColors.divider))),
                  ],
                ),
              ),
              Column(
                children: [
                  Icon(Icons.chat_bubble_outline, color: AppColors.primary, size: 28),
                  const SizedBox(height: 4),
                  Icon(Icons.phone, color: AppColors.primary, size: 28),
                ],
              ),
            ],
          ),
          const Divider(height: 32),
          _buildLocationRow(Icons.circle, 'Pickup', '123 Main St', AppColors.success),
          const SizedBox(height: 12),
          _buildLocationRow(Icons.location_on, 'Dropoff', '456 Oak Ave', AppColors.error),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('3 min', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    Text('ETA', style: TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.divider),
              Expanded(
                child: Column(
                  children: [
                    Text('2.4 mi', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    Text('Distance', style: TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: AppColors.textOnPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () => setState(() => _tripCompleted = true),
              child: const Text('End Trip', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow(IconData icon, String label, String address, Color color) {
    return Row(
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              Text(address, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingDialog() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Rate Your Trip', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) => GestureDetector(
                  onTap: () => setState(() => _rating = i + 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(Icons.star, size: 40, color: i < _rating ? AppColors.warning : AppColors.divider),
                  ),
                )),
              ),
              const SizedBox(height: 24),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Comments (optional)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.textOnPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () => Navigator.pushReplacementNamed(context, '/rider_home'),
                  child: const Text('Submit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}