import 'package:flutter/material.dart';
import 'package:ridenow_go_app/models/ride.dart'; 
import 'package:ridenow_go_app/utils/colors.dart'; 

/// A vibrant price tag widget showing fare estimates and final pricing.
/// Supports different sizes, styles, and promotional states.
class PriceTag extends StatelessWidget {
  final double? amount;
  final RideType? rideType;
  final bool isEstimate;
  final bool showStrikeThrough;
  final double? originalAmount;
  final bool isPromo;
  final String? promoCode;
  final PriceTagSize size;
  final bool showRideTypeLabel;

  PriceTag({
    this.amount,
    this.rideType,
    this.isEstimate = true,
    this.showStrikeThrough = false,
    this.originalAmount,
    this.isPromo = false,
    this.promoCode,
    this.size = PriceTagSize.medium,
    this.showRideTypeLabel = false,
  });

  PriceTag.small({
    this.amount,
    this.rideType,
    this.isEstimate = true,
    this.showStrikeThrough = false,
    this.originalAmount,
    this.isPromo = false,
    this.promoCode,
    this.showRideTypeLabel = false,
  }) : size = PriceTagSize.small;

  PriceTag.large({
    this.amount,
    this.rideType,
    this.isEstimate = true,
    this.showStrikeThrough = false,
    this.originalAmount,
    this.isPromo = false,
    this.promoCode,
    this.showRideTypeLabel = false,
  }) : size = PriceTagSize.large;

  String get _formattedAmount {
    if (amount == null) return '--';
    return '\$${amount!.toStringAsFixed(2)}';
  }

  String get _formattedOriginal {
    if (originalAmount == null) return '';
    return '\$${originalAmount!.toStringAsFixed(2)}';
  }

  double get _fontSize {
    switch (size) {
      case PriceTagSize.small:
        return 14;
      case PriceTagSize.medium:
        return 18;
      case PriceTagSize.large:
        return 28;
    }
  }

  double get _subFontSize {
    switch (size) {
      case PriceTagSize.small:
        return 11;
      case PriceTagSize.medium:
        return 13;
      case PriceTagSize.large:
        return 16;
    }
  }

  EdgeInsets get _padding {
    switch (size) {
      case PriceTagSize.small:
        return EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case PriceTagSize.medium:
        return EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case PriceTagSize.large:
        return EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    }
  }

  List<Color> get _typeGradient {
    switch (rideType) {
      case RideType.economy:
        return AppColors.economyGradient;
      case RideType.premium:
        return AppColors.premiumGradient;
      case RideType.shared:
        return AppColors.sharedGradient;
      case RideType.xl:
        return AppColors.xlGradient;
      default:
        return AppColors.primaryGradient;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showRideTypeLabel && rideType != null) ...[
          _buildRideTypeLabel(),
          SizedBox(height: 4),
        ],
        if (isPromo && promoCode != null) ...[
          _buildPromoBadge(),
          SizedBox(height: 4),
        ],
        Container(
          padding: _padding,
          decoration: BoxDecoration(
            gradient: isPromo
                ? AppColors.buildGradient(AppColors.successGradient)
                : null,
            color: isPromo ? null : AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: isPromo
                ? null
                : Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              if (showStrikeThrough && originalAmount != null) ...[
                Text(
                  _formattedOriginal,
                  style: TextStyle(
                    fontSize: _fontSize * 0.75,
                    color: AppColors.textTertiary,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                SizedBox(width: 6),
              ],
              Text(
                _formattedAmount,
                style: TextStyle(
                  fontSize: _fontSize,
                  fontWeight: FontWeight.w800,
                  color: isPromo ? Colors.white : AppColors.textPrimary,
                ),
              ),
              if (isEstimate) ...[
                SizedBox(width: 4),
                Text(
                  'est',
                  style: TextStyle(
                    fontSize: _subFontSize,
                    color: isPromo
                        ? Colors.white.withOpacity(0.8)
                        : AppColors.textTertiary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRideTypeLabel() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        gradient: AppColors.buildGradient(_typeGradient),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        rideType!.name.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildPromoBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_offer_rounded,
            size: 12,
            color: AppColors.success,
          ),
          SizedBox(width: 4),
          Text(
            promoCode!,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

enum PriceTagSize {
  small,
  medium,
  large,
}

/// A horizontal price comparison row for ride type selection.
class PriceComparisonRow extends StatelessWidget {
  final List<PriceComparisonItem> items;
  final int? selectedIndex;
  final ValueChanged<int>? onSelect;

  PriceComparisonRow({
    required this.items,
    this.selectedIndex,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isSelected = selectedIndex == index;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: onSelect != null ? () => onSelect!(index) : null,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary.withOpacity(0.08) : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      size: 24,
                      color: isSelected ? AppColors.primary : AppColors.textTertiary,
                    ),
                    SizedBox(height: 6),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4),
                    PriceTag.small(
                      amount: item.price,
                      isEstimate: item.isEstimate,
                      showStrikeThrough: item.originalPrice != null,
                      originalAmount: item.originalPrice,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class PriceComparisonItem {
  final IconData icon;
  final String label;
  final double? price;
  final double? originalPrice;
  final bool isEstimate;

  PriceComparisonItem({
    required this.icon,
    required this.label,
    this.price,
    this.originalPrice,
    this.isEstimate = true,
  });
}

/// Fare breakdown widget for payment screen.
class FareBreakdown extends StatelessWidget {
  final double? baseFare;
  final double? distanceFare;
  final double? timeFare;
  final double? surgeMultiplier;
  final double? subtotal;
  final double? promoDiscount;
  final String? promoCode;
  final double? tipAmount;
  final double? total;

  FareBreakdown({
    this.baseFare,
    this.distanceFare,
    this.timeFare,
    this.surgeMultiplier,
    this.subtotal,
    this.promoDiscount,
    this.promoCode,
    this.tipAmount,
    this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fare Breakdown',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          if (baseFare != null) _buildLineItem('Base fare', baseFare!),
          if (distanceFare != null) _buildLineItem('Distance', distanceFare!),
          if (timeFare != null) _buildLineItem('Time', timeFare!),
          if (surgeMultiplier != null && surgeMultiplier! > 1.0) ...[
            _buildLineItem(
              'Surge (${surgeMultiplier!.toStringAsFixed(1)}x)',
              (subtotal ?? 0) * (surgeMultiplier! - 1),
              isWarning: true,
            ),
          ],
          Divider(height: 24, color: AppColors.divider),
          if (subtotal != null) _buildLineItem('Subtotal', subtotal!, isBold: true),
          if (promoDiscount != null && promoDiscount! > 0) ...[
            _buildLineItem(
              'Promo $promoCode',
              -promoDiscount!,
              isSuccess: true,
            ),
          ],
          if (tipAmount != null && tipAmount! > 0) ...[
            _buildLineItem('Tip', tipAmount!),
          ],
          Divider(height: 24, color: AppColors.divider),
          if (total != null)
            _buildLineItem('Total', total!, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildLineItem(
    String label,
    double amount, {
    bool isBold = false,
    bool isTotal = false,
    bool isWarning = false,
    bool isSuccess = false,
  }) {
    Color textColor = AppColors.textPrimary;
    if (isWarning) textColor = AppColors.warning;
    if (isSuccess) textColor = AppColors.success;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isBold || isTotal ? FontWeight.w600 : FontWeight.w400,
              color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          Text(
            amount < 0 ? '-\$${(-amount).toStringAsFixed(2)}' : '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
              color: isTotal ? AppColors.primary : textColor,
            ),
          ),
        ],
      ),
    );
  }
}