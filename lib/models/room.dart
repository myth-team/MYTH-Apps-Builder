class Room {
  final String id;
  final String hotelId;
  final String name;
  final String description;
  final int maxGuests;
  final double pricePerNight;
  final List<String> images;
  final List<String> amenities;
  final int availableCount;
  final double size;
  final String bedType;

  const Room({
    required this.id,
    required this.hotelId,
    required this.name,
    required this.description,
    required this.maxGuests,
    required this.pricePerNight,
    required this.images,
    required this.amenities,
    this.availableCount = 1,
    this.size = 0,
    this.bedType = 'King',
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      hotelId: json['hotelId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      maxGuests: json['maxGuests'] as int,
      pricePerNight: (json['pricePerNight'] as num).toDouble(),
      images: List<String>.from(json['images'] as List),
      amenities: List<String>.from(json['amenities'] as List),
      availableCount: json['availableCount'] as int? ?? 1,
      size: (json['size'] as num?)?.toDouble() ?? 0,
      bedType: json['bedType'] as String? ?? 'King',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotelId': hotelId,
      'name': name,
      'description': description,
      'maxGuests': maxGuests,
      'pricePerNight': pricePerNight,
      'images': images,
      'amenities': amenities,
      'availableCount': availableCount,
      'size': size,
      'bedType': bedType,
    };
  }

  Room copyWith({
    String? id,
    String? hotelId,
    String? name,
    String? description,
    int? maxGuests,
    double? pricePerNight,
    List<String>? images,
    List<String>? amenities,
    int? availableCount,
    double? size,
    String? bedType,
  }) {
    return Room(
      id: id ?? this.id,
      hotelId: hotelId ?? this.hotelId,
      name: name ?? this.name,
      description: description ?? this.description,
      maxGuests: maxGuests ?? this.maxGuests,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      images: images ?? this.images,
      amenities: amenities ?? this.amenities,
      availableCount: availableCount ?? this.availableCount,
      size: size ?? this.size,
      bedType: bedType ?? this.bedType,
    );
  }

  String get formattedPrice => '\$${pricePerNight.toStringAsFixed(0)}';
  String get guestsText => '$maxGuests Guest${maxGuests > 1 ? 's' : ''}';
  String get sizeText => size > 0 ? '${size.toStringAsFixed(0)} m²' : '';
  bool get isAvailable => availableCount > 0;
}