class Room {
  final String id;
  final String hotelId;
  final String name;
  final String description;
  final double pricePerNight;
  final int capacity;
  final int bedCount;
  final String bedType;
  final String size;
  final String imageUrl;
  final List<String> amenities;
  final bool isAvailable;
  final int availableCount;

  Room({
    required this.id,
    required this.hotelId,
    required this.name,
    required this.description,
    required this.pricePerNight,
    required this.capacity,
    required this.bedCount,
    required this.bedType,
    required this.size,
    required this.imageUrl,
    required this.amenities,
    this.isAvailable = true,
    this.availableCount = 5,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      hotelId: json['hotelId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      pricePerNight: (json['pricePerNight'] as num).toDouble(),
      capacity: json['capacity'] as int,
      bedCount: json['bedCount'] as int,
      bedType: json['bedType'] as String,
      size: json['size'] as String,
      imageUrl: json['imageUrl'] as String,
      amenities: List<String>.from(json['amenities'] ?? []),
      isAvailable: json['isAvailable'] as bool? ?? true,
      availableCount: json['availableCount'] as int? ?? 5,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotelId': hotelId,
      'name': name,
      'description': description,
      'pricePerNight': pricePerNight,
      'capacity': capacity,
      'bedCount': bedCount,
      'bedType': bedType,
      'size': size,
      'imageUrl': imageUrl,
      'amenities': amenities,
      'isAvailable': isAvailable,
      'availableCount': availableCount,
    };
  }

  Room copyWith({
    String? id,
    String? hotelId,
    String? name,
    String? description,
    double? pricePerNight,
    int? capacity,
    int? bedCount,
    String? bedType,
    String? size,
    String? imageUrl,
    List<String>? amenities,
    bool? isAvailable,
    int? availableCount,
  }) {
    return Room(
      id: id ?? this.id,
      hotelId: hotelId ?? this.hotelId,
      name: name ?? this.name,
      description: description ?? this.description,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      capacity: capacity ?? this.capacity,
      bedCount: bedCount ?? this.bedCount,
      bedType: bedType ?? this.bedType,
      size: size ?? this.size,
      imageUrl: imageUrl ?? this.imageUrl,
      amenities: amenities ?? this.amenities,
      isAvailable: isAvailable ?? this.isAvailable,
      availableCount: availableCount ?? this.availableCount,
    );
  }
}