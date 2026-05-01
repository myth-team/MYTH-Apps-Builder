import 'package:flutter/material.dart';
import 'package:ridenow_go_app/models/driver.dart'; 
import 'package:ridenow_go_app/models/location.dart'; 
import 'package:ridenow_go_app/models/payment_method.dart'; 

/// Types of ride services available.
enum RideType {
  economy,
  premium,
  shared,
  xl,
}

/// Status of a ride through its lifecycle.
enum RideStatus {
  searching,
  driverAssigned,
  driverEnRoute,
  driverArrived,
  inProgress,
  completed,
  cancelled,
}

/// Represents a complete ride in the ride-hailing system.
@immutable
class Ride {
  final String id;
  final RideType type;
  final RideStatus status;
  final LocationModel pickup;
  final LocationModel destination;
  final Driver? driver;
  final DateTime requestedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final double? estimatedFare;
  final double? finalFare;
  final double? distanceKm;
  final int? durationMinutes;
  final PaymentMethod? paymentMethod;
  final double? tipAmount;
  final String? cancellationReason;
  final String? promoCode;
  final double? discountAmount;
  final List<LocationModel>? routeWaypoints;

  const Ride({
    required this.id,
    required this.type,
    this.status = RideStatus.searching,
    required this.pickup,
    required this.destination,
    this.driver,
    required this.requestedAt,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
    this.estimatedFare,
    this.finalFare,
    this.distanceKm,
    this.durationMinutes,
    this.paymentMethod,
    this.tipAmount,
    this.cancellationReason,
    this.promoCode,
    this.discountAmount,
    this.routeWaypoints,
  });

  Ride copyWith({
    String? id,
    RideType? type,
    RideStatus? status,
    LocationModel? pickup,
    LocationModel? destination,
    Driver? driver,
    DateTime? requestedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    double? estimatedFare,
    double? finalFare,
    double? distanceKm,
    int? durationMinutes,
    PaymentMethod? paymentMethod,
    double? tipAmount,
    String? cancellationReason,
    String? promoCode,
    double? discountAmount,
    List<LocationModel>? routeWaypoints,
  }) {
    return Ride(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      pickup: pickup ?? this.pickup,
      destination: destination ?? this.destination,
      driver: driver ?? this.driver,
      requestedAt: requestedAt ?? this.requestedAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      estimatedFare: estimatedFare ?? this.estimatedFare,
      finalFare: finalFare ?? this.finalFare,
      distanceKm: distanceKm ?? this.distanceKm,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      tipAmount: tipAmount ?? this.tipAmount,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      promoCode: promoCode ?? this.promoCode,
      discountAmount: discountAmount ?? this.discountAmount,
      routeWaypoints: routeWaypoints ?? this.routeWaypoints,
    );
  }

  /// Display name for the ride type.
  String get typeDisplay {
    switch (type) {
      case RideType.economy:
        return 'Economy';
      case RideType.premium:
        return 'Premium';
      case RideType.shared:
        return 'Shared';
      case RideType.xl:
        return 'XL';
    }
  }

  /// Current fare to display (estimated or final).
  double? get displayFare => finalFare ?? estimatedFare;

  /// Formatted fare string.
  String? get fareDisplay {
    final fare = displayFare;
    if (fare == null) return null;
    return '\$${fare.toStringAsFixed(2)}';
  }

  /// Whether the ride is currently active.
  bool get isActive =>
      status == RideStatus.searching ||
      status == RideStatus.driverAssigned ||
      status == RideStatus.driverEnRoute ||
      status == RideStatus.driverArrived ||
      status == RideStatus.inProgress;

  /// Whether the ride has been completed.
  bool get isCompleted => status == RideStatus.completed;

  /// Whether the ride was cancelled.
  bool get isCancelled => status == RideStatus.cancelled;

  /// Whether a driver has been assigned.
  bool get hasDriver => driver != null;

  /// Total amount paid including tip.
  double? get totalPaid {
    if (finalFare == null) return null;
    return finalFare! + (tipAmount ?? 0.0) - (discountAmount ?? 0.0);
  }

  /// Display string for total amount.
  String? get totalPaidDisplay {
    final total = totalPaid;
    if (total == null) return null;
    return '\$${total.toStringAsFixed(2)}';
  }

  /// Duration of the ride if completed.
  Duration? get rideDuration {
    if (startedAt == null || completedAt == null) return null;
    return completedAt!.difference(startedAt!);
  }

  /// Formatted duration string.
  String? get durationDisplay {
    if (durationMinutes != null) {
      final hours = durationMinutes! ~/ 60;
      final mins = durationMinutes! % 60;
      if (hours > 0) {
        return '${hours}h ${mins}m';
      }
      return '${mins}m';
    }
    final duration = rideDuration;
    if (duration == null) return null;
    final hours = duration.inHours;
    final mins = duration.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${mins}m';
    }
    return '${mins}m';
  }

  /// Formatted distance string.
  String? get distanceDisplay {
    if (distanceKm == null) return null;
    if (distanceKm! < 1.0) {
      return '${(distanceKm! * 1000).toStringAsFixed(0)} m';
    }
    return '${distanceKm!.toStringAsFixed(1)} km';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ride &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Ride($id, $type, $status)';
}