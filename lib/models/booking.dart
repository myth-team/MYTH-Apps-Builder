import 'package:flutter/material.dart';

class Booking {
  final String id;
  final String userId;
  final String hotelId;
  final String hotelName;
  final String hotelImage;
  final String roomId;
  final String roomType;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int numberOfGuests;
  final int numberOfNights;
  final double pricePerNight;
  final double totalPrice;
  final String currency;
  final BookingStatus status;
  final PaymentStatus paymentStatus;
  final String? specialRequests;
  final String guestName;
  final String guestEmail;
  final String guestPhone;
  final DateTime bookingDate;
  final String? cancellationPolicy;
  final String? paymentMethod;
  final String? confirmationCode;
  final List<String>? additionalServices;
  final double? paidAmount;
  final double? remainingAmount;

  Booking({
    required this.id,
    required this.userId,
    required this.hotelId,
    required this.hotelName,
    required this.hotelImage,
    required this.roomId,
    required this.roomType,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberOfGuests,
    required this.numberOfNights,
    required this.pricePerNight,
    required this.totalPrice,
    required this.currency,
    required this.status,
    required this.paymentStatus,
    this.specialRequests,
    required this.guestName,
    required this.guestEmail,
    required this.guestPhone,
    required this.bookingDate,
    this.cancellationPolicy,
    this.paymentMethod,
    this.confirmationCode,
    this.additionalServices,
    this.paidAmount,
    this.remainingAmount,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      userId: json['userId'] as String,
      hotelId: json['hotelId'] as String,
      hotelName: json['hotelName'] as String,
      hotelImage: json['hotelImage'] as String,
      roomId: json['roomId'] as String,
      roomType: json['roomType'] as String,
      checkInDate: DateTime.parse(json['checkInDate'] as String),
      checkOutDate: DateTime.parse(json['checkOutDate'] as String),
      numberOfGuests: json['numberOfGuests'] as int,
      numberOfNights: json['numberOfNights'] as int,
      pricePerNight: (json['pricePerNight'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      currency: json['currency'] as String,
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.name == json['paymentStatus'],
        orElse: () => PaymentStatus.pending,
      ),
      specialRequests: json['specialRequests'] as String?,
      guestName: json['guestName'] as String,
      guestEmail: json['guestEmail'] as String,
      guestPhone: json['guestPhone'] as String,
      bookingDate: DateTime.parse(json['bookingDate'] as String),
      cancellationPolicy: json['cancellationPolicy'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      confirmationCode: json['confirmationCode'] as String?,
      additionalServices: (json['additionalServices'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      paidAmount: json['paidAmount'] != null
          ? (json['paidAmount'] as num).toDouble()
          : null,
      remainingAmount: json['remainingAmount'] != null
          ? (json['remainingAmount'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'hotelId': hotelId,
      'hotelName': hotelName,
      'hotelImage': hotelImage,
      'roomId': roomId,
      'roomType': roomType,
      'checkInDate': checkInDate.toIso8601String(),
      'checkOutDate': checkOutDate.toIso8601String(),
      'numberOfGuests': numberOfGuests,
      'numberOfNights': numberOfNights,
      'pricePerNight': pricePerNight,
      'totalPrice': totalPrice,
      'currency': currency,
      'status': status.name,
      'paymentStatus': paymentStatus.name,
      'specialRequests': specialRequests,
      'guestName': guestName,
      'guestEmail': guestEmail,
      'guestPhone': guestPhone,
      'bookingDate': bookingDate.toIso8601String(),
      'cancellationPolicy': cancellationPolicy,
      'paymentMethod': paymentMethod,
      'confirmationCode': confirmationCode,
      'additionalServices': additionalServices,
      'paidAmount': paidAmount,
      'remainingAmount': remainingAmount,
    };
  }

  Booking copyWith({
    String? id,
    String? userId,
    String? hotelId,
    String? hotelName,
    String? hotelImage,
    String? roomId,
    String? roomType,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    int? numberOfGuests,
    int? numberOfNights,
    double? pricePerNight,
    double? totalPrice,
    String? currency,
    BookingStatus? status,
    PaymentStatus? paymentStatus,
    String? specialRequests,
    String? guestName,
    String? guestEmail,
    String? guestPhone,
    DateTime? bookingDate,
    String? cancellationPolicy,
    String? paymentMethod,
    String? confirmationCode,
    List<String>? additionalServices,
    double? paidAmount,
    double? remainingAmount,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      hotelId: hotelId ?? this.hotelId,
      hotelName: hotelName ?? this.hotelName,
      hotelImage: hotelImage ?? this.hotelImage,
      roomId: roomId ?? this.roomId,
      roomType: roomType ?? this.roomType,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      numberOfGuests: numberOfGuests ?? this.numberOfGuests,
      numberOfNights: numberOfNights ?? this.numberOfNights,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      totalPrice: totalPrice ?? this.totalPrice,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      specialRequests: specialRequests ?? this.specialRequests,
      guestName: guestName ?? this.guestName,
      guestEmail: guestEmail ?? this.guestEmail,
      guestPhone: guestPhone ?? this.guestPhone,
      bookingDate: bookingDate ?? this.bookingDate,
      cancellationPolicy: cancellationPolicy ?? this.cancellationPolicy,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      confirmationCode: confirmationCode ?? this.confirmationCode,
      additionalServices: additionalServices ?? this.additionalServices,
      paidAmount: paidAmount ?? this.paidAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
    );
  }

  bool get isConfirmed => status == BookingStatus.confirmed;
  bool get isPending => status == BookingStatus.pending;
  bool get isCancelled => status == BookingStatus.cancelled;
  bool get isCompleted => status == BookingStatus.completed;
  bool get isPaid => paymentStatus == PaymentStatus.paid;
  bool get isPaidPartial => paymentStatus == PaymentStatus.partial;
  bool get canCancel =>
      status == BookingStatus.confirmed || status == BookingStatus.pending;

  String get formattedTotalPrice => '$currency ${totalPrice.toStringAsFixed(2)}';
  String get formattedPricePerNight => '$currency ${pricePerNight.toStringAsFixed(2)}';

  String get dateRangeFormatted {
    final checkIn = '${checkInDate.day}/${checkInDate.month}/${checkInDate.year}';
    final checkOut = '${checkOutDate.day}/${checkOutDate.month}/${checkOutDate.year}';
    return '$checkIn - $checkOut';
  }
}

enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  completed,
  checkedIn,
  checkedOut,
}

enum PaymentStatus {
  pending,
  partial,
  paid,
  refunded,
}
</modeling_code>
</modeling_code>