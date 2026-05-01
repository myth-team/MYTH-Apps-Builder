import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_project_app/utils/colors.dart'; 
import 'package:new_project_app/widgets/ride_state_chip.dart'; 

// ─────────────────────────────────────────────────────────────────────────────
// Models
// ─────────────────────────────────────────────────────────────────────────────

enum VehicleType { economy, luxury, xl }

enum PaymentMethod { wallet, card }

class VehicleOption {
  final VehicleType type;
  final String label;
  final String description;
  final double baseFare;
  final int eta; // minutes
  final int capacity;
  final String iconUrl;

  const VehicleOption({
    required this.type,
    required this.label,
    required this.description,
    required this.baseFare,
    required this.eta,
    required this.capacity,
    required this.iconUrl,
  });

  Color get accentColor {
    switch (type) {
      case VehicleType.economy:
        return AppColors.vehicleEconomy;
      case VehicleType.luxury:
        return AppColors.vehicleLuxury;
      case VehicleType.xl:
        return AppColors.vehicleXL;
    }
  }

  String get typeKey {
    switch (type) {
      case VehicleType.economy:
        return 'economy';
      case VehicleType.luxury:
        return 'luxury';
      case VehicleType.xl:
        return 'xl';
    }
  }
}

class DriverInfo {
  final String uid;
  final String name;
  final String phone;
  final double rating;
  final int totalTrips;
  final String avatarUrl;
  final String vehicleModel;
  final String vehiclePlate;
  final VehicleType vehicleType;
  final LatLng currentPosition;
  final double bearing;

  const DriverInfo({
    required this.uid,
    required this.name,
    required this.phone,
    required this.rating,
    required this.totalTrips,
    required this.avatarUrl,
    required this.vehicleModel,
    required this.vehiclePlate,
    required this.vehicleType,
    required this.currentPosition,
    this.bearing = 0.0,
  });

  DriverInfo copyWith({
    LatLng? currentPosition,
    double? bearing,
    double? rating,
  }) {
    return DriverInfo(
      uid: uid,
      name: name,
      phone: phone,
      rating: rating ?? this.rating,
      totalTrips: totalTrips,
      avatarUrl: avatarUrl,
      vehicleModel: vehicleModel,
      vehiclePlate: vehiclePlate,
      vehicleType: vehicleType,
      currentPosition: currentPosition ?? this.currentPosition,
      bearing: bearing ?? this.bearing,
    );
  }
}

class PlaceResult {
  final String placeId;
  final String primaryText;
  final String secondaryText;
  final LatLng? latLng;

  const PlaceResult({
    required this.placeId,
    required this.primaryText,
    required this.secondaryText,
    this.latLng,
  });

  String get fullAddress => '$primaryText, $secondaryText';
}

class FareEstimate {
  final double minFare;
  final double maxFare;
  final double distance; // km
  final int duration; // minutes
  final bool isSurge;
  final double surgeMultiplier;

  const FareEstimate({
    required this.minFare,
    required this.maxFare,
    required this.distance,
    required this.duration,
    this.isSurge = false,
    this.surgeMultiplier = 1.0,
  });

  double get midFare => (minFare + maxFare) / 2;
  String get displayRange => '\$${minFare.toStringAsFixed(2)} – \$${maxFare.toStringAsFixed(2)}';
}

class TripRecord {
  final String tripId;
  final String pickupAddress;
  final String dropoffAddress;
  final double fare;
  final DateTime dateTime;
  final RideState finalState;
  final VehicleType vehicleType;
  final DriverInfo? driver;
  final int? rating;
  final PaymentMethod paymentMethod;

  const TripRecord({
    required this.tripId,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.fare,
    required this.dateTime,
    required this.finalState,
    required this.vehicleType,
    this.driver,
    this.rating,
    required this.paymentMethod,
  });
}

class NearbyDriver {
  final String uid;
  final LatLng position;
  final double bearing;
  final VehicleType vehicleType;

