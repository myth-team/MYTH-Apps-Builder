import 'package:flutter/material.dart';
import 'package:ridesync_app/utils/colors.dart'; 

enum VehicleType { economy, comfort, luxury, xl }

class VehicleCard extends StatelessWidget {
  final VehicleType type;
  final String? driverName;
  final String? driverRating;
  final double price;
  final double? originalPrice;
  final String eta;
  final double distance;
  final bool isSelected;
  final bool isAvailable;
  final VoidCallback? onTap;
  final String currency;

  const VehicleCard({
    super.key,
    required this.type,
    this.driverName,
    this.driverRating,
    required this.price,
    this.originalPrice,
    required this.eta,
    required this.distance,
    this.isSelected = false,
    this.isAvailable = true,
    this.onTap,
    this.currency = '\$',
  });

  String get _vehicleName {
    switch (type) {
      case VehicleType.economy:
        return 'Economy';
      case VehicleType.comfort:
        return 'Comfort';
      case VehicleType.luxury:
        return 'Luxury';
      case VehicleType.xl:
        return 'XL';
    }
  }

  String get _vehicleDescription {
    switch (type) {
      case VehicleType.economy:
        return 'Affordable, everyday rides';
      case VehicleType.comfort:
        return 'Newer cars with extra legroom';
      case VehicleType.luxury:
        return 'Premium luxury experience';
      case VehicleType.xl:
        return 'Spacious for larger groups';
    }
  }

  String get _vehicleImagePath {
    switch (type) {
      case VehicleType.economy:
        return 'https://img.icons8.com/color/96/sedan.png';
      case VehicleType.comfort:
        return 'https://img.icons8.com/color/96/car.png';
      case VehicleType.luxury:
        return 'https://img.icons8.com/color/96/limousine.png';
      case VehicleType.xl:
        return 'https://img.icons8.com/color/96/van.png';
    }
  }

  Color get _vehicleColor {
    switch (type) {
      case VehicleType.economy:
        return AppColors.vehicleEconomy;
      case VehicleType.comfort:
        return AppColors.vehicleComfort;
      case VehicleType.luxury:
        return AppColors.vehicleLuxury;
      case VehicleType.xl:
        return AppColors.vehicleXL;
    }
  }

  IconData get _vehicleIcon {
    switch (type) {
      case VehicleType.economy:
        return Icons.directions_car;
      case VehicleType.comfort:
        return Icons.airport_shuttle;
      case VehicleType.luxury:
        return Icons.diamond;
      case VehicleType.xl:
        return Icons.people;
    }
  }

  int get _seats {
    switch (type) {
      case VehicleType.economy:
        return 4;
      case VehicleType.comfort:
        return 4;
      case VehicleType.luxury:
        return 4;
      case VehicleType.xl:
        return 6;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withAlpha(51)
                  : AppColors.grey300.withAlpha(51),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Opacity(
          opacity: isAvailable ? 1.0 : 0.5,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _buildVehicleImage(),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildVehicleInfo(),
                    ),
                    _buildPriceSection(),
                  ],
                ),
              ),
              if (driverName != null) _buildDriverInfo(),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleImage() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: _vehicleColor.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Image.network(
          _vehicleImagePath,
          width: 48,
          height: 48,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              _vehicleIcon,
              size: 36,
              color: _vehicleColor,
            );
          },
        ),
      ),
    );
  }

  Widget _buildVehicleInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              _vehicleName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _vehicleColor.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person,
                    size: 14,
                    color: _vehicleColor,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '$_seats',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _vehicleColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          _vehicleDescription,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 14,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              eta,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.straighten,
              size: 14,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              '${distance.toStringAsFixed(1)} km',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (originalPrice != null && originalPrice! > price)
          Text(
            '$currency${originalPrice!.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        Text(
          '$currency${price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
        if (driverName == null)
          Text(
            'Est. fare',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
      ],
    );
  }

  Widget _buildDriverInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        border: Border(
          top: BorderSide(color: AppColors.borderLight),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary,
            child: Text(
              driverName?.substring(0, 1).toUpperCase() ?? 'D',
              style: TextStyle(
                color: AppColors.textOnPrimary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driverName ?? 'Driver',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 14,
                      color: AppColors.starFilled,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      driverRating ?? '5.0',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 14,
                  color: AppColors.success,
                ),
                const SizedBox(width: 4),
                Text(
                  'Confirmed',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        border: Border(
          top: BorderSide(color: AppColors.borderLight),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildFeatureChip(Icons.verified_user, 'Verified'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildFeatureChip(Icons.ac_unit, 'AC'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildFeatureChip(Icons.music_note, 'Music'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class VehicleTypeSelector extends StatelessWidget {
  final VehicleType? selectedType;
  final Function(VehicleType) onTypeSelected;
  final Map<VehicleType, double> prices;
  final Map<VehicleType, String> etas;
  final Map<VehicleType, double> distances;
  final String currency;

  const VehicleTypeSelector({
    super.key,
    this.selectedType,
    required this.onTypeSelected,
    required this.prices,
    required this.etas,
    required this.distances,
    this.currency = '\$',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: VehicleType.values.map((type) {
        final price = prices[type] ?? 0.0;
        final eta = etas[type] ?? '';
        final distance = distances[type] ?? 0.0;

        return VehicleCard(
          type: type,
          price: price,
          eta: eta,
          distance: distance,
          isSelected: selectedType == type,
          onTap: () => onTypeSelected(type),
          currency: currency,
        );
      }).toList(),
    );
  }
}

class FareBreakdownSummary extends StatelessWidget {
  final double baseFare;
  final double distanceFare;
  final double timeFare;
  final double serviceFee;
  final double discount;
  final String currency;
  final String? promoCode;

  const FareBreakdownSummary({
    super.key,
    required this.baseFare,
    required this.distanceFare,
    required this.timeFare,
    required this.serviceFee,
    this.discount = 0.0,
    this.currency = '\$',
    this.promoCode,
  });

  double get _subtotal => baseFare + distanceFare + timeFare + serviceFee;
  double get _total => _subtotal - discount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withAlpha(51),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fare Breakdown',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildFareRow('Base Fare', baseFare),
          _buildFareRow('Distance Fare', distanceFare),
          _buildFareRow('Time Fare', timeFare),
          _buildFareRow('Service Fee', serviceFee),
          if (discount > 0)
            _buildFareRow('Discount', -discount, isDiscount: true),
          if (promoCode != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_offer,
                      size: 14,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      promoCode!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          Divider(color: AppColors.borderLight),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '$currency${_total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFareRow(String label, double amount, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            '${isDiscount ? '-' : ''}$currency${amount.abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              color: isDiscount ? AppColors.success : AppColors.textPrimary,
              fontWeight: isDiscount ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class VehicleSelectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onClose;

  const VehicleSelectionHeader({
    super.key,
    this.title = 'Select Vehicle',
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withAlpha(51),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              if (onClose != null)
                GestureDetector(
                  onTap: onClose,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}