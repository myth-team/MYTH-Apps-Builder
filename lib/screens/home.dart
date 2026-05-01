import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ridenow_app/utils/colors.dart'; 
import 'package:ridenow_app/models/location.dart' as app;
import 'package:ridenow_app/models/ride.dart'; 
import 'package:ridenow_app/widgets/map_widget.dart'; 
import 'package:ridenow_app/widgets/ride_option_card.dart'; 
import 'package:ridenow_app/services/location_service.dart'; 
import 'package:ridenow_app/services/ride_service.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  app.Location? _selectedPickup;
  app.Location? _selectedDestination;
  RideType? _selectedRideType;
  Map<RideType, RideEstimate>? _rideEstimates;
  bool _isEstimating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initLocation();
    });
  }

  Future<void> _initLocation() async {
    final locationService = context.read<LocationService>();
    await locationService.getCurrentLocation();
  }

  Future<void> _getEstimates() async {
    if (_selectedPickup == null || _selectedDestination == null) return;

    setState(() {
      _isEstimating = true;
    });

    final rideService = context.read<RideService>();
    final estimates = await rideService.getRideEstimates(
      pickup: _selectedPickup!,
      destination: _selectedDestination!,
    );

    setState(() {
      _rideEstimates = estimates;
      _isEstimating = false;
      if (estimates.isNotEmpty) {
        _selectedRideType = estimates.keys.first;
      }
    });
  }

  Future<void> _bookRide() async {
    if (_selectedPickup == null || _selectedDestination == null || _selectedRideType == null) return;

    final rideService = context.read<RideService>();
    final ride = await rideService.createRide(
      pickup: _selectedPickup!,
      destination: _selectedDestination!,
      rideType: _selectedRideType!,
    );

    if (ride != null && mounted) {
      Navigator.pushNamed(context, '/ride_detail');
    }
  }

  void _swapLocations() {
    setState(() {
      final temp = _selectedPickup;
      _selectedPickup = _selectedDestination;
      _selectedDestination = temp;

      final tempController = _pickupController.text;
      _pickupController.text = _destinationController.text;
      _destinationController.text = tempController;

      _rideEstimates = null;
      _selectedRideType = null;
    });
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(),
          _buildSearchPanel(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return Consumer<LocationService>(
      builder: (context, locationService, child) {
        return MapWidget(
          currentLocation: locationService.currentLocation,
          pickupLocation: _selectedPickup,
          destinationLocation: _selectedDestination,
          showCurrentLocation: true,
        );
      },
    );
  }

  Widget _buildSearchPanel() {
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.25,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 20,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDragHandle(),
                SizedBox(height: 20),
                _buildSearchInputs(),
                if (_selectedPickup != null && _selectedDestination != null) ...[
                  SizedBox(height: 20),
                  _buildRideOptions(),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildSearchInputs() {
    return Column(
      children: [
        _buildLocationField(
          controller: _pickupController,
          label: 'Pickup',
          hint: 'Where to pick up?',
          icon: Icons.my_location,
          iconColor: AppColors.success,
          onChanged: (value) {
            setState(() {
              _selectedPickup = value.isNotEmpty
                  ? app.Location(
                      latitude: 37.7749,
                      longitude: -122.4194,
                      address: value,
                    )
                  : null;
              _rideEstimates = null;
              _selectedRideType = null;
            });
            if (_selectedPickup != null && _selectedDestination != null) {
              _getEstimates();
            }
          },
        ),
        Container(
          margin: EdgeInsets.only(left: 20),
          height: 30,
          child: VerticalDivider(
            width: 2,
            color: AppColors.border,
            indent: 8,
            endIndent: 8,
          ),
        ),
        _buildLocationField(
          controller: _destinationController,
          label: 'Destination',
          hint: 'Where to?',
          icon: Icons.location_on,
          iconColor: AppColors.error,
          onChanged: (value) {
            setState(() {
              _selectedDestination = value.isNotEmpty
                  ? app.Location(
                      latitude: 37.7849,
                      longitude: -122.4094,
                      address: value,
                    )
                  : null;
              _rideEstimates = null;
              _selectedRideType = null;
            });
            if (_selectedPickup != null && _selectedDestination != null) {
              _getEstimates();
            }
          },
        ),
      ],
    );
  }

  Widget _buildLocationField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color iconColor,
    required Function(String) onChanged,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: iconColor),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildRideOptions() {
    if (_isEstimating) {
      return Container(
        padding: EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              SizedBox(height: 16),
              Text(
                'Getting estimates...',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_rideEstimates == null || _rideEstimates!.isEmpty) {
      return Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            'Unable to get estimates for this route',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Choose Ride',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            IconButton(
              onPressed: _swapLocations,
              icon: Icon(Icons.swap_vert, color: AppColors.primary),
            ),
          ],
        ),
        SizedBox(height: 12),
        ..._rideEstimates!.entries.map((entry) {
          final estimate = entry.value;
          return RideOptionCard(
            rideType: entry.key,
            estimatedPrice: estimate.estimatedPrice,
            estimatedDuration: estimate.estimatedDuration,
            distance: estimate.distance,
            isSelected: _selectedRideType == entry.key,
            availableDrivers: estimate.availableDrivers,
            onTap: () {
              setState(() {
                _selectedRideType = entry.key;
              });
            },
          );
        }),
        if (_selectedRideType != null) ...[
          SizedBox(height: 16),
          _buildBookButton(),
        ],
      ],
    );
  }

  Widget _buildBookButton() {
    final estimate = _rideEstimates?[_selectedRideType];
    if (estimate == null) return SizedBox.shrink();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _bookRide,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car, size: 22),
            SizedBox(width: 8),
            Text(
              'Book ${_selectedRideType!.name.toUpperCase()}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 8),
            Text(
              estimate.formattedPrice,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}