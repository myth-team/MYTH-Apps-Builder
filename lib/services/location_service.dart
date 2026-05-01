import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ridenow_go_app/models/location.dart'; 

/// Service for managing device location, permissions, and geocoding operations.
/// Provides streams for live location updates and utilities for location calculations.
class LocationService {
  LocationService._();
  static final LocationService _instance = LocationService._();
  static LocationService get instance => _instance;

  StreamSubscription<Position>? _positionSubscription;
  final StreamController<LocationModel> _locationController = StreamController<LocationModel>.broadcast();
  final StreamController<LocationModel> _headingController = StreamController<LocationModel>.broadcast();

  /// Stream of location updates for live tracking.
  Stream<LocationModel> get locationStream => _locationController.stream;

  /// Stream of heading/compass updates.
  Stream<LocationModel> get headingStream => _headingController.stream;

  /// Current cached location.
  LocationModel? _currentLocation;
  LocationModel? get currentLocation => _currentLocation;

  /// Whether location tracking is active.
  bool get isTracking => _positionSubscription != null;

  /// Check and request location permissions.
  Future<bool> checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Open device location settings.
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Open app settings for permission management.
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  /// Get current position as a one-time fetch.
  Future<LocationModel?> getCurrentPosition() async {
    final hasPermission = await checkPermissions();
    if (!hasPermission) return null;

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final location = _positionToLocationModel(position);
      _currentLocation = location;
      return location;
    } catch (e) {
      return null;
    }
  }

  /// Start continuous location tracking.
  Future<bool> startTracking({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilterMeters = 10,
    Duration? interval,
  }) async {
    final hasPermission = await checkPermissions();
    if (!hasPermission) return false;

    await stopTracking();

    final locationSettings = AndroidSettings(
      accuracy: accuracy,
      distanceFilter: distanceFilterMeters,
      intervalDuration: interval ?? const Duration(seconds: 5),
      foregroundNotificationConfig: const ForegroundNotificationConfig(
        notificationText: 'RideNow is tracking your location for the ride',
        notificationTitle: 'Location Active',
        enableWakeLock: true,
      ),
    );

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (position) {
        final location = _positionToLocationModel(position);
        _currentLocation = location;
        _locationController.add(location);
      },
      onError: (error) {
        _locationController.addError(error);
      },
    );

    return true;
  }

  /// Stop continuous location tracking.
  Future<void> stopTracking() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  /// Get address from coordinates (reverse geocoding).
  /// Returns a LocationModel with address information.
  Future<LocationModel?> reverseGeocode(double latitude, double longitude) async {
    // In production, integrate with Google Geocoding API or similar
    // For now, return a placeholder with coordinates
    return LocationModel(
      latitude: latitude,
      longitude: longitude,
      address: '$latitude, $longitude',
    );
  }

  /// Search for locations by query string.
  /// Returns list of matching LocationModel results.
  Future<List<LocationModel>> searchLocations(String query) async {
    if (query.trim().isEmpty) return [];

    // In production, integrate with Google Places API or similar
    // Returning mock results for development
    await Future.delayed(Duration(milliseconds: 300));

    return [
      LocationModel(
        latitude: 37.7749,
        longitude: -122.4194,
        address: '123 Market St, San Francisco, CA',
        placeName: 'Market Street',
        city: 'San Francisco',
      ),
      LocationModel(
        latitude: 37.7849,
        longitude: -122.4094,
        address: '456 Mission St, San Francisco, CA',
        placeName: 'Mission District',
        city: 'San Francisco',
      ),
    ];
  }

  /// Calculate distance between two locations in kilometers.
  double distanceBetween(LocationModel from, LocationModel to) {
    return Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    ) / 1000;
  }

  /// Calculate estimated travel time in minutes based on distance and average speed.
  /// Assumes urban driving at ~30 km/h average.
  int estimateTravelTimeMinutes(double distanceKm, {double averageSpeedKmh = 30}) {
    return ((distanceKm / averageSpeedKmh) * 60).ceil();
  }

  /// Dispose resources.
  void dispose() {
    stopTracking();
    _locationController.close();
    _headingController.close();
  }

  LocationModel _positionToLocationModel(Position position) {
    return LocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
      address: '${position.latitude}, ${position.longitude}',
    );
  }
}