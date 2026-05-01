import 'package:flutter/material.dart';

/// Types of payment methods supported.
enum PaymentType {
  creditCard,
  debitCard,
  digitalWallet,
  cash,
}

/// Card brand identifiers.
enum CardBrand {
  visa,
  mastercard,
  amex,
  discover,
  unknown,
}

/// Represents a saved payment method.
@immutable
class PaymentMethod {
  final String id;
  final PaymentType type;
  final String displayName;
  final String? lastFourDigits;
  final CardBrand? cardBrand;
  final String? expiryDate;
  final bool isDefault;
  final String? iconUrl;

  const PaymentMethod({
    required this.id,
    required this.type,
    required this.displayName,
    this.lastFourDigits,
    this.cardBrand,
    this.expiryDate,
    this.isDefault = false,
    this.iconUrl,
  });

  PaymentMethod copyWith({
    String? id,
    PaymentType? type,
    String? displayName,
    String? lastFourDigits,
    CardBrand? cardBrand,
    String? expiryDate,
    bool? isDefault,
    String? iconUrl,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      displayName: displayName ?? this.displayName,
      lastFourDigits: lastFourDigits ?? this.lastFourDigits,
      cardBrand: cardBrand ?? this.cardBrand,
      expiryDate: expiryDate ?? this.expiryDate,
      isDefault: isDefault ?? this.isDefault,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }

  /// Masked card number display.
  String? get maskedNumber {
    if (lastFourDigits == null) return null;
    return '•••• $lastFourDigits';
  }

  /// Full display label for UI.
  String get fullDisplay {
    if (maskedNumber != null) {
      return '$displayName $maskedNumber';
    }
    return displayName;
  }

  /// Whether this is a card-based payment.
  bool get isCard => type == PaymentType.creditCard || type == PaymentType.debitCard;

  /// Whether this is a digital wallet.
  bool get isWallet => type == PaymentType.digitalWallet;

  /// Whether this is cash payment.
  bool get isCash => type == PaymentType.cash;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentMethod &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PaymentMethod($id, $type, $displayName)';
}