  const NearbyDriver({
    required this.uid,
    required this.position,
    required this.bearing,
    required this.vehicleType,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// RideProvider
// ─────────────────────────────────────────────────────────────────────────────

class RideProvider extends ChangeNotifier {
  // ── State fields ──────────────────────────────────────────────────────────
  RideState _rideState = RideState.idle;
  String? _currentTripId;
  String? _errorMessage;

  // Location & Map
  LatLng? _pickupLocation;
  LatLng? _dropoffLocation;
  PlaceResult? _pickupPlace;
  PlaceResult? _dropoffPlace;
  LatLng _userLocation = const LatLng(37.7749, -122.4194); // Default: SF
  Set<Polyline> _routePolylines = {};
  Set<Marker> _mapMarkers = {};
  List<NearbyDriver> _nearbyDrivers = [];

  // Vehicle & Fare
  List<VehicleOption> _availableVehicles = [];
  VehicleOption? _selectedVehicle;
  FareEstimate? _fareEstimate;

  // Driver
  DriverInfo? _assignedDriver;

  // Payment
  PaymentMethod _selectedPaymentMethod = PaymentMethod.wallet;

  // Trip history
  List<TripRecord> _tripHistory = [];

  // ETA
  int _etaMinutes = 0;
  int _tripProgressSeconds = 0;

  // WebSocket simulation
  Timer? _wsSimTimer;
  Timer? _matchingTimer;
  Timer? _tripProgressTimer;
  int _matchingSecondsElapsed = 0;
  static const int _matchingTimeoutSeconds = 45;

  // ── Static vehicle catalog ─────────────────────────────────────────────────
  static final List<VehicleOption> _vehicleCatalog = [
    VehicleOption(
      type: VehicleType.economy,
      label: 'Economy',
      description: 'Affordable everyday rides',
      baseFare: 8.50,
      eta: 4,
      capacity: 4,
      iconUrl: 'https://cdn-icons-png.flaticon.com/512/3774/3774278.png',
    ),
    VehicleOption(
      type: VehicleType.luxury,
      label: 'Luxury',
      description: 'Premium comfort & style',
      baseFare: 22.00,
      eta: 7,
      capacity: 4,
      iconUrl: 'https://cdn-icons-png.flaticon.com/512/3774/3774309.png',
    ),
    VehicleOption(
      type: VehicleType.xl,
      label: 'XL',
      description: 'Spacious for groups',
      baseFare: 15.00,
      eta: 6,
      capacity: 6,
      iconUrl: 'https://cdn-icons-png.flaticon.com/512/3774/3774291.png',
    ),
  ];

  // ── Public getters ────────────────────────────────────────────────────────
  RideState get rideState => _rideState;
  String? get currentTripId => _currentTripId;
  String? get errorMessage => _errorMessage;

  LatLng? get pickupLocation => _pickupLocation;
  LatLng? get dropoffLocation => _dropoffLocation;
  PlaceResult? get pickupPlace => _pickupPlace;
  PlaceResult? get dropoffPlace => _dropoffPlace;
  LatLng get userLocation => _userLocation;
  Set<Polyline> get routePolylines => _routePolylines;
  Set<Marker> get mapMarkers => _mapMarkers;
  List<NearbyDriver> get nearbyDrivers => _nearbyDrivers;

  List<VehicleOption> get availableVehicles => _availableVehicles;
  VehicleOption? get selectedVehicle => _selectedVehicle;
  FareEstimate? get fareEstimate => _fareEstimate;

  DriverInfo? get assignedDriver => _assignedDriver;

  PaymentMethod get selectedPaymentMethod => _selectedPaymentMethod;
  List<TripRecord> get tripHistory => _tripHistory;

  int get etaMinutes => _etaMinutes;
  int get tripProgressSeconds => _tripProgressSeconds;
  int get matchingSecondsElapsed => _matchingSecondsElapsed;
  int get matchingSecondsRemaining =>
      (_matchingTimeoutSeconds - _matchingSecondsElapsed).clamp(0, _matchingTimeoutSeconds);

  bool get hasPickup => _pickupLocation != null;
  bool get hasDropoff => _dropoffLocation != null;
  bool get isReadyToBook => hasPickup && hasDropoff && _selectedVehicle != null;
  bool get isOnTrip => _rideState == RideState.active;
  bool get isTracking =>
      _rideState == RideState.driverAssigned ||
      _rideState == RideState.driverArrived ||
      _rideState == RideState.active;

  // ── Location Management ───────────────────────────────────────────────────

  /// Updates the user's current GPS location.
  void updateUserLocation(LatLng position) {
    _userLocation = position;
    notifyListeners();
  }

  /// Sets the pickup location from a place result.
  void setPickupPlace(PlaceResult place) {
    _pickupPlace = place;
    _pickupLocation = place.latLng;
    _errorMessage = null;
    notifyListeners();
    _maybeFetchFareEstimate();
  }

  /// Sets the dropoff location from a place result.
  void setDropoffPlace(PlaceResult place) {
    _dropoffPlace = place;
    _dropoffLocation = place.latLng;
    _errorMessage = null;
    notifyListeners();
    _maybeFetchFareEstimate();
  }

  /// Sets pickup using raw LatLng (e.g. from map tap or current location).
  void setPickupLatLng(LatLng position, {String? address}) {
    _pickupLocation = position;
    _pickupPlace = PlaceResult(
      placeId: 'manual_pickup',
      primaryText: address ?? 'Selected Location',
      secondaryText: '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}',
      latLng: position,
    );
    notifyListeners();
    _maybeFetchFareEstimate();
  }

  /// Sets dropoff using raw LatLng.
  void setDropoffLatLng(LatLng position, {String? address}) {
    _dropoffLocation = position;
    _dropoffPlace = PlaceResult(
      placeId: 'manual_dropoff',
      primaryText: address ?? 'Destination',
      secondaryText: '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}',
      latLng: position,
    );
    notifyListeners();
    _maybeFetchFareEstimate();
  }

  /// Clears pickup selection.
  void clearPickup() {
    _pickupLocation = null;
    _pickupPlace = null;
    _fareEstimate = null;
    notifyListeners();
  }

  /// Clears dropoff selection.
  void clearDropoff() {
    _dropoffLocation = null;
    _dropoffPlace = null;
    _fareEstimate = null;
    notifyListeners();
  }

  // ── Nearby Drivers ────────────────────────────────────────────────────────

  /// Starts periodic simulation of nearby driver positions.
  void startNearbyDriverSimulation() {
    _generateNearbyDrivers();
    _wsSimTimer?.cancel();
    _wsSimTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _animateNearbyDrivers();
    });
  }

  /// Stops nearby driver simulation.
  void stopNearbyDriverSimulation() {
    _wsSimTimer?.cancel();
    _nearbyDrivers = [];
    notifyListeners();
  }

  void _generateNearbyDrivers() {
    final random = math.Random();
    final base = _userLocation;
    _nearbyDrivers = List.generate(5, (i) {
      final lat = base.latitude + (random.nextDouble() - 0.5) * 0.02;
      final lng = base.longitude + (random.nextDouble() - 0.5) * 0.02;
      return NearbyDriver(
        uid: 'driver_nearby_$i',
        position: LatLng(lat, lng),
        bearing: random.nextDouble() * 360,
        vehicleType: VehicleType.values[i % VehicleType.values.length],
      );
    });
    notifyListeners();
  }

  void _animateNearbyDrivers() {
    final random = math.Random();
    _nearbyDrivers = _nearbyDrivers.map((d) {
      final lat = d.position.latitude + (random.nextDouble() - 0.5) * 0.002;
      final lng = d.position.longitude + (random.nextDouble() - 0.5) * 0.002;
      return NearbyDriver(
        uid: d.uid,
        position: LatLng(lat, lng),
        bearing: (d.bearing + random.nextDouble() * 20 - 10) % 360,
        vehicleType: d.vehicleType,
      );
    }).toList();
    notifyListeners();
  }

  // ── Vehicle Selection & Fare Estimation ───────────────────────────────────

  /// Loads available vehicle options (populates from catalog).
  Future<void> loadVehicleOptions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _availableVehicles = List.from(_vehicleCatalog);
    if (_availableVehicles.isNotEmpty && _selectedVehicle == null) {
      _selectedVehicle = _availableVehicles.first;
    }
    notifyListeners();
  }

