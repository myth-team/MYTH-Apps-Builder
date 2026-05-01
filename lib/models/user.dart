class User {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? photoUrl;
  final List<PaymentMethod> paymentMethods;
  final String? defaultPaymentMethodId;
  final double rating;
  final DateTime createdAt;
  final bool isEmailVerified;
  final bool isPhoneVerified;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.photoUrl,
    required this.paymentMethods,
    this.defaultPaymentMethodId,
    required this.rating,
    required this.createdAt,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? photoUrl,
    List<PaymentMethod>? paymentMethods,
    String? defaultPaymentMethodId,
    double? rating,
    DateTime? createdAt,
    bool? isEmailVerified,
    bool? isPhoneVerified,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      defaultPaymentMethodId: defaultPaymentMethodId ?? this.defaultPaymentMethodId,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      photoUrl: json['photoUrl'] as String?,
      paymentMethods: (json['paymentMethods'] as List?)
              ?.map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      defaultPaymentMethodId: json['defaultPaymentMethodId'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      isPhoneVerified: json['isPhoneVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'paymentMethods': paymentMethods.map((e) => e.toJson()).toList(),
      'defaultPaymentMethodId': defaultPaymentMethodId,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
    };
  }

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  PaymentMethod? get defaultPaymentMethod {
    if (defaultPaymentMethodId == null) return null;
    try {
      return paymentMethods.firstWhere((pm) => pm.id == defaultPaymentMethodId);
    } catch (_) {
      return paymentMethods.isNotEmpty ? paymentMethods.first : null;
    }
  }

  bool get hasPaymentMethods => paymentMethods.isNotEmpty;
}

class PaymentMethod {
  final String id;
  final PaymentMethodType type;
  final String lastFourDigits;
  final String? cardBrand;
  final int? expiryMonth;
  final int? expiryYear;
  final String? cardholderName;
  final bool isDefault;

  const PaymentMethod({
    required this.id,
    required this.type,
    required this.lastFourDigits,
    this.cardBrand,
    this.expiryMonth,
    this.expiryYear,
    this.cardholderName,
    this.isDefault = false,
  });

  PaymentMethod copyWith({
    String? id,
    PaymentMethodType? type,
    String? lastFourDigits,
    String? cardBrand,
    int? expiryMonth,
    int? expiryYear,
    String? cardholderName,
    bool? isDefault,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      lastFourDigits: lastFourDigits ?? this.lastFourDigits,
      cardBrand: cardBrand ?? this.cardBrand,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      cardholderName: cardholderName ?? this.cardholderName,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as String,
      type: PaymentMethodType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => PaymentMethodType.card,
      ),
      lastFourDigits: json['lastFourDigits'] as String,
      cardBrand: json['cardBrand'] as String?,
      expiryMonth: json['expiryMonth'] as int?,
      expiryYear: json['expiryYear'] as int?,
      cardholderName: json['cardholderName'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'lastFourDigits': lastFourDigits,
      'cardBrand': cardBrand,
      'expiryMonth': expiryMonth,
      'expiryYear': expiryYear,
      'cardholderName': cardholderName,
      'isDefault': isDefault,
    };
  }

  String get displayName {
    switch (type) {
      case PaymentMethodType.card:
        return '$cardBrand •••• $lastFourDigits';
      case PaymentMethodType.paypal:
        return 'PayPal •••• $lastFourDigits';
      case PaymentMethodType.applePay:
        return 'Apple Pay';
      case PaymentMethodType.googlePay:
        return 'Google Pay';
    }
  }

  String get expiryDisplay {
    if (expiryMonth != null && expiryYear != null) {
      return '$expiryMonth/$expiryYear';
    }
    return '';
  }

  bool get isExpired {
    if (expiryMonth == null || expiryYear == null) return false;
    final now = DateTime.now();
    if (expiryYear! < now.year) return true;
    if (expiryYear == now.year && expiryMonth! < now.month) return true;
    return false;
  }
}

enum PaymentMethodType {
  card,
  paypal,
  applePay,
  googlePay,
}

class UserSettings {
  final bool notificationsEnabled;
  final bool locationEnabled;
  final bool darkModeEnabled;
  final String preferredLanguage;
  final bool shareTripStatus;
  final bool emergencyContactAutoShare;

  const UserSettings({
    this.notificationsEnabled = true,
    this.locationEnabled = true,
    this.darkModeEnabled = false,
    this.preferredLanguage = 'en',
    this.shareTripStatus = true,
    this.emergencyContactAutoShare = false,
  });

  UserSettings copyWith({
    bool? notificationsEnabled,
    bool? locationEnabled,
    bool? darkModeEnabled,
    String? preferredLanguage,
    bool? shareTripStatus,
    bool? emergencyContactAutoShare,
  }) {
    return UserSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      shareTripStatus: shareTripStatus ?? this.shareTripStatus,
      emergencyContactAutoShare: emergencyContactAutoShare ?? this.emergencyContactAutoShare,
    );
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      locationEnabled: json['locationEnabled'] as bool? ?? true,
      darkModeEnabled: json['darkModeEnabled'] as bool? ?? false,
      preferredLanguage: json['preferredLanguage'] as String? ?? 'en',
      shareTripStatus: json['shareTripStatus'] as bool? ?? true,
      emergencyContactAutoShare: json['emergencyContactAutoShare'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'locationEnabled': locationEnabled,
      'darkModeEnabled': darkModeEnabled,
      'preferredLanguage': preferredLanguage,
      'shareTripStatus': shareTripStatus,
      'emergencyContactAutoShare': emergencyContactAutoShare,
    };
  }
}