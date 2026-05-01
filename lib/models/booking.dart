enum BookingStatus {
  pending,
  confirmed,
  checkedIn,
  checkedOut,
  cancelled,
}

class Booking {
  final String id;
  final String hotelId;
  final String hotelName;
  final String hotelImageUrl;
  final String roomId;
  final String roomName;
  final String guestName;
  final String guestEmail;
  final String guestPhone;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int guestCount;
  final double totalPrice;
  final double roomPricePerNight;
  final int nightsCount;
  final BookingStatus status;
  final String? paymentMethod;
  final bool isPaid;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.hotelId,
    required this.hotelName,
    required this.hotelImageUrl,
    required this.roomId,
    required this.roomName,
    required this.guestName,
    required this.guestEmail,
    required this.guestPhone,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guestCount,
    required this.totalPrice,
    required this.roomPricePerNight,
    required this.nightsCount,
    required this.status,
    this.paymentMethod,
    this.isPaid = false,
    required this.createdAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      hotelId: json['hotelId'] as String,
      hotelName: json['hotelName'] as String,
      hotelImageUrl: json['hotelImageUrl'] as String,
      roomId: json['roomId'] as String,
      roomName: json['roomName'] as String,
      guestName: json['guestName'] as String,
      guestEmail: json['guestEmail'] as String,
      guestPhone: json['guestPhone'] as String,
      checkInDate: DateTime.parse(json['checkInDate'] as String),
      checkOutDate: DateTime.parse(json['checkOutDate'] as String),
      guestCount: json['guestCount'] as int,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      roomPricePerNight: (json['roomPricePerNight'] as num).toDouble(),
      nightsCount: json['nightsCount'] as int,
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      paymentMethod: json['paymentMethod'] as String?,
      isPaid: json['isPaid'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotelId': hotelId,
      'hotelName': hotelName,
      'hotelImageUrl': hotelImageUrl,
      'roomId': roomId,
      'roomName': roomName,
      'guestName': guestName,
      'guestEmail': guestEmail,
      'guestPhone': guestPhone,
      'checkInDate': checkInDate.toIso8601String(),
      'checkOutDate': checkOutDate.toIso8601String(),
      'guestCount': guestCount,
      'totalPrice': totalPrice,
      'roomPricePerNight': roomPricePerNight,
      'nightsCount': nightsCount,
      'status': status.name,
      'paymentMethod': paymentMethod,
      'isPaid': isPaid,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Booking copyWith({
    String? id,
    String? hotelId,
    String? hotelName,
    String? hotelImageUrl,
    String? roomId,
    String? roomName,
    String? guestName,
    String? guestEmail,
    String? guestPhone,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    int? guestCount,
    double? totalPrice,
    double? roomPricePerNight,
    int? nightsCount,
    BookingStatus? status,
    String? paymentMethod,
    bool? isPaid,
    DateTime? createdAt,
  }) {
    return Booking(
      id: id ?? this.id,
      hotelId: hotelId ?? this.hotelId,
      hotelName: hotelName ?? this.hotelName,
      hotelImageUrl: hotelImageUrl ?? this.hotelImageUrl,
      roomId: roomId ?? this.roomId,
      roomName: roomName ?? this.roomName,
      guestName: guestName ?? this.guestName,
      guestEmail: guestEmail ?? this.guestEmail,
      guestPhone: guestPhone ?? this.guestPhone,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      guestCount: guestCount ?? this.guestCount,
      totalPrice: totalPrice ?? this.totalPrice,
      roomPricePerNight: roomPricePerNight ?? this.roomPricePerNight,
      nightsCount: nightsCount ?? this.nightsCount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isPaid: isPaid ?? this.isPaid,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isUpcoming =>
      status == BookingStatus.confirmed && checkInDate.isAfter(DateTime.now());

  bool get isPast => status == BookingStatus.checkedOut;
}