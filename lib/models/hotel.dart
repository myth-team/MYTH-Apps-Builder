import 'package:flutter/material.dart';

class Hotel {
  final String id;
  final String name;
  final String description;
  final String city;
  final String country;
  final String address;
  final double rating;
  final int reviewCount;
  final double pricePerNight;
  final String currency;
  final List<String> images;
  final List<String> amenities;
  final int totalRooms;
  final int availableRooms;
  final bool isFeatured;
  final bool isAvailable;
  final double latitude;
  final double longitude;
  final String phoneNumber;
  final String email;
  final String checkInTime;
  final String checkOutTime;
  final List<String> roomTypes;
  final double distanceFromCenter;
  final String hotelType;

  Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.country,
    required this.address,
    required this.rating,
    required this.reviewCount,
    required this.pricePerNight,
    required this.currency,
    required this.images,
    required this.amenities,
    required this.totalRooms,
    required this.availableRooms,
    required this.isFeatured,
    required this.isAvailable,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    required this.email,
    required this.checkInTime,
    required this.checkOutTime,
    required this.roomTypes,
    required this.distanceFromCenter,
    required this.hotelType,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      address: json['address'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      pricePerNight: (json['pricePerNight'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'USD',
      images: List<String>.from(json['images'] ?? []),
      amenities: List<String>.from(json['amenities'] ?? []),
      totalRooms: json['totalRooms'] as int? ?? 0,
      availableRooms: json['availableRooms'] as int? ?? 0,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isAvailable: json['isAvailable'] as bool? ?? true,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      phoneNumber: json['phoneNumber'] as String? ?? '',
      email: json['email'] as String? ?? '',
      checkInTime: json['checkInTime'] as String? ?? '15:00',
      checkOutTime: json['checkOutTime'] as String? ?? '11:00',
      roomTypes: List<String>.from(json['roomTypes'] ?? []),
      distanceFromCenter: (json['distanceFromCenter'] as num?)?.toDouble() ?? 0.0,
      hotelType: json['hotelType'] as String? ?? 'Standard',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'city': city,
      'country': country,
      'address': address,
      'rating': rating,
      'reviewCount': reviewCount,
      'pricePerNight': pricePerNight,
      'currency': currency,
      'images': images,
      'amenities': amenities,
      'totalRooms': totalRooms,
      'availableRooms': availableRooms,
      'isFeatured': isFeatured,
      'isAvailable': isAvailable,
      'latitude': latitude,
      'longitude': longitude,
      'phoneNumber': phoneNumber,
      'email': email,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'roomTypes': roomTypes,
      'distanceFromCenter': distanceFromCenter,
      'hotelType': hotelType,
    };
  }

  Hotel copyWith({
    String? id,
    String? name,
    String? description,
    String? city,
    String? country,
    String? address,
    double? rating,
    int? reviewCount,
    double? pricePerNight,
    String? currency,
    List<String>? images,
    List<String>? amenities,
    int? totalRooms,
    int? availableRooms,
    bool? isFeatured,
    bool? isAvailable,
    double? latitude,
    double? longitude,
    String? phoneNumber,
    String? email,
    String? checkInTime,
    String? checkOutTime,
    List<String>? roomTypes,
    double? distanceFromCenter,
    String? hotelType,
  }) {
    return Hotel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      city: city ?? this.city,
      country: country ?? this.country,
      address: address ?? this.address,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      currency: currency ?? this.currency,
      images: images ?? this.images,
      amenities: amenities ?? this.amenities,
      totalRooms: totalRooms ?? this.totalRooms,
      availableRooms: availableRooms ?? this.availableRooms,
      isFeatured: isFeatured ?? this.isFeatured,
      isAvailable: isAvailable ?? this.isAvailable,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      roomTypes: roomTypes ?? this.roomTypes,
      distanceFromCenter: distanceFromCenter ?? this.distanceFromCenter,
      hotelType: hotelType ?? this.hotelType,
    );
  }

  String get fullLocation => '$city, $country';

  String get formattedPrice => '$currency ${pricePerNight.toStringAsFixed(0)}';

  bool get hasAvailability => availableRooms > 0;

  String get availabilityText {
    if (availableRooms == 0) return 'Sold Out';
    if (availableRooms <= 5) return 'Only $availableRooms left!';
    return 'Available';
  }

  IconData get hotelTypeIcon {
    switch (hotelType.toLowerCase()) {
      case 'resort':
        return Icons.resort;
      case 'villa':
        return Icons.villa;
      case 'apartment':
        return Icons.apartment;
      case 'boutique':
        return Icons.store;
      case 'suite':
        return Icons.hotel;
      default:
        return Icons.hotel;
    }
  }

