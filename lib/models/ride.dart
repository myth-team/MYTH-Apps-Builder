import 'driver.dart';
import 'location.dart';

enum RideStatus {
  pending,
  accepted,
  arriving,
  inProgress,
  completed,
  cancelled,
}

enum RideType {
  economy,
  comfort,
  premium,
  xl,
}

class Ride {
  final String id;
  final String userId;
  final Driver? driver;
  final Location pickupLocation;
  final Location destinationLocation;
  final RideStatus status;
  final RideType rideType;
  final double estimatedPrice;
  final double? actualPrice;
  final Duration estimatedDuration;
  final DateTime? eta;
  final DateTime createdAt;
  final DateTime? completedAt;
  final Location? driverLocation;
  final double distance;
  final String? cancellationReason;
  final List<Location>? routePoints;

  const Ride({
    required this.id,
    required this.userId,
    this.driver,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.status,
    required this.rideType,
    required this.estimatedPrice,
    this.actualPrice,
    required this.estimatedDuration,
    this.eta,
    required this.createdAt,
    this.completedAt,
    this.driverLocation,
    required this.distance,
    this.cancellationReason,
    this.routePoints,
  });

  Ride copyWith({
    String? id,
    String? userId,
    Driver? driver,
    Location? pickupLocation,
    Location? destinationLocation,
    RideStatus? status,
    RideType? rideType,
    double? estimatedPrice,
    double? actualPrice,
    Duration? estimatedDuration,
    DateTime? eta,
    DateTime? createdAt,
    DateTime? completedAt,
    Location? driverLocation,
    double? distance,
    String? cancellationReason,
    List<Location>? routePoints,
  }) {
    return Ride(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      driver: driver ?? this.driver,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      status: status ?? this.status,
      rideType: rideType ?? this.rideType,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      actualPrice: actualPrice ?? this.actualPrice,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      eta: eta ?? this.eta,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      driverLocation: driverLocation ?? this.driverLocation,
      distance: distance ?? this.distance,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      routePoints: routePoints ?? this.routePoints,
    );
  }

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'] as String,
      userId: json['userId'] as String,
      driver: json['driver'] != null
          ? Driver.fromJson(json['driver'] as Map<String, dynamic>)
          : null,
      pickupLocation: Location.fromJson(json['pickupLocation'] as Map<String, dynamic>),
      destinationLocation: Location.fromJson(json['destinationLocation'] as Map<String, dynamic>),
      status: RideStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => RideStatus.pending,
      ),
      rideType: RideType.values.firstWhere(
        (e) => e.name == json['rideType'],
        orElse: () => RideType.economy,
      ),
      estimatedPrice: (json['estimatedPrice'] as num).toDouble(),
      actualPrice: json['actualPrice'] != null
          ? (json['actualPrice'] as num).toDouble()
          : null,
      estimatedDuration: Duration(minutes: json['estimatedDurationMinutes'] as int? ?? 0),
      eta: json['eta'] != null
          ? DateTime.parse(json['eta'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      driverLocation: json['driverLocation'] != null
          ? Location.fromJson(json['driverLocation'] as Map<String, dynamic>)
          : null,
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      cancellationReason: json['cancellationReason'] as String?,
      routePoints: json['routePoints'] != null
          ? (json['routePoints'] as List)
              .map((e) => Location.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'driver': driver?.toJson(),
      'pickupLocation': pickupLocation.toJson(),
      'destinationLocation': destinationLocation.toJson(),
      'status': status.name,
      'rideType': rideType.name,
      'estimatedPrice': estimatedPrice,
      'actualPrice': actualPrice,
      'estimatedDurationMinutes': estimatedDuration.inMinutes,
      'eta': eta?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'driverLocation': driverLocation?.toJson(),
      'distance': distance,
      'cancellationReason': cancellationReason,
      'routePoints': routePoints?.map((e) => e.toJson()).toList(),
    };
  }

  String get statusDisplayName {
    switch (status) {
      case RideStatus.pending:
        return 'Finding your driver...';
      case RideStatus.accepted:
        return 'Driver accepted';
      case RideStatus.arriving:
        return 'Driver arriving';
      case RideStatus.inProgress:
        return 'Ride in progress';
      case RideStatus.completed:
        return 'Ride completed';
      case RideStatus.cancelled:
        return 'Ride cancelled';
    }
  }

  String get rideTypeDisplayName {
    switch (rideType) {
      case RideType.economy:
        return 'Economy';
      case RideType.comfort:
        return 'Comfort';
      case RideType.premium:
        return 'Premium';
      case RideType.xl:
        return 'XL';
    }
  }

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

  String get formattedPrice => '\$${estimatedPrice.toStringAsFixed(2)}';

  String get formattedActualPrice =>
      actualPrice != null ? '\$${actualPrice!.toStringAsFixed(2)}' : '';

  bool get isActive =>
      status == RideStatus.pending ||
      status == RideStatus.accepted ||
      status == RideStatus.arriving ||
      status == RideStatus.inProgress;

  bool get isCompleted => status == RideStatus.completed;

  bool get isCancelled => status == RideStatus.cancelled;
}

class RidePricing {
  final RideType rideType;
  final double basePrice;
  final double pricePerKm;
  final double pricePerMinute;
  final double serviceFee;
  final double minimumFare;

  const RidePricing({
    required this.rideType,
    required this.basePrice,
    required this.pricePerKm,
    required this.pricePerMinute,
    required this.serviceFee,
    required this.minimumFare,
  });

  double calculatePrice(double distanceKm, Duration duration) {
    final distanceCost = distanceKm * pricePerKm;
    final timeCost = duration.inMinutes * pricePerMinute;
    final total = basePrice + distanceCost + timeCost + serviceFee;
    return total < minimumFare ? minimumFare : total;
  }

  factory RidePricing.economy() {
    return const RidePricing(
      rideType: RideType.economy,
      basePrice: 2.50,
      pricePerKm: 1.25,
      pricePerMinute: 0.20,
      serviceFee: 1.50,
      minimumFare: 5.00,
    );
  }

  factory RidePricing.comfort() {
    return const RidePricing(
      rideType: RideType.comfort,
      basePrice: 4.00,
      pricePerKm: 1.75,
      pricePerMinute: 0.30,
      serviceFee: 2.00,
      minimumFare: 8.00,
    );
  }

  factory RidePricing.premium() {
    return const RidePricing(
      rideType: RideType.premium,
      basePrice: 6.00,
      pricePerKm: 2.50,
      pricePerMinute: 0.45,
      serviceFee: 2.50,
      minimumFare: 12.00,
    );
  }

  factory RidePricing.xl() {
    return const RidePricing(
      rideType: RideType.xl,
      basePrice: 5.00,
      pricePerKm: 2.00,
      pricePerMinute: 0.35,
      serviceFee: 2.00,
      minimumFare: 10.00,
    );
  }

  static RidePricing forType(RideType type) {
    switch (type) {
      case RideType.economy:
        return RidePricing.economy();
      case RideType.comfort:
        return RidePricing.comfort();
      case RideType.premium:
        return RidePricing.premium();
      case RideType.xl:
        return RidePricing.xl();
    }
  }
}