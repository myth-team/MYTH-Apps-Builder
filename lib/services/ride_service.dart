import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ridenow_go_app/models/driver.dart'; 
import 'package:ridenow_go_app/models/location.dart'; 
import 'package:ridenow_go_app/models/payment_method.dart'; 
import 'package:ridenow_go_app/models/ride.dart'; 

/// Service for managing ride lifecycle: requesting, matching, tracking, and completing rides.
/// Provides streams for ride state changes and methods for all ride operations.
class RideService {
  RideService._();
  static final RideService _instance = RideService._();
  static RideService get instance => _instance;

  final Random _random = Random();

  // State
  Ride? _currentRide;
  final StreamController<Ride?> _rideController = StreamController<Ride?>.broadcast();
  final StreamController<List<Driver>> _nearbyDriversController = StreamController<List<Driver>>.broadcast();
  final StreamController<double> _fareEstimateController = StreamController<double>.broadcast();

  Timer? _matchingTimer;
  Timer? _etaUpdateTimer;
  Timer? _nearbyDriversTimer;

  /// Stream of current ride state changes.
  Stream<Ride?> get rideStream => _rideController.stream;

  /// Stream of nearby available drivers.
  Stream<List<Driver>> get nearbyDriversStream => _nearbyDriversController.stream;

  /// Stream of fare estimate updates.
  Stream<double> get fareEstimateStream => _fareEstimateController.stream;

  /// Currently active ride, if any.
  Ride? get currentRide => _currentRide;

  /// Whether there is an active ride in progress.
  bool get hasActiveRide => _currentRide != null && _currentRide!.isActive;

  /// Base fare per ride type.
  final Map<RideType, double> _baseFares = {
    RideType.economy: 3.50,
    RideType.premium: 8.00,
    RideType.shared: 2.50,
    RideType.xl: 6.00,
  };

  /// Per-kilometer rate per ride type.
  final Map<RideType, double> _perKmRates = {
    RideType.economy: 1.25,
    RideType.premium: 2.50,
    RideType.shared: 0.85,
    RideType.xl: 1.85,
  };

  /// Per-minute rate per ride type.
  final Map<RideType, double> _perMinuteRates = {
    RideType.economy: 0.35,
    RideType.premium: 0.65,
    RideType.shared: 0.25,
    RideType.xl: 0.45,
  };

  /// Start polling for nearby drivers around a location.
  void startNearbyDriversPolling(LocationModel center, {Duration interval = const Duration(seconds: 10)}) {
    _nearbyDriversTimer?.cancel();

    // Initial fetch
    _fetchNearbyDrivers(center);

    _nearbyDriversTimer = Timer.periodic(interval, (_) {
      _fetchNearbyDrivers(center);
    });
  }

  /// Stop polling for nearby drivers.
  void stopNearbyDriversPolling() {
    _nearbyDriversTimer?.cancel();
    _nearbyDriversTimer = null;
  }

  /// Request a new ride with specified parameters.
  Future<Ride> requestRide({
    required RideType type,
    required LocationModel pickup,
    required LocationModel destination,
    PaymentMethod? paymentMethod,
    String? promoCode,
  }) async {
    // Cancel any existing ride first
    if (_currentRide != null && _currentRide!.isActive) {
      await cancelRide('New ride requested');
    }

    final estimatedFare = calculateFareEstimate(
      type: type,
      pickup: pickup,
      destination: destination,
      promoCode: promoCode,
    );

    final ride = Ride(
      id: _generateRideId(),
      type: type,
      status: RideStatus.searching,
      pickup: pickup,
      destination: destination,
      requestedAt: DateTime.now(),
      estimatedFare: estimatedFare,
      paymentMethod: paymentMethod,
      promoCode: promoCode,
    );

    _currentRide = ride;
    _rideController.add(ride);

    // Start driver matching simulation
    _startDriverMatching();

    return ride;
  }

  /// Calculate fare estimate for a potential ride.
  double calculateFareEstimate({
    required RideType type,
    required LocationModel pickup,
    required LocationModel destination,
    String? promoCode,
  }) {
    final distanceKm = pickup.distanceTo(destination);
    final estimatedMinutes = (distanceKm / 0.5).ceil(); // ~30 km/h

    final baseFare = _baseFares[type] ?? 3.50;
    final distanceFare = distanceKm * (_perKmRates[type] ?? 1.25);
    final timeFare = estimatedMinutes * (_perMinuteRates[type] ?? 0.35);

    double total = baseFare + distanceFare + timeFare;

    // Apply promo discount if valid
    if (promoCode != null && promoCode.isNotEmpty) {
      final discount = _calculatePromoDiscount(promoCode, total);
      total -= discount;
    }

    // Minimum fare
    final minimumFare = 5.00;
    if (total < minimumFare) {
      total = minimumFare;
    }

    _fareEstimateController.add(total);
    return double.parse(total.toStringAsFixed(2));
  }