  static List<Hotel> getSampleHotels() {
    return [
      Hotel(
        id: '1',
        name: 'The Golden Palace',
        description: 'Experience unparalleled luxury at The Golden Palace, where every detail has been crafted to provide an unforgettable stay. Nestled in the heart of the city, our hotel offers breathtaking views, world-class amenities, and exceptional service that defines true hospitality.',
        city: 'Paris',
        country: 'France',
        address: '123 Champs-Élysées, 75008 Paris',
        rating: 4.9,
        reviewCount: 1250,
        pricePerNight: 850,
        currency: 'USD',
        images: [
          'https://example.com/golden_palace_1.jpg',
          'https://example.com/golden_palace_2.jpg',
          'https://example.com/golden_palace_3.jpg',
        ],
        amenities: [
          'Free WiFi',
          'Spa & Wellness',
          'Infinity Pool',
          'Fine Dining',
          'Concierge',
          'Valet Parking',
          'Business Center',
          'Airport Transfer',
        ],
        totalRooms: 120,
        availableRooms: 15,
        isFeatured: true,
        isAvailable: true,
        latitude: 48.8698,
        longitude: 2.3078,
        phoneNumber: '+33 1 42 89 00 00',
        email: 'reservations@goldenpalace.com',
        checkInTime: '15:00',
        checkOutTime: '12:00',
        roomTypes: ['Deluxe Suite', 'Presidential Suite', 'Executive Suite', 'Royal Room'],
        distanceFromCenter: 0.5,
        hotelType: 'Luxury',
      ),
      Hotel(
        id: '2',
        name: 'Azure Ocean Resort',
        description: 'Escape to paradise at Azure Ocean Resort, a stunning beachfront property offering the perfect blend of relaxation and adventure. With pristine white sand beaches, crystal-clear waters, and luxurious accommodations, your dream vacation awaits.',
        city: 'Maldives',
        country: 'Maldives',
        address: 'North Malé Atoll, Malé 20026',
        rating: 4.8,
        reviewCount: 890,
        pricePerNight: 1200,
        currency: 'USD',
        images: [
          'https://example.com/azure_resort_1.jpg',
          'https://example.com/azure_resort_2.jpg',
        ],
        amenities: [
          'Private Beach',
          'Water Sports',
          'Diving Center',
          'Beach Bar',
          'Sunset Cruises',
          'Yoga Pavilion',
          'Butler Service',
        ],
        totalRooms: 45,
        availableRooms: 8,
        isFeatured: true,
        isAvailable: true,
        latitude: 4.2105,
        longitude: 73.5386,
        phoneNumber: '+960 400 2000',
        email: 'stay@azureocean.com',
        checkInTime: '14:00',
        checkOutTime: '11:00',
        roomTypes: ['Beach Villa', 'Overwater Bungalow', 'Family Villa'],
        distanceFromCenter: 15.0,
        hotelType: 'Resort',
      ),
      Hotel(
        id: '3',
        name: 'Metropolitan Boutique',
        description: 'Discover urban sophistication at Metropolitan Boutique Hotel. Located in the vibrant downtown district, our hotel offers modern elegance, personalized service, and easy access to the city best attractions, dining, and nightlife.',
        city: 'New York',
        country: 'USA',
        address: '42 Madison Avenue, New York, NY 10016',
        rating: 4.6,
        reviewCount: 650,
        pricePerNight: 425,
        currency: 'USD',
        images: [
          'https://example.com/metropolitan_1.jpg',
          'https://example.com/metropolitan_2.jpg',
        ],
        amenities: [
          'Free High-Speed WiFi',
          'Rooftop Lounge',
          'Fitness Center',
          'Restaurant',
          'Room Service',
          'Pet Friendly',
        ],
        totalRooms: 85,
        availableRooms: 22,
        isFeatured: false,
        isAvailable: true,
        latitude: 40.7484,
        longitude: -73.9857,
        phoneNumber: '+1 212 555 0199',
        email: 'reservations@metropolitanboutique.com',
        checkInTime: '16:00',
        checkOutTime: '11:00',
        roomTypes: ['Standard Room', 'Deluxe Room', 'Suite', 'Penthouse'],
        distanceFromCenter: 0.2,
        hotelType: 'Boutique',
      ),
      Hotel(
        id: '4',
        name: 'Royal Mountain Lodge',
        description: 'Experience the grandeur of the Swiss Alps at Royal Mountain Lodge. This historic luxury hotel combines traditional Alpine charm with modern comforts, offering ski-in/ski-out access, world-class dining, and breathtaking mountain views.',
        city: 'Zermatt',
        country: 'Switzerland',
        address: 'Bahnhofstrasse 15, 3920 Zermatt',
        rating: 4.9,
        reviewCount: 520,
        pricePerNight: 680,
        currency: 'USD',
        images: [
          'https://example.com/royal_mountain_1.jpg',
          'https://example.com/royal_mountain_2.jpg',
        ],
        amenities: [
          'Ski-in/Ski-out',
          'Heated Indoor Pool',
          'Spa & Sauna',
          'Fine Dining Restaurant',
          'Wine Cellar',
          'Mountain Guide Service',
          'Heated Ski Storage',
        ],
        totalRooms: 35,
        availableRooms: 4,
        isFeatured: true,
        isAvailable: true,
        latitude: 46.0207,
        longitude: 7.7491,
        phoneNumber: '+41 27 966 80 80',
        email: 'info@royalmountainlodge.ch',
        checkInTime: '15:00',
        checkOutTime: '11:00',
        roomTypes: ['Alpine Room', 'Mountain Suite', 'Chalet'],
        distanceFromCenter: 0.8,
        hotelType: 'Resort',
      ),
      Hotel(
        id: '5',
        name: 'Grand Imperial Hotel',
        description: 'Step into history at Grand Imperial Hotel, a legendary establishment that has hosted royalty, celebrities, and distinguished guests for over a century. Experience timeless elegance, legendary service, and the grandeur of a bygone era.',
        city: 'London',
        country: 'United Kingdom',
        address: '1 Buckingham Place, London SW1A 1AA',
        rating: 4.7,
        reviewCount: 2100,
        pricePerNight: 550,
        currency: 'USD',
        images: [
          'https://example.com/grand_imperial_1.jpg',
          'https://example.com/grand_imperial_2.jpg',
        ],
        amenities: [
          'Luxury Spa',
          'Fine Dining',
          'Afternoon Tea',
          'Champagne Bar',
          'Concierge',
          'Limousine Service',
          'Ballroom',
        ],
        totalRooms: 250,
        availableRooms: 45,
        isFeatured: false,
        isAvailable: true,
        latitude: 51.5014,
        longitude: -0.1419,
        phoneNumber: '+44 20 7930 8080',
        email: 'bookings@grandimperial.co.uk',
        checkInTime: '15:00',
        checkOutTime: '12:00',
        roomTypes: ['Classic Room', 'Superior Room', 'Executive Suite', 'Royal Suite'],
        distanceFromCenter: 1.2,
        hotelType: 'Luxury',
      ),
    ];
  }
}

