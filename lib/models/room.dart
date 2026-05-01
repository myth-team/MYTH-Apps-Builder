import 'package:flutter/material.dart';

class Room {
  final String id;
  final String hotelId;
  final String roomType;
  final String description;
  final double pricePerNight;
  final String currency;
  final int capacity;
  final List<String> images;
  final List<String> amenities;
  final bool isAvailable;
  final double sizeInSqMeters;
  final String bedType;
  final int numberOfRooms;
  final int availableRooms;
  final double rating;
  final bool isFeatured;
  final String viewType;

  Room({
    required this.id,
    required this.hotelId,
    required this.roomType,
    required this.description,
    required this.pricePerNight,
    required this.currency,
    required this.capacity,
    required this.images,
    required this.amenities,
    required this.isAvailable,
    required this.sizeInSqMeters,
    required this.bedType,
    required this.numberOfRooms,
    required this.availableRooms,
    required this.rating,
    required this.isFeatured,
    required this.viewType,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      hotelId: json['hotelId'] as String,
      roomType: json['roomType'] as String,
      description: json['description'] as String,
      pricePerNight: (json['pricePerNight'] as num).toDouble(),
      currency: json['currency'] as String,
      capacity: json['capacity'] as int,
      images: List<String>.from(json['images'] as List),
      amenities: List<String>.from(json['amenities'] as List),
      isAvailable: json['isAvailable'] as bool,
      sizeInSqMeters: (json['sizeInSqMeters'] as num).toDouble(),
      bedType: json['bedType'] as String,
      numberOfRooms: json['numberOfRooms'] as int,
      availableRooms: json['availableRooms'] as int,
      rating: (json['rating'] as num).toDouble(),
      isFeatured: json['isFeatured'] as bool,
      viewType: json['viewType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotelId': hotelId,
      'roomType': roomType,
      'description': description,
      'pricePerNight': pricePerNight,
      'currency': currency,
      'capacity': capacity,
      'images': images,
      'amenities': amenities,
      'isAvailable': isAvailable,
      'sizeInSqMeters': sizeInSqMeters,
      'bedType': bedType,
      'numberOfRooms': numberOfRooms,
      'availableRooms': availableRooms,
      'rating': rating,
      'isFeatured': isFeatured,
      'viewType': viewType,
    };
  }

  Room copyWith({
    String? id,
    String? hotelId,
    String? roomType,
    String? description,
    double? pricePerNight,
    String? currency,
    int? capacity,
    List<String>? images,
    List<String>? amenities,
    bool? isAvailable,
    double? sizeInSqMeters,
    String? bedType,
    int? numberOfRooms,
    int? availableRooms,
    double? rating,
    bool? isFeatured,
    String? viewType,
  }) {
    return Room(
      id: id ?? this.id,
      hotelId: hotelId ?? this.hotelId,
      roomType: roomType ?? this.roomType,
      description: description ?? this.description,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      currency: currency ?? this.currency,
      capacity: capacity ?? this.capacity,
      images: images ?? this.images,
      amenities: amenities ?? this.amenities,
      isAvailable: isAvailable ?? this.isAvailable,
      sizeInSqMeters: sizeInSqMeters ?? this.sizeInSqMeters,
      bedType: bedType ?? this.bedType,
      numberOfRooms: numberOfRooms ?? this.numberOfRooms,
      availableRooms: availableRooms ?? this.availableRooms,
      rating: rating ?? this.rating,
      isFeatured: isFeatured ?? this.isFeatured,
      viewType: viewType ?? this.viewType,
    );
  }

  String get formattedPrice => '$currency ${pricePerNight.toStringAsFixed(0)}';
  
  String get capacityText => '$capacity Guest${capacity > 1 ? 's' : ''}';
  
  String get sizeText => '${sizeInSqMeters.toStringAsFixed(0)} m²';
  
  String get availabilityText => '$availableRooms rooms left';
  
  bool get isLimitedAvailability => availableRooms <= 3;
}