  /// Cancel the current ride.
  Future<bool> cancelRide(String reason) async {
    if (_currentRide == null) return false;
    if (_currentRide!.status == RideStatus.completed) return false;

    _matchingTimer?.cancel();
    _etaUpdateTimer?.cancel();

    final cancelledRide = _currentRide!.copyWith(
      status: RideStatus.cancelled,
      cancelledAt: DateTime.now(),
      cancellationReason: reason,
    );

    _currentRide = cancelledRide;
    _rideController.add(cancelledRide);

    // Clear after delay
    Future.delayed(Duration(seconds: 3), () {
      if (_currentRide?.status == RideStatus.cancelled) {
        _currentRide = null;
        _rideController.add(null);
      }
    });

    return true;
  }

  /// Rate the driver after trip completion.
  Future<bool> rateDriver({
    required String rideId,
    required double rating,
    String? comment,
    List<String>? feedbackTags,
    double? tipAmount,
  }) async {
    // In production, send to backend
    await Future.delayed(Duration(milliseconds: 800));

    if (_currentRide != null && _currentRide!.id == rideId) {
      final updatedRide = _currentRide!.copyWith(
        tipAmount: tipAmount,
      );
      _currentRide = updatedRide;
      _rideController.add(updatedRide);
    }

    return true;
  }

  /// Complete the current ride with final details.
  Future<Ride?> completeRide({
    double? finalDistanceKm,
    int? finalDurationMinutes,
    double? surgeMultiplier,
  }) async {
    if (_currentRide == null) return null;
    if (_currentRide!.status != RideStatus.inProgress) return null;

    _etaUpdateTimer?.cancel();

    final distance = finalDistanceKm ?? _currentRide!.distanceKm ?? 0;
    final duration = finalDurationMinutes ?? _currentRide!.durationMinutes ?? 0;

    final baseFare = _baseFares[_currentRide!.type] ?? 3.50;
    final distanceFare = distance * (_perKmRates[_currentRide!.type] ?? 1.25);
    final timeFare = duration * (_perMinuteRates[_currentRide!.type] ?? 0.35);

    double finalFare = baseFare + distanceFare + timeFare;

    if (surgeMultiplier != null && surgeMultiplier > 1.0) {
      finalFare *= surgeMultiplier;
    }

    // Apply promo
    if (_currentRide!.promoCode != null) {
      final discount = _calculatePromoDiscount(_currentRide!.promoCode!, finalFare);
      finalFare -= discount;
    }

    final completedRide = _currentRide!.copyWith(
      status: RideStatus.completed,
      completedAt: DateTime.now(),
      finalFare: double.parse(finalFare.toStringAsFixed(2)),
      distanceKm: distance,
      durationMinutes: duration,
    );

    _currentRide = completedRide;
    _rideController.add(completedRide);

    // Clear after delay for UI transition
    Future.delayed(Duration(minutes: 5), () {
      if (_currentRide?.id == completedRide.id) {
        _currentRide = null;
        _rideController.add(null);
      }
    });

    return completedRide;
  }

  /// Get ride history for the current user.
  Future<List<Ride>> getRideHistory({int limit = 20, int offset = 0}) async {
    // In production, fetch from backend
    await Future.delayed(Duration(milliseconds: 500));

    return _generateMockRideHistory(limit);
  }

  /// Rebook a previous ride with same details.
  Future<Ride?> rebookRide(String previousRideId) async {
    // In production, fetch original ride and create new request
    final history = await getRideHistory(limit: 50);
    final previousRide = history.where((r) => r.id == previousRideId).firstOrNull;

    if (previousRide == null) return null;

    return requestRide(
      type: previousRide.type,
      pickup: previousRide.pickup,
      destination: previousRide.destination,
      paymentMethod: previousRide.paymentMethod,
    );
  }

