import 'dart:async';
import 'package:ridenow_app/models/ride.dart'; 
import 'package:ridenow_app/models/driver.dart'; 
import 'package:ridenow_app/models/location.dart' as app;
import 'package:ridenow_app/utils/colors.dart'; 
import 'package:flutter/material.dart';

enum RideServiceState {
  idle,
  loading,
  estimating,
  booking,
  tracking,
  error,
}

class RideService extends ChangeNotifier {
  RideServiceState _state = RideServiceState.idle;
  String? _errorMessage;
  
  Ride? _activeRide;
  List<Ride> _rideHistory = [];
  Map<RideType, RidePricing> _pricingCache = {};
  Map<RideType, double> _estimatedDistances = {};
  Map<RideType, Duration> _estimatedDurations = {};
  
  Timer? _statusPollingTimer;
  Timer? _driverTrackingTimer;
  StreamController<Ride>? _rideUpdatesController;
  
  RideServiceState get state => _state;
  String? get errorMessage => _errorMessage;
  Ride? get activeRide => _activeRide;
  List<Ride> get rideHistory => List.unmodifiable(_rideHistory);
  bool get hasActiveRide => _activeRide != null && _activeRide!.isActive;
  bool get isLoading => _state == RideServiceState.loading || 
                        _state == RideServiceState.estimating || 
                        _state == RideServiceState.booking;

  Stream<Ride>? get rideUpdates => _rideUpdatesController?.stream;

  Future<void> initialize() async {
    _initializePricing();
  }

  void _initializePricing() {
    _pricingCache = {
      RideType.economy: RidePricing.economy(),
      RideType.comfort: RidePricing.comfort(),
      RideType.premium: RidePricing.premium(),
      RideType.xl: RidePricing.xl(),
    };
  }

  Future<Map<RideType, RideEstimate>> getRideEstimates({
    required app.Location pickup,
    required app.Location destination,
  }) async {
    _state = RideServiceState.estimating;
    _errorMessage = null;
    notifyListeners();

    try {
      final distance = pickup.distanceTo(destination);
      final duration = _estimateDuration(distance);

      final estimates = <RideType, RideEstimate>{};
      
      for (final type in RideType.values) {
        final pricing = _pricingCache[type]!;
        final estimatedPrice = pricing.calculatePrice(distance, duration);
        
        _estimatedDistances[type] = distance;
        _estimatedDurations[type] = duration;

        estimates[type] = RideEstimate(
          rideType: type,
          estimatedPrice: estimatedPrice,
          estimatedDuration: duration,
          distance: distance,
          availableDrivers: _getAvailableDrivers(type),
        );
      }

      _state = RideServiceState.idle;
      notifyListeners();
      return estimates;
    } catch (e) {
      _state = RideServiceState.error;
      _errorMessage = 'Failed to get ride estimates: ${e.toString()}';
      notifyListeners();
      return {};
    }
  }

  Duration _estimateDuration(double distanceKm) {
    const double avgSpeedKmh = 30.0;
    final hours = distanceKm / avgSpeedKmh;
    final minutes = (hours * 60).round();
    return Duration(minutes: minutes.clamp(1, 180));
  }

  int _getAvailableDrivers(RideType type) {
    switch (type) {
      case RideType.economy:
        return 12;
      case RideType.comfort:
        return 6;
      case RideType.premium:
        return 3;
      case RideType.xl:
        return 4;
    }
  }

  Future<Ride?> createRide({
    required app.Location pickup,
    required app.Location destination,
    required RideType rideType,
    String? userId,
  }) async {
    _state = RideServiceState.booking;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      final pricing = _pricingCache[rideType]!;
      final distance = _estimatedDistances[rideType] ?? pickup.distanceTo(destination);
      final duration = _estimatedDurations[rideType] ?? _estimateDuration(distance);
      final estimatedPrice = pricing.calculatePrice(distance, duration);

      final ride = Ride(
        id: 'ride_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId ?? 'user_1',
        pickupLocation: pickup,
        destinationLocation: destination,
        status: RideStatus.pending,
        rideType: rideType,
        estimatedPrice: estimatedPrice,
        estimatedDuration: duration,
        createdAt: DateTime.now(),
        distance: distance,
        routePoints: _generateRoutePoints(pickup, destination),
      );

      _activeRide = ride;
      _rideUpdatesController = StreamController<Ride>.broadcast();
      
      _startStatusPolling();
      
      _state = RideServiceState.tracking;
      notifyListeners();
      return ride;
    } catch (e) {
      _state = RideServiceState.error;
      _errorMessage = 'Failed to create ride: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }

  List<app.Location> _generateRoutePoints(app.Location pickup, app.Location destination) {
    final points = <app.Location>[];
    const int steps = 5;
    
    for (int i = 0; i <= steps; i++) {
      final fraction = i / steps;
      final lat = pickup.latitude + (destination.latitude - pickup.latitude) * fraction;
      final lng = pickup.longitude + (destination.longitude - pickup.longitude) * fraction;
      
      points.add(app.Location(
        latitude: lat,
        longitude: lng,
        address: i == 0 ? pickup.address : (i == steps ? destination.address : 'Route point $i'),
      ));
    }
    
    return points;
  }

  void _startStatusPolling() {
    _statusPollingTimer?.cancel();
    _statusPollingTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _checkRideStatus(),
    );
  }

