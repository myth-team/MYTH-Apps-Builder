import 'package:flutter/material.dart';

class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String profileImage;
  final DateTime dateOfBirth;
  final UserAddress? address;
  final String nationality;
  final String? passportNumber;
  final List<String> bookingIds;
  final List<String> favoriteHotelIds;
  final int loyaltyPoints;
  final LoyaltyTier loyaltyTier;
  final String preferredCurrency;
  final bool emailNotificationsEnabled;
  final bool pushNotificationsEnabled;
  final bool smsNotificationsEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.profileImage,
    required this.dateOfBirth,
    this.address,
    required this.nationality,
    this.passportNumber,
    required this.bookingIds,
    required this.favoriteHotelIds,
    required this.loyaltyPoints,
    required this.loyaltyTier,
    required this.preferredCurrency,
    required this.emailNotificationsEnabled,
    required this.pushNotificationsEnabled,
    required this.smsNotificationsEnabled,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  int get totalBookings => bookingIds.length;

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImage,
    DateTime? dateOfBirth,
    UserAddress? address,
    String? nationality,
    String? passportNumber,
    List<String>? bookingIds,
    List<String>? favoriteHotelIds,
    int? loyaltyPoints,
    LoyaltyTier? loyaltyTier,
    String? preferredCurrency,
    bool? emailNotificationsEnabled,
    bool? pushNotificationsEnabled,
    bool? smsNotificationsEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      nationality: nationality ?? this.nationality,
      passportNumber: passportNumber ?? this.passportNumber,
      bookingIds: bookingIds ?? this.bookingIds,
      favoriteHotelIds: favoriteHotelIds ?? this.favoriteHotelIds,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      loyaltyTier: loyaltyTier ?? this.loyaltyTier,
      preferredCurrency: preferredCurrency ?? this.preferredCurrency,
      emailNotificationsEnabled: emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      smsNotificationsEnabled: smsNotificationsEnabled ?? this.smsNotificationsEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'address': address?.toJson(),
      'nationality': nationality,
      'passportNumber': passportNumber,
      'bookingIds': bookingIds,
      'favoriteHotelIds': favoriteHotelIds,
      'loyaltyPoints': loyaltyPoints,
      'loyaltyTier': loyaltyTier.name,
      'preferredCurrency': preferredCurrency,
      'emailNotificationsEnabled': emailNotificationsEnabled,
      'pushNotificationsEnabled': pushNotificationsEnabled,
      'smsNotificationsEnabled': smsNotificationsEnabled,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      profileImage: json['profileImage'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      address: json['address'] != null ? UserAddress.fromJson(json['address'] as Map<String, dynamic>) : null,
      nationality: json['nationality'] as String,
      passportNumber: json['passportNumber'] as String?,
      bookingIds: List<String>.from(json['bookingIds'] as List),
      favoriteHotelIds: List<String>.from(json['favoriteHotelIds'] as List),
      loyaltyPoints: json['loyaltyPoints'] as int,
      loyaltyTier: LoyaltyTier.values.firstWhere((e) => e.name == json['loyaltyTier']),
      preferredCurrency: json['preferredCurrency'] as String,
      emailNotificationsEnabled: json['emailNotificationsEnabled'] as bool,
      pushNotificationsEnabled: json['pushNotificationsEnabled'] as bool,
      smsNotificationsEnabled: json['smsNotificationsEnabled'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

class UserAddress {
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  UserAddress({
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  String get fullAddress => '$street, $city, $state $postalCode, $country';

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
    };
  }

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      street: json['street'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      postalCode: json['postalCode'] as String,
      country: json['country'] as String,
    );
  }
}

enum LoyaltyTier {
  bronze,
  silver,
  gold,
  platinum,
  diamond,
}

extension LoyaltyTierExtension on LoyaltyTier {
  String get displayName {
    switch (this) {
      case LoyaltyTier.bronze:
        return 'Bronze';
      case LoyaltyTier.silver:
        return 'Silver';
      case LoyaltyTier.gold:
        return 'Gold';
      case LoyaltyTier.platinum:
        return 'Platinum';
      case LoyaltyTier.diamond:
        return 'Diamond';
    }
  }

  int get requiredPoints {
    switch (this) {
      case LoyaltyTier.bronze:
        return 0;
      case LoyaltyTier.silver:
        return 1000;
      case LoyaltyTier.gold:
        return 5000;
      case LoyaltyTier.platinum:
        return 15000;
      case LoyaltyTier.diamond:
        return 35000;
    }
  }

  double get pointsMultiplier {
    switch (this) {
      case LoyaltyTier.bronze:
        return 1.0;
      case LoyaltyTier.silver:
        return 1.25;
      case LoyaltyTier.gold:
        return 1.5;
      case LoyaltyTier.platinum:
        return 1.75;
      case LoyaltyTier.diamond:
        return 2.0;
    }
  }
}