  /// Simulate driver matching process.
  void _startDriverMatching() {
    _matchingTimer?.cancel();

    // Simulate finding a driver after 3-8 seconds
    final matchDelay = Duration(seconds: 3 + _random.nextInt(6));
    _matchingTimer = Timer(matchDelay, () {
      if (_currentRide == null || _currentRide!.status != RideStatus.searching) return;

      final driver = _generateMockDriver();
      final assignedRide = _currentRide!.copyWith(
        status: RideStatus.driverAssigned,
        driver: driver,
      );

      _currentRide = assignedRide;
      _rideController.add(assignedRide);

      // Transition to en route after brief delay
      Future.delayed(Duration(seconds: 2), () {
        if (_currentRide?.id != assignedRide.id) return;

        final enRouteRide = _currentRide!.copyWith(
          status: RideStatus.driverEnRoute,
          driver: driver.copyWith(
            status: DriverStatus.enRoute,
            etaMinutes: 5 + _random.nextInt(10).toDouble(),
          ),
        );

        _currentRide = enRouteRide;
        _rideController.add(enRouteRide);

        // Start ETA countdown simulation
        _startEtaSimulation();
      });
    });
  }

  /// Simulate ETA countdown updates.
  void _startEtaSimulation() {
    _etaUpdateTimer?.cancel();

    _etaUpdateTimer = Timer.periodic(Duration(seconds: 15), (_) {
      if (_currentRide?.driver?.etaMinutes == null) return;

      final currentEta = _currentRide!.driver!.etaMinutes!;
      if (currentEta <= 1) {
        // Driver arrived
        final arrivedRide = _currentRide!.copyWith(
          status: RideStatus.driverArrived,
          driver: _currentRide!.driver!.copyWith(
            status: DriverStatus.arrived,
            etaMinutes: 0,
          ),
        );

        _currentRide = arrivedRide;
        _rideController.add(arrivedRide);
        _etaUpdateTimer?.cancel();

        // Auto-start trip after 30 seconds
        Future.delayed(Duration(seconds: 30), () {
          _startTrip();
        });

        return;
      }

      final newEta = currentEta - 0.5;
      final updatedRide = _currentRide!.copyWith(
        driver: _currentRide!.driver!.copyWith(
          etaMinutes: newEta > 0 ? newEta : 0,
        ),
      );

      _currentRide = updatedRide;
      _rideController.add(updatedRide);
    });
  }

  /// Simulate trip start after driver arrival.
  void _startTrip() {
    if (_currentRide?.status != RideStatus.driverArrived) return;

    final startedRide = _currentRide!.copyWith(
      status: RideStatus.inProgress,
      startedAt: DateTime.now(),
      driver: _currentRide!.driver!.copyWith(
        status: DriverStatus.inTrip,
      ),
    );

    _currentRide = startedRide;
    _rideController.add(startedRide);
  }

  /// Generate mock nearby drivers for map display.
  void _fetchNearbyDrivers(LocationModel center) {
    final count = 3 + _random.nextInt(8);
    final drivers = List.generate(count, (index) {
      final latOffset = (_random.nextDouble() - 0.5) * 0.02;
      final lngOffset = (_random.nextDouble() - 0.5) * 0.02;

      return Driver(
        id: 'driver_nearby_$index',
        name: _driverNames[_random.nextInt(_driverNames.length)],
        phoneNumber: '+1-555-0${100 + _random.nextInt(900)}',
        licensePlate: 'ABC ${1000 + _random.nextInt(9000)}',
        vehicleModel: _vehicleModels[_random.nextInt(_vehicleModels.length)],
        vehicleColor: _vehicleColors[_random.nextInt(_vehicleColors.length)],
        rating: 3.5 + _random.nextDouble() * 1.5,
        totalTrips: 100 + _random.nextInt(5000),
        status: DriverStatus.available,
        currentLocation: LocationModel(
          latitude: center.latitude + latOffset,
          longitude: center.longitude + lngOffset,
          address: 'Nearby location',
        ),
        etaMinutes: 2 + _random.nextInt(15).toDouble(),
      );
    });

    _nearbyDriversController.add(drivers);
  }

  double _calculatePromoDiscount(String code, double fare) {
    // Simple promo logic - in production, validate against backend
    final upperCode = code.toUpperCase();
    if (upperCode == 'WELCOME50') return fare * 0.5;
    if (upperCode == 'RIDE20') return fare * 0.2;
    if (upperCode == 'OFF10') return 10.0;
    return 0.0;
  }