  Future<void> _checkRideStatus() async {
    if (_activeRide == null) return;

    try {
      Ride updatedRide = _activeRide!;
      
      switch (_activeRide!.status) {
        case RideStatus.pending:
          await Future.delayed(const Duration(seconds: 2));
          updatedRide = _simulateDriverAccepted();
          break;
        case RideStatus.accepted:
          await Future.delayed(const Duration(seconds: 3));
          updatedRide = _simulateDriverArriving();
          break;
        case RideStatus.arriving:
          await Future.delayed(const Duration(seconds: 4));
          updatedRide = _simulateRideStarted();
          break;
        case RideStatus.inProgress:
          await Future.delayed(const Duration(seconds: 5));
          updatedRide = _simulateRideCompleted();
          break;
        case RideStatus.completed:
        case RideStatus.cancelled:
          _statusPollingTimer?.cancel();
          _driverTrackingTimer?.cancel();
          break;
      }

      _activeRide = updatedRide;
      _rideUpdatesController?.add(updatedRide);
      notifyListeners();

      if (updatedRide.isCompleted || updatedRide.isCancelled) {
        _statusPollingTimer?.cancel();
        _driverTrackingTimer?.cancel();
        _addToHistory(updatedRide);
      }
    } catch (e) {
      debugPrint('Error checking ride status: $e');
    }
  }

  Ride _simulateDriverAccepted() {
    final driver = Driver(
      id: 'driver_1',
      name: 'Michael Johnson',
      rating: 4.9,
      vehicleInfo: VehicleInfo(
        model: 'Toyota Camry',
        color: 'Silver',
        licensePlate: 'ABC 1234',
      ),
      phoneNumber: '+1234567890',
      isOnline: true,
      currentLocation: app.Location(
        latitude: _activeRide!.pickupLocation.latitude + 0.01,
        longitude: _activeRide!.pickupLocation.longitude + 0.01,
        address: 'Nearby',
      ),
    );

    return _activeRide!.copyWith(
      driver: driver,
      status: RideStatus.accepted,
      eta: DateTime.now().add(const Duration(minutes: 8)),
      driverLocation: driver.currentLocation,
    );
  }

  Ride _simulateDriverArriving() {
    return _activeRide!.copyWith(
      status: RideStatus.arriving,
      eta: DateTime.now().add(const Duration(minutes: 2)),
      driverLocation: app.Location(
        latitude: _activeRide!.pickupLocation.latitude + 0.002,
        longitude: _activeRide!.pickupLocation.longitude + 0.002,
        address: 'Almost there',
      ),
    );
  }

  Ride _simulateRideStarted() {
    _startDriverTracking();
    return _activeRide!.copyWith(
      status: RideStatus.inProgress,
      eta: null,
    );
  }

