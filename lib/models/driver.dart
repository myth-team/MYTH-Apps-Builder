import 'package:flutter/material.dart';
import 'package:ridenow_go_app/models/location.dart'; 

/// Driver status during the ride lifecycle.
enum DriverStatus {
  available,
  enRoute,
  arrived,
  inTrip,
  offline,
}

/// Represents a driver in the ride-hailing system.
@immutable
class Driver {
  final String id;
  final String name;
  final String? photoUrl;
  final String phoneNumber;
  final String licensePlate;
  final String vehicleModel;
  final String vehicleColor;
  final double rating;
  final int totalTrips;
  final DriverStatus status;
  final LocationModel? currentLocation;
  final double? etaMinutes;

  const Driver({
    required this.id,
    required this.name,
    this.photoUrl,
    required this.phoneNumber,
    required this.licensePlate,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.rating,
    required this.totalTrips,
    this.status = DriverStatus.offline,
    this.currentLocation,
    this.etaMinutes,
  });

  Driver copyWith({
    String? id,
    String? name,
    String? photoUrl,
    String? phoneNumber,
    String? licensePlate,
    String? vehicleModel,
    String? vehicleColor,
    double? rating,
    int? totalTrips,
    DriverStatus? status,
    LocationModel? currentLocation,
    double? etaMinutes,
  }) {
    return Driver(
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      licensePlate: licensePlate ?? this.licensePlate,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleColor: vehicleColor ?? this.vehicleColor,
      rating: rating ?? this.rating,
      totalTrips: totalTrips ?? this.totalTrips,
      status: status ?? this.status,
      currentLocation: currentLocation ?? this.currentLocation,
      etaMinutes: etaMinutes ?? this.etaMinutes,
    );
  }

  /// Display string for the vehicle.
  String get vehicleDisplay => '$vehicleColor $vehicleModel';

  /// Formatted rating display.
  String get ratingDisplay => rating.toStringAsFixed(1);

  /// Whether the driver is currently available for rides.
  bool get isAvailable => status == DriverStatus.available;

  /// Whether the driver is en route to pickup.
  bool get isEnRoute => status == DriverStatus.enRoute;

  /// Whether the driver has arrived at pickup.
  bool get hasArrived => status == DriverStatus.arrived;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Driver &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Driver($id, $name, $vehicleDisplay)';
}