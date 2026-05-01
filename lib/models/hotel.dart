class Hotel {
  final String id;
  final String name;
  final String description;
  final String location;
  final String address;
  final double rating;
  final int reviewCount;
  final double pricePerNight;
  final String imageUrl;
  final List<String> galleryImages;
  final List<String> amenities;
  final String category;
  final bool isFeatured;
  final bool isAvailable;

  Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.address,
    required this.rating,
    required this.reviewCount,
    required this.pricePerNight,
    required this.imageUrl,
    required this.galleryImages,
    required this.amenities,
    required this.category,
    this.isFeatured = false,
    this.isAvailable = true,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      address: json['address'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      pricePerNight: (json['pricePerNight'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      galleryImages: List<String>.from(json['galleryImages'] ?? []),
      amenities: List<String>.from(json['amenities'] ?? []),
      category: json['category'] as String,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'address': address,
      'rating': rating,
      'reviewCount': reviewCount,
      'pricePerNight': pricePerNight,
      'imageUrl': imageUrl,
      'galleryImages': galleryImages,
      'amenities': amenities,
      'category': category,
      'isFeatured': isFeatured,
      'isAvailable': isAvailable,
    };
  }

  Hotel copyWith({
    String? id,
    String? name,
    String? description,
    String? location,
    String? address,
    double? rating,
    int? reviewCount,
    double? pricePerNight,
    String? imageUrl,
    List<String>? galleryImages,
    List<String>? amenities,
    String? category,
    bool? isFeatured,
    bool? isAvailable,
  }) {
    return Hotel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      address: address ?? this.address,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      imageUrl: imageUrl ?? this.imageUrl,
      galleryImages: galleryImages ?? this.galleryImages,
      amenities: amenities ?? this.amenities,
      category: category ?? this.category,
      isFeatured: isFeatured ?? this.isFeatured,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}