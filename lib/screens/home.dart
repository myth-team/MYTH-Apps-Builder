import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridenow_go_app/models/location.dart'; 
import 'package:ridenow_go_app/models/ride.dart'; 
import 'package:ridenow_go_app/services/location_service.dart'; 
import 'package:ridenow_go_app/services/ride_service.dart'; 
import 'package:ridenow_go_app/utils/colors.dart'; 
import 'package:ridenow_go_app/widgets/map_marker.dart'; 
import 'package:ridenow_go_app/widgets/ride_type_card.dart'; 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  final LocationService _locationService = LocationService.instance;
  final RideService _rideService = RideService.instance;

  LocationModel? _currentLocation;
  LocationModel? _selectedDestination;
  RideType _selectedRideType = RideType.economy;
  bool _isLoadingLocation = true;
  bool _isSearchingDestination = false;
  bool _showRideSheet = false;
  List<LocationModel> _searchResults = [];
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _pickupController = TextEditingController();

  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  StreamSubscription? _locationSubscription;
  StreamSubscription? _nearbyDriversSubscription;

  List<DriverMapMarkerData> _nearbyDrivers = [];

  double? _estimatedFare;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    final location = await _locationService.getCurrentPosition();
    if (location != null) {
      setState(() {
        _currentLocation = location;
        _isLoadingLocation = false;
        _pickupController.text = location.shortDisplay;
      });

      _locationService.startTracking();
      _locationSubscription = _locationService.locationStream.listen((loc) {
        setState(() {
          _currentLocation = loc;
        });
        _updateUserMarker();
      });

      _startNearbyDriversPolling();
    } else {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  void _startNearbyDriversPolling() {
    if (_currentLocation == null) return;

    _rideService.startNearbyDriversPolling(_currentLocation!);
    _nearbyDriversSubscription = _rideService.nearbyDriversStream.listen((drivers) {
      setState(() {
        _nearbyDrivers = drivers.map((d) => DriverMapMarkerData(
          id: d.id,
          latLng: LatLng(
            d.currentLocation!.latitude,
            d.currentLocation!.longitude,
          ),
          heading: 0,
        )).toList();
      });
      _updateMarkers();
    });
  }

  void _updateUserMarker() {
    if (_currentLocation == null) return;

    setState(() {
      _markers = {
        Marker(
          markerId: MarkerId('user_location'),
          position: LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: InfoWindow(title: 'Your Location'),
        ),
      };

      if (_selectedDestination != null) {
        _markers.add(Marker(
          markerId: MarkerId('destination'),
          position: LatLng(_selectedDestination!.latitude, _selectedDestination!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: _selectedDestination!.shortDisplay),
        ));
      }
    });
  }

  void _updateMarkers() {
    _updateUserMarker();

    for (var driver in _nearbyDrivers) {
      _markers.add(Marker(
        markerId: MarkerId(driver.id),
        position: driver.latLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ));
    }
  }

  Future<void> _searchDestinations(String query) async {
    if (query.trim().length < 2) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearchingDestination = true;
    });

    final results = await _locationService.searchLocations(query);

    setState(() {
      _searchResults = results;
      _isSearchingDestination = false;
    });
  }

  void _selectDestination(LocationModel location) {
    setState(() {
      _selectedDestination = location;
      _destinationController.text = location.shortDisplay;
      _searchResults = [];
      _showRideSheet = true;
    });

    _updateMarkers();
    _calculateFareEstimate();

    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            _currentLocation!.latitude < location.latitude
                ? _currentLocation!.latitude
                : location.latitude,
            _currentLocation!.longitude < location.longitude
                ? _currentLocation!.longitude
                : location.longitude,
          ),
          northeast: LatLng(
            _currentLocation!.latitude > location.latitude
                ? _currentLocation!.latitude
                : location.latitude,
            _currentLocation!.longitude > location.longitude
                ? _currentLocation!.longitude
                : location.longitude,
          ),
        ),
        100,
      ),
    );
  }

  void _calculateFareEstimate() {
    if (_currentLocation == null || _selectedDestination == null) return;

    final fare = _rideService.calculateFareEstimate(
      type: _selectedRideType,
      pickup: _currentLocation!,
      destination: _selectedDestination!,
    );

    setState(() {
      _estimatedFare = fare;
    });
  }

  void _onRideTypeSelected(RideType type) {
    setState(() {
      _selectedRideType = type;
    });
    _calculateFareEstimate();
  }

  Future<void> _requestRide() async {
    if (_currentLocation == null || _selectedDestination == null) return;

    final ride = await _rideService.requestRide(
      type: _selectedRideType,
      pickup: _currentLocation!,
      destination: _selectedDestination!,
    );

    if (mounted) {
      Navigator.of(context).pushNamed('/ride_request', arguments: ride);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_currentLocation != null) {
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
          15,
        ),
      );
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _locationSubscription?.cancel();
    _nearbyDriversSubscription?.cancel();
    _destinationController.dispose();
    _pickupController.dispose();
    _rideService.stopNearbyDriversPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(),
          _buildTopBar(),
          _buildLocationButton(),
          if (_showRideSheet)
            _buildRideBottomSheet()
          else
            _buildDestinationSearchSheet(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    if (_isLoadingLocation) {
      return Container(
        color: AppColors.neutral100,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              SizedBox(height: 16),
              Text(
                'Getting your location...',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          _currentLocation?.latitude ?? 37.7749,
          _currentLocation?.longitude ?? -122.4194,
        ),
        zoom: 15,
      ),
      markers: _markers,
      circles: _circles,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            _buildMenuButton(),
            Spacer(),
            _buildProfileButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(12),
            child: Icon(
              Icons.menu_rounded,
              color: AppColors.textPrimary,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed('/profile');
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(12),
            child: Icon(
              Icons.person_outline_rounded,
              color: AppColors.textPrimary,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationButton() {
    return Positioned(
      right: 16,
      bottom: _showRideSheet ? 420 : 280,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (_currentLocation != null) {
                _mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
                    15,
                  ),
                );
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(12),
              child: Icon(
                Icons.my_location_rounded,
                color: AppColors.primary,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationSearchSheet() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowStrong,
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSheetHandle(),
            _buildSearchFields(),
            if (_searchResults.isNotEmpty) _buildSearchResults(),
            if (_searchResults.isEmpty) _buildQuickDestinations(),
          ],
        ),
      ),
    );
  }

  Widget _buildRideBottomSheet() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowStrong,
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSheetHandle(),
            _buildRouteSummary(),
            _buildRideTypeSelector(),
            _buildFareEstimate(),
            _buildRequestButton(),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSheetHandle() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 12, bottom: 16),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.neutral300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildSearchFields() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildPickupField(),
          SizedBox(height: 12),
          _buildDestinationField(),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPickupField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _pickupController,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Current Location',
                hintStyle: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 15,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.destinationPin,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _destinationController,
              onChanged: _searchDestinations,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Where to?',
                hintStyle: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 15,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_isSearchingDestination)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Container(
      constraints: BoxConstraints(maxHeight: 280),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final result = _searchResults[index];
          return _buildSearchResultItem(result);
        },
      ),
    );
  }

  Widget _buildSearchResultItem(LocationModel location) {
    return InkWell(
      onTap: () => _selectDestination(location),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.location_on_outlined,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.shortDisplay,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    location.address,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
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
  }

  Widget _buildQuickDestinations() {
    final quickDestinations = [
      {'icon': Icons.home_rounded, 'label': 'Home', 'color': AppColors.primary},
      {'icon': Icons.work_outline_rounded, 'label': 'Work', 'color': AppColors.secondary},
      {'icon': Icons.star_rounded, 'label': 'Saved', 'color': AppColors.warning},
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Row(
        children: quickDestinations.map((dest) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: InkWell(
                onTap: () {
                  // Handle quick destination
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        dest['icon'] as IconData,
                        color: dest['color'] as Color,
                        size: 24,
                      ),
                      SizedBox(height: 8),
                      Text(
                        dest['label'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRouteSummary() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppColors.buildGradient(AppColors.primaryGradient),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentLocation?.shortDisplay ?? 'Your Location',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        _selectedDestination?.shortDisplay ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _showRideSheet = false;
                      _selectedDestination = null;
                      _destinationController.clear();
                      _estimatedFare = null;
                    });
                    _updateMarkers();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRideTypeSelector() {
    final options = [
      RideTypeCardData(
        type: RideType.economy,
        price: _estimatedFare,
        etaMinutes: 3,
        capacity: 4,
      ),
      RideTypeCardData(
        type: RideType.premium,
        price: _estimatedFare != null ? _estimatedFare! * 1.8 : null,
        etaMinutes: 5,
        capacity: 4,
      ),
      RideTypeCardData(
        type: RideType.shared,
        price: _estimatedFare != null ? _estimatedFare! * 0.6 : null,
        etaMinutes: 8,
        capacity: 4,
      ),
      RideTypeCardData(
        type: RideType.xl,
        price: _estimatedFare != null ? _estimatedFare! * 1.4 : null,
        etaMinutes: 6,
        capacity: 6,
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: RideTypeSelector(
        options: options,
        selectedType: _selectedRideType,
        onTypeSelected: _onRideTypeSelected,
      ),
    );
  }

  Widget _buildFareEstimate() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Estimated fare',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _estimatedFare != null
                    ? '\$${_estimatedFare!.toStringAsFixed(2)}'
                    : '--',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 16,
                  color: AppColors.success,
                ),
                SizedBox(width: 6),
                Text(
                  '3 min',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: AppColors.buildGradient(AppColors.primaryGradient),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _requestRide,
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: Text(
                'Request ${_selectedRideType.name[0].toUpperCase()}${_selectedRideType.name.substring(1)}',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DriverMapMarkerData {
  final String id;
  final LatLng latLng;
  final double heading;

  DriverMapMarkerData({
    required this.id,
    required this.latLng,
    required this.heading,
  });
}