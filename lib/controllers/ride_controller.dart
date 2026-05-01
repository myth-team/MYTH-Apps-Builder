import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:ride_now_app/utils/constants.dart'; 
import 'package:ride_now_app/widgets/location_input.dart'; 
import 'package:ride_now_app/widgets/recent_ride_card.dart'; 

enum RideStatus {
  idle,
  selectingPickup,
  selectingDestination,
  selectingRideType,
  confirmingRide,
  rideConfirmed,
}

class RideController extends ChangeNotifier {
  // Current state
  RideStatus _status = RideStatus.idle;
  LocationInputData? _pickupLocation;
  LocationInputData? _destinationLocation;
  RideType? _selectedRideType;
  double _estimatedDistance = 0.0;
  int _estimatedDurationMinutes = 0;
  double _estimatedFare = 0.0;
  bool _isCalculatingFare = false;

  // Available options
  List<RideType> _availableRideTypes = [];
  List<Promotion> _promotions = [];
  List<RecentRideData> _recentRides = [];
  Promotion? _selectedPromotion;

  // Getters for state
  RideStatus get status => _status;
  LocationInputData? get pickupLocation => _pickupLocation;
  LocationInputData? get destinationLocation => _destinationLocation;
  RideType? get selectedRideType => _selectedRideType;
  double get estimatedDistance => _estimatedDistance;
  int get estimatedDurationMinutes => _estimatedDurationMinutes;
  double get estimatedFare => _estimatedFare;
  bool get isCalculatingFare => _isCalculatingFare;
  List<RideType> get availableRideTypes => _availableRideTypes;
  List<Promotion> get promotions => _promotions;
  List<RecentRideData> get recentRides => _recentRides;
  Promotion? get selectedPromotion => _selectedPromotion;

  // Computed properties
  bool get canRequestRide =>
      _pickupLocation != null &&
      _destinationLocation != null &&
      _selectedRideType != null;

  bool get hasLocationsSet =>
      _pickupLocation != null && _destinationLocation != null;

  bool get hasPickupSet => _pickupLocation != null;

  bool get hasDestinationSet => _destinationLocation != null;

  String get formattedDuration {
    if (_estimatedDurationMinutes == 0) return '-- min';
    if (_estimatedDurationMinutes < 60) {
      return '$_estimatedDurationMinutes min';
    }
    final hours = _estimatedDurationMinutes ~/ 60;
    final minutes = _estimatedDurationMinutes % 60;
    if (minutes == 0) {
      return '$hours hr';
    }
    return '$hours hr $minutes min';
  }

  String get formattedDistance {
    if (_estimatedDistance == 0.0) return '-- km';
    return '${_estimatedDistance.toStringAsFixed(1)} km';
  }

  double get finalFare {
    if (_selectedPromotion == null) return _estimatedFare;
    final discount = _estimatedFare * (_selectedPromotion!.discount / 100);
    return _estimatedFare - discount;
  }

  // Initialization
  RideController() {
    _loadInitialData();
  }

  void _loadInitialData() {
    _availableRideTypes = AppConstants.rideTypes;
    _promotions = AppConstants.promotions;
    _loadRecentRides();
  }

  void _loadRecentRides() {
    _recentRides = [
      RecentRideData(
        id: 'ride_001',
        pickupAddress: '123 Main Street, Downtown',
        destinationAddress: '456 Oak Avenue, Midtown',
        rideType: 'Economy',
        fare: 12.50,
        dateTime: DateTime.now().subtract(const Duration(hours: 2)),
        driverName: 'John D.',
        driverImage: null,
        pickupLat: 40.7128,
        pickupLng: -74.0060,
        destLat: 40.7580,
        destLng: -73.9855,
      ),
      RecentRideData(
        id: 'ride_002',
        pickupAddress: '789 Pine Road, Uptown',
        destinationAddress: '321 Elm Boulevard, Westside',
        rideType: 'Comfort',
        fare: 18.75,
        dateTime: DateTime.now().subtract(const Duration(days: 1)),
        driverName: 'Sarah M.',
        driverImage: null,
        pickupLat: 40.7831,
        pickupLng: -73.9712,
        destLat: 40.7614,
        destLng: -73.9776,
      ),
      RecentRideData(
        id: 'ride_003',
        pickupAddress: 'Airport Terminal 4',
        destinationAddress: '789 Luxury Hotel, Times Square',
        rideType: 'Premium',
        fare: 65.00,
        dateTime: DateTime.now().subtract(const Duration(days: 3)),
        driverName: 'Michael R.',
        driverImage: null,
        pickupLat: 40.6413,
        pickupLng: -73.7781,
        destLat: 40.7580,
        destLng: -73.9855,
      ),
    ];
  }

