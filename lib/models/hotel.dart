class Hotel {
  final String id;
  final String name;
  final String description;
  final String address;
  final String city;
  final double rating;
  final int reviewCount;
  final double pricePerNight;
  final List<String> images;
  final List<String> amenities;
  final List<Room> rooms;
  final String thumbnailUrl;
  final bool isFeatured;
  bool isFavorite;

  Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.city,
    required this.rating,
    required this.reviewCount,
    required this.pricePerNight,
    required this.images,
    required this.amenities,
    required this.rooms,
    required this.thumbnailUrl,
    this.isFeatured = false,
    this.isFavorite = false,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      pricePerNight: (json['pricePerNight'] as num).toDouble(),
      images: List<String>.from(json['images'] as List),
      amenities: List<String>.from(json['amenities'] as List),
      rooms: (json['rooms'] as List<dynamic>?)
              ?.map((r) => Room.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
      thumbnailUrl: json['thumbnailUrl'] as String,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'city': city,
      'rating': rating,
      'reviewCount': reviewCount,
      'pricePerNight': pricePerNight,
      'images': images,
      'amenities': amenities,
      'rooms': rooms.map((r) => r.toJson()).toList(),
      'thumbnailUrl': thumbnailUrl,
      'isFeatured': isFeatured,
      'isFavorite': isFavorite,
    };
  }

  Hotel copyWith({
    String? id,
    String? name,
    String? description,
    String? address,
    String? city,
    double? rating,
    int? reviewCount,
    double? pricePerNight,
    List<String>? images,
    List<String>? amenities,
    List<Room>? rooms,
    String? thumbnailUrl,
    bool? isFeatured,
    bool? isFavorite,
  }) {
    return Hotel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      city: city ?? this.city,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      images: images ?? this.images,
      amenities: amenities ?? this.amenities,
      rooms: rooms ?? this.rooms,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      isFeatured: isFeatured ?? this.isFeatured,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  String get formattedPrice => '\$${pricePerNight.toStringAsFixed(0)}';
  String get formattedRating => rating.toStringAsFixed(1);
  String get location => '$city, $address';
  double get price => pricePerNight;
  String get imageUrl => thumbnailUrl;
}

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

  Room({
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
  
  // Added getters to fix compilation errors
  String get image => images.isNotEmpty ? images.first : '';
  int get capacity => maxGuests;
  double get price => pricePerNight;
}