  /// Selects a vehicle type for booking.
  void selectVehicle(VehicleOption vehicle) {
    _selectedVehicle = vehicle;
    notifyListeners();
    _maybeFetchFareEstimate();
  }

  /// Fetches a fare estimate for the current pickup/dropoff/vehicle selection.
  Future<void> fetchFareEstimate() async {
    if (_pickupLocation == null || _dropoffLocation == null) return;
    if (_selectedVehicle == null) return;

    try {
      await Future.delayed(const Duration(milliseconds: 700));

      final double distance = _calculateDistance(
        _pickupLocation!,
        _dropoffLocation!,
      );
      final double duration = (distance / 30) * 60; // 30 km/h average
      final double baseFare = _selectedVehicle!.baseFare;
      final double distanceFare = distance * 1.5;
      final double timeFare = (duration / 60) * 0.25;
      final double total = baseFare + distanceFare + timeFare;

      final bool isSurge = math.Random().nextBool() && distance > 5;
      final double surgeMultiplier = isSurge ? 1.3 : 1.0;

      _fareEstimate = FareEstimate(
        minFare: total * surgeMultiplier * 0.9,
        maxFare: total * surgeMultiplier * 1.1,
        distance: distance,
        duration: duration.round(),
        isSurge: isSurge,
        surgeMultiplier: surgeMultiplier,
      );
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Could not estimate fare. Please try again.';
      notifyListeners();
    }
  }