  void _startDriverTracking() {
    _driverTrackingTimer?.cancel();
    int step = 0;
    
    _driverTrackingTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) {
        if (_activeRide == null || _activeRide!.status != RideStatus.inProgress) {
          _driverTrackingTimer?.cancel();
          return;
        }
        
        step++;
        final pickup = _activeRide!.pickupLocation;
        final dest = _activeRide!.destinationLocation;
        
        final progress = step * 0.15;
        if (progress >= 1.0) return;
        
        final currentLat = pickup.latitude + (dest.latitude - pickup.latitude) * progress;
        final currentLng = pickup.longitude + (dest.longitude - pickup.longitude) * progress;
        
        _activeRide = _activeRide!.copyWith(
          driverLocation: app.Location(
            latitude: currentLat,
            longitude: currentLng,
            address: 'En route',
          ),
        );
        
        _rideUpdatesController?.add(_activeRide!);
        notifyListeners();
      },
    );
  }

  Ride _simulateRideCompleted() {
    _driverTrackingTimer?.cancel();
    
    final basePrice = _activeRide!.estimatedPrice;
    final finalPrice = basePrice * (0.9 + (DateTime.now().millisecond % 20) / 100);
    
    return _activeRide!.copyWith(
      status: RideStatus.completed,
      actualPrice: finalPrice,
      completedAt: DateTime.now(),
      driverLocation: _activeRide!.destinationLocation,
    );
  }

  Future<bool> cancelRide({String? reason}) async {
    if (_activeRide == null || !_activeRide!.isActive) {
      _errorMessage = 'No active ride to cancel';
      notifyListeners();
      return false;
    }

    try {
      await Future.delayed(const Duration(seconds: 1));

      _activeRide = _activeRide!.copyWith(
        status: RideStatus.cancelled,
        cancellationReason: reason ?? 'User cancelled',
        completedAt: DateTime.now(),
      );

      _statusPollingTimer?.cancel();
      _driverTrackingTimer?.cancel();
      
      _addToHistory(_activeRide!);
      notifyListeners();
      
      return true;
    } catch (e) {
      _errorMessage = 'Failed to cancel ride: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  void _addToHistory(Ride ride) {
    _rideHistory.insert(0, ride);
  }

  Future<List<Ride>> loadRideHistory({String? userId, int limit = 20}) async {
    _state = RideServiceState.loading;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (userId != null) {
        _rideHistory = _rideHistory.where((r) => r.userId == userId).toList();
      }
      
      if (_rideHistory.isEmpty) {
        _rideHistory = _generateMockHistory();
      }

      _state = RideServiceState.idle;
      notifyListeners();
      return _rideHistory.take(limit).toList();
    } catch (e) {
      _state = RideServiceState.error;
      _errorMessage = 'Failed to load ride history: ${e.toString()}';
      notifyListeners();
      return [];
    }
  }

  List<Ride> _generateMockHistory() {
    final now = DateTime.now();
    return [
      Ride(
        id: 'ride_history_1',
        userId: 'user_1',
        pickupLocation: const app.Location(
          latitude: 37.7749,
          longitude: -122.4194,
          address: '123 Main St, San Francisco, CA',
        ),
        destinationLocation: const app.Location(
          latitude: 37.7849,
          longitude: -122.4094,
          address: '456 Market St, San Francisco, CA',
        ),
        status: RideStatus.completed,
        rideType: RideType.comfort,
        estimatedPrice: 15.50,
        actualPrice: 14.25,
        estimatedDuration: const Duration(minutes: 20),
        createdAt: now.subtract(const Duration(days: 1)),
        completedAt: now.subtract(const Duration(days: 1)).add(const Duration(minutes: 25)),
        distance: 5.2,
      ),
      Ride(
        id: 'ride_history_2',
        userId: 'user_1',
        pickupLocation: const app.Location(
          latitude: 37.7649,
          longitude: -122.4294,
          address: '789 Mission St, San Francisco, CA',
        ),
        destinationLocation: const app.Location(
          latitude: 37.7949,
          longitude: -122.3994,
          address: '101 Howard St, San Francisco, CA',
        ),
        status: RideStatus.completed,
        rideType: RideType.economy,
        estimatedPrice: 12.00,
        actualPrice: 11.50,
        estimatedDuration: const Duration(minutes: 15),
        createdAt: now.subtract(const Duration(days: 3)),
        completedAt: now.subtract(const Duration(days: 3)).add(const Duration(minutes: 18)),
        distance: 4.1,
      ),
      Ride(
        id: 'ride_history_3',
        userId: 'user_1',
        pickupLocation: const app.Location(
          latitude: 37.7549,
          longitude: -122.4394,
          address: '202 Folsom St, San Francisco, CA',
        ),
        destinationLocation: const app.Location(
          latitude: 37.7749,
          longitude: -122.4194,
          address: '303 Bryant St, San Francisco, CA',
        ),
        status: RideStatus.cancelled,
        rideType: RideType.premium,
        estimatedPrice: 25.00,
        estimatedDuration: const Duration(minutes: 18),
        createdAt: now.subtract(const Duration(days: 5)),
        completedAt: now.subtract(const Duration(days: 5)),
        distance: 3.8,
        cancellationReason: 'Driver not found',
      ),
    ];
  }

  Future<Ride?> getRideDetails(String rideId) async {
    try {
      if (_activeRide?.id == rideId) {
        return _activeRide;
      }
      return _rideHistory.firstWhere((r) => r.id == rideId);
    } catch (_) {
      return null;
    }
  }

  void clearActiveRide() {
    _statusPollingTimer?.cancel();
    _driverTrackingTimer?.cancel();
    _rideUpdatesController?.close();
    _activeRide = null;
    _state = RideServiceState.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    _statusPollingTimer?.cancel();
    _driverTrackingTimer?.cancel();
    _rideUpdatesController?.close();
    super.dispose();
  }
}

class RideEstimate {
  final RideType rideType;
  final double estimatedPrice;
  final Duration estimatedDuration;
  final double distance;
  final int availableDrivers;

  RideEstimate({
    required this.rideType,
    required this.estimatedPrice,
    required this.estimatedDuration,
    required this.distance,
    required this.availableDrivers,
  });

  String get formattedPrice => '\$${estimatedPrice.toStringAsFixed(2)}';
  
  String get formattedDistance {
    if (distance < 1) {
      return '${(distance * 1000).toInt()} m';
    }
    return '${distance.toStringAsFixed(1)} km';
  }

  String get formattedDuration {
    final minutes = estimatedDuration.inMinutes;
    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) {
      return '$hours hr';
    }
    return '$hours hr $remainingMinutes min';
  }
}