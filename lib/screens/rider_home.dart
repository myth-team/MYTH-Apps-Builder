import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:new_project_app/utils/colors.dart'; 
import 'package:new_project_app/providers/ride_provider.dart';
import 'package:new_project_app/providers/auth_provider.dart';
import 'package:new_project_app/widgets/ride_state_chip.dart'; 

class RiderHomeScreen extends StatefulWidget {
  const RiderHomeScreen({Key? key}) : super(key: key);

  @override
  State<RiderHomeScreen> createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  late AnimationController _sheetController;
  late Animation<double> _sheetSlideAnim;

  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropoffController = TextEditingController();

  bool _isPickupFocused = false;
  bool _isDropoffFocused = false;
  bool _showSearchResults = false;
  String _searchQuery = '';
  bool _sheetExpanded = false;

  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 14.5,
  );

  final List<Map<String, String>> _mockPlaces = [
    {
      'primary': 'San Francisco International Airport',
      'secondary': 'San Francisco, CA',
      'placeId': 'sfo_001',
    },
    {
      'primary': 'Union Square',
      'secondary': 'Powell St, San Francisco, CA',
      'placeId': 'sq_002',
    },
    {
      'primary': 'Fisherman\'s Wharf',
      'secondary': 'The Embarcadero, San Francisco, CA',
      'placeId': 'fw_003',
    },
    {
      'primary': 'Golden Gate Park',
      'secondary': 'San Francisco, CA',
      'placeId': 'ggp_004',
    },
    {
      'primary': 'Caltrain Station',
      'secondary': '700 4th St, San Francisco, CA',
      'placeId': 'cs_005',
    },
    {
      'primary': 'Oracle Park',
      'secondary': '24 Willie Mays Plaza, San Francisco, CA',
      'placeId': 'op_006',
    },
  ];

  List<Map<String, String>> get _filteredPlaces {
    if (_searchQuery.isEmpty) return _mockPlaces;
    return _mockPlaces.where((p) {
      final q = _searchQuery.toLowerCase();
      return p['primary']!.toLowerCase().contains(q) ||
          p['secondary']!.toLowerCase().contains(q);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _sheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _sheetSlideAnim = CurvedAnimation(
      parent: _sheetController,
      curve: Curves.easeOutCubic,
    );
    _sheetController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ride = context.read<RideProvider>();
      ride.startNearbyDriverSimulation();
    });
  }

  @override
  void dispose() {
    _sheetController.dispose();
    _pickupController.dispose();
    _dropoffController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Set<Marker> _buildMarkers(RideProvider ride) {
    final markers = <Marker>{};
    for (final driver in ride.nearbyDrivers) {
      markers.add(
        Marker(
          markerId: MarkerId(driver.uid),
          position: driver.position,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            _vehicleHue(driver.vehicleType),
          ),
          infoWindow: InfoWindow(title: _vehicleLabel(driver.vehicleType)),
        ),
      );
    }
    if (ride.pickupLocation != null) {
      markers.add(
        Marker(
          markerId: MarkerId('pickup'),
          position: ride.pickupLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: 'Pickup'),
        ),
      );
    }
    if (ride.dropoffLocation != null) {
      markers.add(
        Marker(
          markerId: MarkerId('dropoff'),
          position: ride.dropoffLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: 'Drop-off'),
        ),
      );
    }
    return markers;
  }

  double _vehicleHue(VehicleType type) {
    switch (type) {
      case VehicleType.economy:
        return BitmapDescriptor.hueBlue;
      case VehicleType.luxury:
        return BitmapDescriptor.hueViolet;
      case VehicleType.xl:
        return BitmapDescriptor.hueCyan;
    }
  }

  String _vehicleLabel(VehicleType type) {
    switch (type) {
      case VehicleType.economy:
        return 'Economy';
      case VehicleType.luxury:
        return 'Luxury';
      case VehicleType.xl:
        return 'XL';
    }
  }

  void _onPlaceSelected(Map<String, String> place, bool isPickup) {
    final ride = context.read<RideProvider>();
    final result = PlaceResult(
      placeId: place['placeId']!,
      primaryText: place['primary']!,
      secondaryText: place['secondary']!,
      latLng: LatLng(
        37.7749 + (place['placeId'].hashCode % 100) * 0.001,
        -122.4194 + (place['placeId'].hashCode % 100) * 0.001,
      ),
    );

    if (isPickup) {
      ride.setPickupPlace(result);
      _pickupController.text = place['primary']!;
    } else {
      ride.setDropoffPlace(result);
      _dropoffController.text = place['primary']!;
    }

    setState(() {
      _showSearchResults = false;
      _isPickupFocused = false;
      _isDropoffFocused = false;
      _searchQuery = '';
    });

    FocusScope.of(context).unfocus();

    if (ride.hasPickup && ride.hasDropoff) {
      _navigateToVehicleSelect();
    }
  }

  void _navigateToVehicleSelect() {
    Navigator.of(context).pushNamed('/rider_vehicle_select');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          _buildMap(),
          _buildTopBar(),
          _buildBottomSheet(),
          if (_showSearchResults) _buildSearchResults(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return Consumer<RideProvider>(
      builder: (context, ride, _) {
        return GoogleMap(
          initialCameraPosition: _initialCamera,
          onMapCreated: (controller) {
            _mapController = controller;
          },
          markers: _buildMarkers(ride),
          polylines: ride.routePolylines,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          compassEnabled: false,
          mapToolbarEnabled: false,
          onTap: (_) {
            setState(() {
              _showSearchResults = false;
              _isPickupFocused = false;
              _isDropoffFocused = false;
            });
            FocusScope.of(context).unfocus();
          },
        );
      },
    );
  }

  Widget _buildTopBar() {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: auth.currentUser?.avatarUrl != null
                      ? ClipOval(
                          child: Image.network(
                            auth.currentUser!.avatarUrl!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.person_rounded,
                          color: AppColors.white,
                          size: 22,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Good day, ${auth.currentUser?.name?.split(' ').first ?? 'Rider'}!',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.grey900,
                        ),
                      ),
                      Text(
                        'Where are you going?',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildIconButton(
                  icon: Icons.notifications_rounded,
                  onTap: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowNeutral,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.grey700, size: 22),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return AnimatedBuilder(
      animation: _sheetSlideAnim,
      builder: (context, child) {
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(_sheetSlideAnim),
            child: child,
          ),
        );
      },
      child: Consumer<RideProvider>(
        builder: (context, ride, _) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowDark,
                  blurRadius: 30,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSheetHandle(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Book a Ride',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.grey900,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildLocationFields(ride),
                      const SizedBox(height: 16),
                      if (ride.hasPickup && ride.hasDropoff)
                        _buildConfirmButton()
                      else
                        _buildQuickDestinations(),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSheetHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 14, bottom: 18),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.grey300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildLocationFields(RideProvider ride) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          _buildLocationInput(
            controller: _pickupController,
            hint: 'Pickup location',
            icon: Icons.radio_button_checked_rounded,
            iconColor: AppColors.mapPickup,
            isFocused: _isPickupFocused,
            isPickup: true,
            value: ride.pickupPlace?.primaryText,
            onTap: () {
              setState(() {
                _isPickupFocused = true;
                _isDropoffFocused = false;
                _showSearchResults = true;
                _searchQuery = _pickupController.text;
              });
            },
            onChanged: (v) {
              setState(() {
                _searchQuery = v;
                _showSearchResults = true;
              });
            },
            onClear: () {
              ride.clearPickup();
              _pickupController.clear();
              setState(() {
                _searchQuery = '';
              });
            },
          ),
          Divider(height: 1, color: AppColors.borderLight, indent: 48),
          _buildLocationInput(
            controller: _dropoffController,
            hint: 'Where to?',
            icon: Icons.location_on_rounded,
            iconColor: AppColors.mapDropoff,
            isFocused: _isDropoffFocused,
            isPickup: false,
            value: ride.dropoffPlace?.primaryText,
            onTap: () {
              setState(() {
                _isDropoffFocused = true;
                _isPickupFocused = false;
                _showSearchResults = true;
                _searchQuery = _dropoffController.text;
              });
            },
            onChanged: (v) {
              setState(() {
                _searchQuery = v;
                _showSearchResults = true;
              });
            },
            onClear: () {
              ride.clearDropoff();
              _dropoffController.clear();
              setState(() {
                _searchQuery = '';
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color iconColor,
    required bool isFocused,
    required bool isPickup,
    required String? value,
    required VoidCallback onTap,
    required Function(String) onChanged,
    required VoidCallback onClear,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                onTap: onTap,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: AppColors.grey400,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey900,
                ),
              ),
            ),
            if (value != null)
              GestureDetector(
                onTap: onClear,
                child: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: AppColors.grey400,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    final results = _filteredPlaces;
    final isPickup = _isPickupFocused;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.55,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowDark,
              blurRadius: 30,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSheetHandle(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isPickup ? 'Select Pickup' : 'Select Destination',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey900,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showSearchResults = false;
                      });
                      FocusScope.of(context).unfocus();
                    },
                    child: Icon(Icons.close_rounded, color: AppColors.grey500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shrinkWrap: true,
                itemCount: results.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: AppColors.borderLight),
                itemBuilder: (context, i) {
                  final place = results[i];
                  return InkWell(
                    onTap: () => _onPlaceSelected(place, isPickup),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: AppColors.primarySurface,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.place_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  place['primary']!,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.grey900,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  place['secondary']!,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: AppColors.grey500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickDestinations() {
    final destinations = [
      {'label': 'Home', 'icon': Icons.home_rounded, 'address': '123 Main St'},
      {'label': 'Work', 'icon': Icons.work_rounded, 'address': '456 Market St'},
      {'label': 'Airport', 'icon': Icons.flight_rounded, 'address': 'SFO Airport'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Destinations',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.grey600,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: destinations.map((d) {
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  _dropoffController.text = d['label'] as String;
                  setState(() {
                    _searchQuery = d['label'] as String;
                    _isDropoffFocused = true;
                    _showSearchResults = true;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(
                    right: destinations.indexOf(d) < destinations.length - 1 ? 8 : 0,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        d['icon'] as IconData,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        d['label'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return GestureDetector(
      onTap: _navigateToVehicleSelect,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_rounded, color: AppColors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              'Find a Ride',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}