class HotelFilter {
  final String? city;
  final String? country;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final String? hotelType;
  final List<String>? amenities;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final int? guests;
  final int? rooms;

  HotelFilter({
    this.city,
    this.country,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.hotelType,
    this.amenities,
    this.checkInDate,
    this.checkOutDate,
    this.guests,
    this.rooms,
  });

  List<Hotel> apply(List<Hotel> hotels) {
    var filtered = hotels.toList();

    if (city != null && city!.isNotEmpty) {
      filtered = filtered.where((h) => 
        h.city.toLowerCase().contains(city!.toLowerCase())
      ).toList();
    }

    if (country != null && country!.isNotEmpty) {
      filtered = filtered.where((h) => 
        h.country.toLowerCase().contains(country!.toLowerCase())
      ).toList();
    }

    if (minPrice != null) {
      filtered = filtered.where((h) => 
        h.pricePerNight >= minPrice!
      ).toList();
    }

    if (maxPrice != null) {
      filtered = filtered.where((h) => 
        h.pricePerNight <= maxPrice!
      ).toList();
    }

    if (minRating != null) {
      filtered = filtered.where((h) => 
        h.rating >= minRating!
      ).toList();
    }

    if (hotelType != null && hotelType!.isNotEmpty) {
      filtered = filtered.where((h) => 
        h.hotelType.toLowerCase() == hotelType!.toLowerCase()
      ).toList();
    }

    if (amenities != null && amenities!.isNotEmpty) {
      filtered = filtered.where((h) {
        return amenities!.every((amenity) => 
          h.amenities.any((a) => a.toLowerCase().contains(amenity.toLowerCase()))
        );
      }).toList();
    }

    return filtered;
  }

  HotelFilter copyWith({
    String? city,
    String? country,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? hotelType,
    List<String>? amenities,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    int? guests,
    int? rooms,
  }) {
    return HotelFilter(
      city: city ?? this.city,
      country: country ?? this.country,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      hotelType: hotelType ?? this.hotelType,
      amenities: amenities ?? this.amenities,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      guests: guests ?? this.guests,
      rooms: rooms ?? this.rooms,
    );
  }

  void clear() {
    city = null;
    country = null;
    minPrice = null;
    maxPrice = null;
    minRating = null;
    hotelType = null;
    amenities = null;
    checkInDate = null;
    checkOutDate = null;
    guests = null;
    rooms = null;
  }
}