  // Location methods
  void setPickupLocation(LocationInputData location) {
    _pickupLocation = location;
    _status = RideStatus.selectingDestination;
    _clearDestinationAndFare();
    notifyListeners();
  }

  void setDestinationLocation(LocationInputData location) {
    _destinationLocation = location;
    _status = RideStatus.selectingRideType;
    if (_pickupLocation != null) {
      _calculateFare();
    }
    notifyListeners();
  }

  void clearPickupLocation() {
    _pickupLocation = null;
    _status = RideStatus.selectingPickup;
    _clearDestinationAndFare();
    notifyListeners();
  }

  void clearDestinationLocation() {
    _destinationLocation = null;
    _selectedRideType = null;
    _status = hasPickupSet
        ? RideStatus.selectingDestination
        : RideStatus.selectingPickup;
    _clearFare();
    notifyListeners();
  }

  void _clearDestinationAndFare() {
    _destinationLocation = null;
    _selectedRideType = null;
    _clearFare();
  }

  void _clearFare() {
    _estimatedDistance = 0.0;
    _estimatedDurationMinutes = 0;
    _estimatedFare = 0.0;
    _selectedPromotion = null;
  }

  void swapLocations() {
    final temp = _pickupLocation;
    _pickupLocation = _destinationLocation;
    _destinationLocation = temp;
    if (_pickupLocation != null && _destinationLocation != null) {
      _calculateFare();
    }
    notifyListeners();
  }

  // Ride type methods
  void selectRideType(RideType rideType) {
    _selectedRideType = rideType;
    _status = RideStatus.confirmingRide;
    _calculateFare();
    notifyListeners();
  }

  void clearSelectedRideType() {
    _selectedRideType = null;
    _status = RideStatus.selectingRideType;
    _clearFare();
    notifyListeners();
  }

  // Fare calculation
  Future<void> _calculateFare() async {
    if (_pickupLocation == null ||
        _destinationLocation == null ||
        _selectedRideType == null) {
      return;
    }

    _isCalculatingFare = true;
    notifyListeners();

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final distance = _calculateDistance(
      _pickupLocation!.latitude ?? 0.0,
      _pickupLocation!.longitude ?? 0.0,
      _destinationLocation!.latitude ?? 0.0,
      _destinationLocation!.longitude ?? 0.0,
    );

    _estimatedDistance = distance;
    _estimatedDurationMinutes = (distance * 3).toInt();
    _estimatedFare = _selectedRideType!.calculateFare(
      distance,
      _estimatedDurationMinutes,
    );

    _isCalculatingFare = false;
    notifyListeners();
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusKm = 6371.0;
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = earthRadiusKm * c;
    return distance;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  // Promotion methods
  void selectPromotion(Promotion promotion) {
    _selectedPromotion = promotion;
    notifyListeners();
  }

  void clearPromotion() {
    _selectedPromotion = null;
    notifyListeners();
  }

  // Ride request methods
  Future<bool> requestRide() async {
    if (!canRequestRide) return false;

    _status = RideStatus.confirmingRide;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    _status = RideStatus.rideConfirmed;
    notifyListeners();

    return true;
  }

  void resetRide() {
    _status = RideStatus.idle;
    _pickupLocation = null;
    _destinationLocation = null;
    _selectedRideType = null;
    _estimatedDistance = 0.0;
    _estimatedDurationMinutes = 0;
    _estimatedFare = 0.0;
    _selectedPromotion = null;
    notifyListeners();
  }

  void startNewRide() {
    resetRide();
  }

  // Recent rides methods
  void repeatRide(RecentRideData recentRide) {
    _pickupLocation = LocationInputData(
      address: recentRide.pickupAddress,
      latitude: recentRide.pickupLat,
      longitude: recentRide.pickupLng,
    );
    _destinationLocation = LocationInputData(
      address: recentRide.destinationAddress,
      latitude: recentRide.destLat,
      longitude: recentRide.destLng,
    );
    _status = RideStatus.selectingRideType;
    _calculateFare();
    notifyListeners();
  }

  void removeRecentRide(String rideId) {
    _recentRides.removeWhere((ride) => ride.id == rideId);
    notifyListeners();
  }

  // For demo/testing - populate sample locations
  void setSampleLocations() {
    _pickupLocation = const LocationInputData(
      address: '123 Main Street, Downtown',
      latitude: 40.7128,
      longitude: -74.0060,
    );
    _destinationLocation = const LocationInputData(
      address: '456 Oak Avenue, Midtown',
      latitude: 40.7580,
      longitude: -73.9855,
    );
    _status = RideStatus.selectingRideType;
    _calculateFare();
    notifyListeners();
  }
}