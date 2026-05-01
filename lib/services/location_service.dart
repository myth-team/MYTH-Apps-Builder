import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as GeocodingPlacemark;
import 'package:ridenow_app/models/location.dart' as app;
import 'package:ridenow_app/utils/colors.dart'; 
import 'package:flutter/material.dart';

enum LocationServiceState {
  idle,
  loading,
  loaded,
  error,
  permissionDenied,
  serviceDisabled,
}

class LocationService extends ChangeNotifier {
  LocationServiceState _state = LocationServiceState.idle;
  app.Location? _currentLocation;
  String? _errorMessage;
  StreamSubscription<Position>? _positionStreamSubscription;
  
  LocationServiceState get state => _state;
  app.Location? get currentLocation => _currentLocation;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == LocationServiceState.loading;

  Future<bool> checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _state = LocationServiceState.serviceDisabled;
      _errorMessage = 'Location services are disabled. Please enable them in settings.';
      notifyListeners();
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _state = LocationServiceState.permissionDenied;
        _errorMessage = 'Location permission denied.';
        notifyListeners();
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _state = LocationServiceState.permissionDenied;
      _errorMessage = 'Location permission permanently denied. Please enable in settings.';
      notifyListeners();
      return false;
    }

    return true;
  }

  Future<app.Location?> getCurrentLocation() async {
    _state = LocationServiceState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final hasPermission = await checkPermissions();
      if (!hasPermission) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final address = await _reverseGeocode(
        position.latitude,
        position.longitude,
      );

      _currentLocation = app.Location(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address ?? 'Current Location',
      );

      _state = LocationServiceState.loaded;
      notifyListeners();
      return _currentLocation;
    } catch (e) {
      _state = LocationServiceState.error;
      _errorMessage = 'Failed to get current location: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }

  void startLocationUpdates({
    int distanceFilterMeters = 10,
    Function(app.Location)? onLocationUpdate,
  }) {
    _positionStreamSubscription?.cancel();

    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: distanceFilterMeters,
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) async {
        if (_currentLocation == null || 
            position.latitude != _currentLocation!.latitude ||
            position.longitude != _currentLocation!.longitude) {
          
          final address = await _reverseGeocode(
            position.latitude,
            position.longitude,
          );

          _currentLocation = app.Location(
            latitude: position.latitude,
            longitude: position.longitude,
            address: address ?? 'Current Location',
          );

          _state = LocationServiceState.loaded;
          notifyListeners();
          
          onLocationUpdate?.call(_currentLocation!);
        }
      },
      onError: (error) {
        debugPrint('Location stream error: $error');
      },
    );
  }

  void stopLocationUpdates() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }

  Future<String?> _reverseGeocode(double latitude, double longitude) async {
    try {
      final placemarks = await GeocodingPlacemark.placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final parts = <String>[];
        
        if (place.street != null && place.street!.isNotEmpty) {
          parts.add(place.street!);
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          parts.add(place.locality!);
        }
        if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
          parts.add(place.administrativeArea!);
        }
        
        return parts.isNotEmpty ? parts.join(', ') : null;
      }
      return null;
    } catch (e) {
      debugPrint('Reverse geocode error: $e');
      return null;
    }
  }

  Future<List<app.Location>> searchLocations(String query) async {
    if (query.isEmpty || query.length < 3) {
      return [];
    }

    try {
      final placemarks = await GeocodingPlacemark.placemarkFromAddress('$query, USA');
      
      return placemarks.map((place) {
        return app.Location(
          latitude: place.coordinates?.latitude ?? 0,
          longitude: place.coordinates?.longitude ?? 0,
          address: place.street ?? query,
          placeId: null,
          city: place.locality,
          state: place.administrativeArea,
          country: place.country,
          zipCode: place.postalCode,
        );
      }).toList();
    } catch (e) {
      debugPrint('Search locations error: $e');
      return [];
    }
  }

  Future<app.Location?> getLocationFromAddress(String address) async {
    try {
      final placemarks = await GeocodingPlacemark.placemarkFromAddress(address);
      
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return app.Location(
          latitude: place.coordinates?.latitude ?? 0,
          longitude: place.coordinates?.longitude ?? 0,
          address: address,
          city: place.locality,
          state: place.administrativeArea,
          country: place.country,
          zipCode: place.postalCode,
        );
      }
      return null;
    } catch (e) {
      debugPrint('Get location from address error: $e');
      return null;
    }
  }

  double calculateDistance(app.Location from, app.Location to) {
    return from.distanceTo(to);
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  @override
  void dispose() {
    stopLocationUpdates();
    super.dispose();
  }
}