  void _maybeFetchFareEstimate() {
    if (_pickupLocation != null &&
        _dropoffLocation != null &&
        _selectedVehicle != null) {
      fetchFareEstimate();
    }
  }

  // ── Booking Flow ──────────────────────────────────────────────────────────

  /// Confirms the booking and starts the matching process.
  Future<void> confirmBooking() async {
    if (!isReadyToBook) {
      _errorMessage = 'Please select pickup, destination, and vehicle type.';
      notifyListeners();
      return;
    }

    _rideState = RideState.matching;
    _errorMessage = null;
    _matchingSecondsElapsed = 0;
    notifyListeners();

    // Simulate matching with timeout
    _matchingTimer?.cancel();
    _matchingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _matchingSecondsElapsed++;
      notifyListeners();

      if (_matchingSecondsElapsed >= _matchingTimeoutSeconds) {
        timer.cancel();
        _onNoDriverFound();
      }
    });

    // Simulate driver found after 3-8 seconds
    final int matchDelay = 3 + math.Random().nextInt(5);
    await Future.delayed(Duration(seconds: matchDelay));

    if (_rideState == RideState.matching) {
      _matchingTimer?.cancel();
      _onDriverAssigned();
    }
  }

  void _onDriverAssigned() {
    _currentTripId = 'trip_${DateTime.now().millisecondsSinceEpoch}';
    _assignedDriver = DriverInfo(
      uid: 'driver_001',
      name: 'Michael Chen',
      phone: '+1 555 0192',
      rating: 4.92,
      totalTrips: 1847,
      avatarUrl: 'https://i.pravatar.cc/150?img=11',
      vehicleModel: 'Toyota Camry 2022',
      vehiclePlate: 'ABC-1234',
      vehicleType: _selectedVehicle?.type ?? VehicleType.economy,
      currentPosition: _pickupLocation != null
          ? LatLng(
              _pickupLocation!.latitude + 0.008,
              _pickupLocation!.longitude + 0.006,
            )
          : _userLocation,
      bearing: 45.0,
    );
    _etaMinutes = _fareEstimate?.duration ?? 8;
    _rideState = RideState.driverAssigned;
    notifyListeners();

    // Start WebSocket simulation for driver movement
    _startDriverTrackingSimulation();

    // Simulate driver arriving after ETA
    final int arrivalDelay = math.max(5, (_etaMinutes * 0.4).round());
    Future.delayed(Duration(seconds: arrivalDelay), () {
      if (_rideState == RideState.driverAssigned) {
        _onDriverArrived();
      }
    });
  }

  void _onDriverArrived() {
    _rideState = RideState.driverArrived;
    _etaMinutes = 0;
    notifyListeners();
  }

  void _onNoDriverFound() {
    _rideState = RideState.noDriverFound;
    _wsSimTimer?.cancel();
    notifyListeners();
  }

  // ── Live Driver Tracking (WebSocket Simulation) ───────────────────────────

  void _startDriverTrackingSimulation() {
    _wsSimTimer?.cancel();

    if (_assignedDriver == null || _pickupLocation == null) return;

    LatLng currentPos = _assignedDriver!.currentPosition;
    final LatLng target = _pickupLocation!;

    _wsSimTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (_assignedDriver == null) {
        timer.cancel();
        return;
      }
      if (_rideState != RideState.driverAssigned &&
          _rideState != RideState.active) {
        timer.cancel();
        return;
      }

      final LatLng destination = _rideState == RideState.active
          ? (_dropoffLocation ?? target)
          : target;

      final double newLat = currentPos.latitude +
          (destination.latitude - currentPos.latitude) * 0.05;
      final double newLng = currentPos.longitude +
          (destination.longitude - currentPos.longitude) * 0.05;
      currentPos = LatLng(newLat, newLng);

      final double bearing = _calculateBearing(currentPos, destination);
      _assignedDriver = _assignedDriver!.copyWith(
        currentPosition: currentPos,
        bearing: bearing,
      );

      // Reduce ETA
      if (_etaMinutes > 0 && timer.tick % 5 == 0) {
        _etaMinutes = (_etaMinutes - 1).clamp(0, 9999);
      }

      notifyListeners();
    });
  }

  // ── Trip Lifecycle ────────────────────────────────────────────────────────

  /// Driver starts the trip (driver-side action).
  void startTrip() {
    if (_rideState != RideState.driverArrived) return;
    _rideState = RideState.active;
    _tripProgressSeconds = 0;
    _etaMinutes = _fareEstimate?.duration ?? 15;
    notifyListeners();

    _tripProgressTimer?.cancel();
    _tripProgressTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) {
      _tripProgressSeconds++;
      if (_etaMinutes > 0 && _tripProgressSeconds % 60 == 0) {
        _etaMinutes = (_etaMinutes - 1).clamp(0, 9999);
      }
      notifyListeners();
    });
  }

  /// Completes the trip (driver-side action).
  void completeTrip() {
    if (_rideState != RideState.active) return;
    _wsSimTimer?.cancel();
    _tripProgressTimer?.cancel();
    _rideState = RideState.completed;

    // Record trip in history
    if (_currentTripId != null) {
      final record = TripRecord(
        tripId: _currentTripId!,
        pickupAddress: _pickupPlace?.fullAddress ?? 'Pickup',
        dropoffAddress: _dropoffPlace?.fullAddress ?? 'Destination',
        fare: _fareEstimate?.midFare ?? 0.0,
        dateTime: DateTime.now(),
        finalState: RideState.completed,
        vehicleType: _selectedVehicle?.type ?? VehicleType.economy,
        driver: _assignedDriver,
        paymentMethod: _selectedPaymentMethod,
      );
      _tripHistory = [record, ..._tripHistory];
    }

    notifyListeners();
  }

  /// Cancels the current ride request.
  Future<void> cancelRide({String? reason}) async {
    _wsSimTimer?.cancel();
    _matchingTimer?.cancel();
    _tripProgressTimer?.cancel();

    if (_currentTripId != null && _rideState != RideState.idle) {
      final record = TripRecord(
        tripId: _currentTripId!,
        pickupAddress: _pickupPlace?.fullAddress ?? 'Pickup',
        dropoffAddress: _dropoffPlace?.fullAddress ?? 'Destination',
        fare: 0.0,
        dateTime: DateTime.now(),
        finalState: RideState.cancelled,
        vehicleType: _selectedVehicle?.type ?? VehicleType.economy,
        driver: _assignedDriver,
        paymentMethod: _selectedPaymentMethod,
      );
      _tripHistory = [record, ..._tripHistory];
    }

    _rideState = RideState.cancelled;
    _assignedDriver = null;
    _currentTripId = null;
    _etaMinutes = 0;
    _tripProgressSeconds = 0;
    notifyListeners();
  }

  // ── Post-trip ─────────────────────────────────────────────────────────────

  /// Submits a rating for the completed trip.
  Future<void> submitRating({
    required int stars,
    String? comment,
  }) async {
    if (_tripHistory.isEmpty) return;

    await Future.delayed(const Duration(milliseconds: 500));

    final latest = _tripHistory.first;
    final updated = TripRecord(
      tripId: latest.tripId,
      pickupAddress: latest.pickupAddress,
      dropoffAddress: latest.dropoffAddress,
      fare: latest.fare,
      dateTime: latest.dateTime,
      finalState: latest.finalState,
      vehicleType: latest.vehicleType,
      driver: latest.driver,
      rating: stars,
      paymentMethod: latest.paymentMethod,
    );
    _tripHistory = [updated, ..._tripHistory.skip(1)];
    notifyListeners();
  }

  /// Resets the ride state back to idle for a new booking.
  void resetToIdle() {
    _wsSimTimer?.cancel();
    _matchingTimer?.cancel();
    _tripProgressTimer?.cancel();
    _rideState = RideState.idle;
    _currentTripId = null;
    _assignedDriver = null;
    _errorMessage = null;
    _fareEstimate = null;
    _pickupLocation = null;
    _dropoffLocation = null;
    _pickupPlace = null;
    _dropoffPlace = null;
    _selectedVehicle = null;
    _routePolylines = {};
    _etaMinutes = 0;
    _tripProgressSeconds = 0;
    _matchingSecondsElapsed = 0;
    notifyListeners();
  }

  // ── Payment ───────────────────────────────────────────────────────────────

  /// Sets the selected payment method.
  void setPaymentMethod(PaymentMethod method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  // ── Driver-side Actions ───────────────────────────────────────────────────

  /// Called by driver to accept an incoming trip request.
  Future<void> driverAcceptTrip({
    required String tripId,
    required String riderId,
    required LatLng pickupLocation,
    required LatLng dropoffLocation,
    required String pickupAddress,
    required String dropoffAddress,
    required double estimatedFare,
  }) async {
    _currentTripId = tripId;
    _pickupLocation = pickupLocation;
    _dropoffLocation = dropoffLocation;
    _pickupPlace = PlaceResult(
      placeId: 'pickup_$tripId',
      primaryText: pickupAddress,
      secondaryText: '',
      latLng: pickupLocation,
    );
    _dropoffPlace = PlaceResult(
      placeId: 'dropoff_$tripId',
      primaryText: dropoffAddress,
      secondaryText: '',
      latLng: dropoffLocation,
    );
    _rideState = RideState.driverAssigned;
    _etaMinutes = _calculateDistance(pickupLocation, dropoffLocation).round();
    notifyListeners();
  }

  /// Driver marks arrival at pickup.
  void driverArriveAtPickup() {
    _rideState = RideState.driverArrived;
    notifyListeners();
  }

  /// Driver begins the trip.
  void driverBeginTrip() {
    startTrip();
  }

  /// Driver completes the trip.
  void driverCompleteTrip() {
    completeTrip();
  }

  // ── Driver Earnings (Mock) ────────────────────────────────────────────────

  /// Returns mock daily earnings data (last 7 days) for charts.
  List<Map<String, dynamic>> getDailyEarnings() {
    final random = math.Random(42);
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      return {
        'date': day,
        'earnings': 60 + random.nextDouble() * 120,
        'trips': 4 + random.nextInt(10),
      };
    });
  }

  /// Returns mock weekly earnings data (last 4 weeks) for charts.
  List<Map<String, dynamic>> getWeeklyEarnings() {
    final random = math.Random(99);
    final now = DateTime.now();
    return List.generate(4, (i) {
      return {
        'weekStart': now.subtract(Duration(days: (3 - i) * 7)),
        'earnings': 400 + random.nextDouble() * 400,
        'trips': 28 + random.nextInt(30),
      };
    });
  }

  /// Returns total earnings for the current week (mock).
  double get weeklyEarningsTotal {
    return getWeeklyEarnings().last['earnings'] as double;
  }

  /// Returns total earnings for today (mock).
  double get todayEarningsTotal {
    return getDailyEarnings().last['earnings'] as double;
  }

  // ── Error Management ──────────────────────────────────────────────────────

  /// Clears the current error message.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ── Route Polylines ───────────────────────────────────────────────────────

  /// Sets the route polylines for map display.
  void setRoutePolylines(Set<Polyline> polylines) {
    _routePolylines = polylines;
    notifyListeners();
  }

  /// Clears the route from the map.
  void clearRoute() {
    _routePolylines = {};
    notifyListeners();
  }

  // ── Map Markers ───────────────────────────────────────────────────────────

  /// Updates the full set of map markers.
  void setMapMarkers(Set<Marker> markers) {
    _mapMarkers = markers;
    notifyListeners();
  }

  // ── Utility / Geometry Helpers ────────────────────────────────────────────

  /// Calculates approximate distance in kilometers between two LatLng points.
  double _calculateDistance(LatLng a, LatLng b) {
    const double earthRadius = 6371.0;
    final double dLat = _toRadians(b.latitude - a.latitude);
    final double dLng = _toRadians(b.longitude - a.longitude);
    final double sinDLat = math.sin(dLat / 2);
    final double sinDLng = math.sin(dLng / 2);
    final double h = sinDLat * sinDLat +
        math.cos(_toRadians(a.latitude)) *
            math.cos(_toRadians(b.latitude)) *
            sinDLng *
            sinDLng;
    return 2 * earthRadius * math.asin(math.sqrt(h));
  }

  double _toRadians(double degrees) => degrees * math.pi / 180.0;

  /// Calculates bearing in degrees from point [a] to point [b].
  double _calculateBearing(LatLng a, LatLng b) {
    final double lat1 = _toRadians(a.latitude);
    final double lat2 = _toRadians(b.latitude);
    final double dLng = _toRadians(b.longitude - a.longitude);
    final double y = math.sin(dLng) * math.cos(lat2);
    final double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLng);
    return ((_toDegrees(math.atan2(y, x)) + 360) % 360);
  }

  double _toDegrees(double radians) => radians * 180.0 / math.pi;

  /// Returns a formatted string for distance display.
  String formatDistance(double km) {
    if (km < 1.0) {
      return '${(km * 1000).toStringAsFixed(0)} m';
    }
    return '${km.toStringAsFixed(1)} km';
  }

  /// Returns a formatted ETA string.
  String formatEta(int minutes) {
    if (minutes <= 0) return 'Arriving';
    if (minutes < 60) return '$minutes min';
    final int h = minutes ~/ 60;
    final int m = minutes % 60;
    return m > 0 ? '${h}h ${m}m' : '${h}h';
  }

  @override
  void dispose() {
    _wsSimTimer?.cancel();
    _matchingTimer?.cancel();
    _tripProgressTimer?.cancel();
    super.dispose();
  }
}