  String _generateRideId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = _random.nextInt(9999).toString().padLeft(4, '0');
    return 'RIDE-$timestamp-$random';
  }

  Driver _generateMockDriver() {
    final nameIndex = _random.nextInt(_driverNames.length);
    return Driver(
      id: 'driver_${_random.nextInt(100000)}',
      name: _driverNames[nameIndex],
      phoneNumber: '+1-555-0${100 + _random.nextInt(900)}',
      licensePlate: 'XYZ ${1000 + _random.nextInt(9000)}',
      vehicleModel: _vehicleModels[_random.nextInt(_vehicleModels.length)],
      vehicleColor: _vehicleColors[_random.nextInt(_vehicleColors.length)],
      rating: 4.0 + _random.nextDouble() * 1.0,
      totalTrips: 500 + _random.nextInt(10000),
      status: DriverStatus.enRoute,
      etaMinutes: 5 + _random.nextInt(10).toDouble(),
    );
  }

  List<Ride> _generateMockRideHistory(int count) {
    return List.generate(count, (index) {
      final isCompleted = _random.nextBool();
      final type = RideType.values[_random.nextInt(RideType.values.length)];

      final pickup = LocationModel(
        latitude: 37.7749 + (_random.nextDouble() - 0.5) * 0.1,
        longitude: -122.4194 + (_random.nextDouble() - 0.5) * 0.1,
        address: '${100 + _random.nextInt(900)} ${_streetNames[_random.nextInt(_streetNames.length)]}, San Francisco, CA',
        placeName: _placeNames[_random.nextInt(_placeNames.length)],
      );

      final destination = LocationModel(
        latitude: 37.7749 + (_random.nextDouble() - 0.5) * 0.1,
        longitude: -122.4194 + (_random.nextDouble() - 0.5) * 0.1,
        address: '${100 + _random.nextInt(900)} ${_streetNames[_random.nextInt(_streetNames.length)]}, San Francisco, CA',
        placeName: _placeNames[_random.nextInt(_placeNames.length)],
      );

      final distance = pickup.distanceTo(destination);
      final duration = (distance / 0.5).ceil();

      final baseFare = _baseFares[type] ?? 3.50;
      final finalFare = baseFare + distance * 1.25 + duration * 0.35;

      return Ride(
        id: 'RIDE-${DateTime.now().millisecondsSinceEpoch - index * 86400000}',
        type: type,
        status: isCompleted ? RideStatus.completed : RideStatus.cancelled,
        pickup: pickup,
        destination: destination,
        requestedAt: DateTime.now().subtract(Duration(days: index, hours: _random.nextInt(24))),
        completedAt: isCompleted ? DateTime.now().subtract(Duration(days: index, hours: _random.nextInt(12))) : null,
        cancelledAt: !isCompleted ? DateTime.now().subtract(Duration(days: index, hours: _random.nextInt(12))) : null,
        finalFare: isCompleted ? double.parse(finalFare.toStringAsFixed(2)) : null,
        distanceKm: double.parse(distance.toStringAsFixed(2)),
        durationMinutes: duration,
        paymentMethod: PaymentMethod(
          id: 'pm_$_random',
          type: PaymentType.creditCard,
          displayName: 'Visa',
          lastFourDigits: '${1000 + _random.nextInt(9000)}',
          cardBrand: CardBrand.visa,
        ),
      );
    });
  }

  void dispose() {
    _matchingTimer?.cancel();
    _etaUpdateTimer?.cancel();
    _nearbyDriversTimer?.cancel();
    _rideController.close();
    _nearbyDriversController.close();
    _fareEstimateController.close();
  }

  // Mock data
  final List<String> _driverNames = [
    'James Wilson', 'Maria Garcia', 'David Chen', 'Sarah Johnson',
    'Michael Brown', 'Emily Davis', 'Robert Taylor', 'Lisa Anderson',
    'John Martinez', 'Jennifer Lee', 'William Thompson', 'Jessica White',
  ];

  final List<String> _vehicleModels = [
    'Toyota Camry', 'Honda Accord', 'Tesla Model 3', 'BMW 5 Series',
    'Mercedes E-Class', 'Hyundai Sonata', 'Chevrolet Malibu', 'Nissan Altima',
  ];

  final List<String> _vehicleColors = [
    'Black', 'White', 'Silver', 'Blue', 'Gray', 'Red', 'Pearl White', 'Midnight Black',
  ];

  final List<String> _streetNames = [
    'Market St', 'Mission St', 'Van Ness Ave', 'Geary Blvd',
    'Fillmore St', 'Haight St', 'Castro St', 'Divisadero St',
  ];

  final List<String> _placeNames = [
    'Union Square', 'Fisherman\'s Wharf', 'Golden Gate Park', 'Chinatown',
    'SOMA District', 'Financial District', 'North Beach', 'Pacific Heights',
  ];
}