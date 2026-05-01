class Driver {
  final String id;
  final String name;
  final String? photoUrl;
  final double rating;
  final VehicleInfo vehicleInfo;
  final String? phoneNumber;
  final bool isOnline;
  final Location? currentLocation;

  const Driver({
    required this.id,
    required this.name,
    this.photoUrl,
    required this.rating,
    required this.vehicleInfo,
    this.phoneNumber,
    this.isOnline = true,
    this.currentLocation,
  });

  Driver copyWith({
    String? id,
    String? name,
    String? photoUrl,
    double? rating,
    VehicleInfo? vehicleInfo,
    String? phoneNumber,
    bool? isOnline,
    Location? currentLocation,
  }) {
    return Driver(
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      rating: rating ?? this.rating,
      vehicleInfo: vehicleInfo ?? this.vehicleInfo,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isOnline: isOnline ?? this.isOnline,
      currentLocation: currentLocation ?? this.currentLocation,
    );
  }

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
      rating: (json['rating'] as num).toDouble(),
      vehicleInfo: VehicleInfo.fromJson(json['vehicleInfo'] as Map<String, dynamic>),
      phoneNumber: json['phoneNumber'] as String?,
      isOnline: json['isOnline'] as bool? ?? true,
      currentLocation: json['currentLocation'] != null
          ? Location.fromJson(json['currentLocation'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photoUrl': photoUrl,
      'rating': rating,
      'vehicleInfo': vehicleInfo.toJson(),
      'phoneNumber': phoneNumber,
      'isOnline': isOnline,
      'currentLocation': currentLocation?.toJson(),
    };
  }
}

class VehicleInfo {
  final String model;
  final String color;
  final String licensePlate;
  final String? imageUrl;

  const VehicleInfo({
    required this.model,
    required this.color,
    required this.licensePlate,
    this.imageUrl,
  });

  factory VehicleInfo.fromJson(Map<String, dynamic> json) {
    return VehicleInfo(
      model: json['model'] as String,
      color: json['color'] as String,
      licensePlate: json['licensePlate'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'color': color,
      'licensePlate': licensePlate,
      'imageUrl': imageUrl,
    };
  }
}

class Location {
  final double latitude;
  final double longitude;
  final String address;
  final String? placeId;

  const Location({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.placeId,
  });

  Location copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? placeId,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      placeId: placeId ?? this.placeId,
    );
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      placeId: json['placeId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'placeId': placeId,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Location &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}