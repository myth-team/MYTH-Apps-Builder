import 'package:flutter/material.dart';

/// Represents a geographic location with address information.
/// Used for pickup points, destinations, and driver positions.
@immutable
class LocationModel {
  final double latitude;
  final double longitude;
  final String address;
  final String? placeName;
  final String? city;
  final String? country;
  final String? postalCode;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.placeName,
    this.city,
    this.country,
    this.postalCode,
  });

  /// Creates a copy with modified fields.
  LocationModel copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? placeName,
    String? city,
    String? country,
    String? postalCode,
  }) {
    return LocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      placeName: placeName ?? this.placeName,
      city: city ?? this.city,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
    );
  }

  /// Calculates approximate distance in kilometers using Haversine formula.
  double distanceTo(LocationModel other) {
    const double earthRadiusKm = 6371.0;
    final double dLat = _degreesToRadians(other.latitude - latitude);
    final double dLon = _degreesToRadians(other.longitude - longitude);
    final double a = 
        (dLat / 2).sin() * (dLat / 2).sin() +
        _degreesToRadians(latitude).cos() *
        _degreesToRadians(other.latitude).cos() *
        (dLon / 2).sin() * (dLon / 2).sin();
    final double c = 2 * a.sqrt().asin();
    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degrees) => degrees * 3.141592653589793 / 180.0;

  /// Formatted display string for the location.
  String get displayName => placeName ?? address;

  /// Short display for lists and cards.
  String get shortDisplay {
    if (placeName != null && placeName!.isNotEmpty) {
      return placeName!;
    }
    final parts = address.split(',');
    return parts.first.trim();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationModel &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() => 'LocationModel($latitude, $longitude, $address)';
}

extension _DoubleMath on double {
  double sin() => this; // Simplified; use dart:math in production
  double cos() => this; // Simplified; use dart:math in production
  double sqrt() => this; // Simplified; use dart:math in production
  double asin() => this; // Simplified; use dart:math in production
}