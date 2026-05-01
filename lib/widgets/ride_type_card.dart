import 'package:flutter/material.dart';
import 'package:ridenow_go_app/models/ride.dart'; 
import 'package:ridenow_go_app/utils/colors.dart'; 
import 'package:ridenow_go_app/widgets/price_tag.dart'; 

/// A selectable card for choosing ride type with gradient accents,
/// vehicle info, ETA, and pricing. Used in home bottom sheet.
class RideTypeCard extends StatelessWidget {
  final RideType type;
  final bool isSelected;
  final double? price;
  final double? originalPrice;
  final int? etaMinutes;
  final int? capacity;
  final VoidCallback? onTap;

  RideTypeCard({
    required this.type,
    this.isSelected = false,
    this.price,
    this.originalPrice,
    this.etaMinutes,
    this.capacity,
    this.onTap,
  });

  String get _displayName {
    switch (type) {
      case RideType.economy:
        return 'Economy';
      case RideType.premium:
        return 'Premium';
      case RideType.shared:
        return 'Shared';
      case RideType.xl:
        return 'XL';
    }
  }

  String get _description {
    switch (type) {
      case RideType.economy:
        return 'Affordable everyday rides';
      case RideType.premium:
        return 'Luxury vehicles, top drivers';
      case RideType.shared:
        return 'Split cost, shared route';
      case RideType.xl:
        return 'Extra space for groups';
    }
  }

  IconData get _vehicleIcon {
    switch (type) {
      case RideType.economy:
        return Icons.directions_car_filled_rounded;
      case RideType.premium:
        return Icons.local_taxi_rounded;
      case RideType.shared:
        return Icons.people_alt_rounded;
      case RideType.xl:
        return Icons.airport_shuttle_rounded;
    }
  }

  List<Color> get _gradient {
    switch (type) {
      case RideType.economy:
        return AppColors.economyGradient;
      case RideType.premium:
        return AppColors.premiumGradient;
      case RideType.shared:
        return AppColors.sharedGradient;
      case RideType.xl:
        return AppColors.xlGradient;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surface : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.15),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            _buildIconContainer(),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        _displayName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (capacity != null) ...[
                        SizedBox(width: 8),
                        _buildCapacityBadge(),
                      ],
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    _description,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (etaMinutes != null) ...[
                    SizedBox(height: 6),
                    _buildEtaRow(),
                  ],
                ],
              ),
            ),
            PriceTag(
              amount: price,
              originalAmount: originalPrice,
              isEstimate: true,
              showStrikeThrough: originalPrice != null,
              size: PriceTagSize.small,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconContainer() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: AppColors.buildGradient(_gradient),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: _gradient.first.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          _vehicleIcon,
          size: 28,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCapacityBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person_rounded,
            size: 12,
            color: AppColors.textTertiary,
          ),
          SizedBox(width: 2),
          Text(
            '$capacity',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEtaRow() {
    return Row(
      children: [
        Icon(
          Icons.access_time_rounded,
          size: 14,
          color: AppColors.success,
        ),
        SizedBox(width: 4),
        Text(
          '$etaMinutes min away',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.success,
          ),
        ),
      ],
    );
  }
}

/// A horizontal scrollable list of ride type cards.
class RideTypeSelector extends StatelessWidget {
  final List<RideTypeCardData> options;
  final RideType? selectedType;
  final ValueChanged<RideType>? onTypeSelected;

  RideTypeSelector({
    required this.options,
    this.selectedType,
    this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: options.length,
      separatorBuilder: (context, index) => SizedBox(height: 10),
      itemBuilder: (context, index) {
        final option = options[index];
        return RideTypeCard(
          type: option.type,
          isSelected: selectedType == option.type,
          price: option.price,
          originalPrice: option.originalPrice,
          etaMinutes: option.etaMinutes,
          capacity: option.capacity,
          onTap: onTypeSelected != null
              ? () => onTypeSelected!(option.type)
              : null,
        );
      },
    );
  }
}

class RideTypeCardData {
  final RideType type;
  final double? price;
  final double? originalPrice;
  final int? etaMinutes;
  final int? capacity;

  RideTypeCardData({
    required this.type,
    this.price,
    this.originalPrice,
    this.etaMinutes,
    this.capacity,
  });
}

/// Compact chip version for quick selection in smaller spaces.
class RideTypeChip extends StatelessWidget {
  final RideType type;
  final bool isSelected;
  final double? price;
  final VoidCallback? onTap;

  RideTypeChip({
    required this.type,
    this.isSelected = false,
    this.price,
    this.onTap,
  });

  IconData get _icon {
    switch (type) {
      case RideType.economy:
        return Icons.directions_car_filled_rounded;
      case RideType.premium:
        return Icons.local_taxi_rounded;
      case RideType.shared:
        return Icons.people_alt_rounded;
      case RideType.xl:
        return Icons.airport_shuttle_rounded;
    }
  }

  String get _label {
    switch (type) {
      case RideType.economy:
        return 'Economy';
      case RideType.premium:
        return 'Premium';
      case RideType.shared:
        return 'Shared';
      case RideType.xl:
        return 'XL';
    }
  }

  List<Color> get _gradient {
    switch (type) {
      case RideType.economy:
        return AppColors.economyGradient;
      case RideType.premium:
        return AppColors.premiumGradient;
      case RideType.shared:
        return AppColors.sharedGradient;
      case RideType.xl:
        return AppColors.xlGradient;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.buildGradient(_gradient) : null,
          color: isSelected ? null : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            SizedBox(width: 6),
            Text(
              _label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            if (price != null) ...[
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.2)
                      : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '\$${price!.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}