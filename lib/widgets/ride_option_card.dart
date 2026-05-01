import 'package:flutter/material.dart';
import 'package:ridenow_app/utils/colors.dart'; 
import 'package:ridenow_app/models/ride.dart'; 

class RideOptionCard extends StatelessWidget {
  final RideType rideType;
  final double estimatedPrice;
  final Duration estimatedDuration;
  final double distance;
  final bool isSelected;
  final VoidCallback? onTap;
  final int? availableDrivers;

  RideOptionCard({
    super.key,
    required this.rideType,
    required this.estimatedPrice,
    required this.estimatedDuration,
    required this.distance,
    this.isSelected = false,
    this.onTap,
    this.availableDrivers,
  });

  @override
  Widget build(BuildContext context) {
    final rideInfo = _getRideInfo();

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.15),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            _buildIconContainer(rideInfo.color),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        rideInfo.name,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (availableDrivers != null && availableDrivers! > 0) ...[
                        SizedBox(width: 8),
                        _buildAvailabilityBadge(),
                      ],
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    rideInfo.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildTimeEstimate(),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${estimatedPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _formatDistance(distance),
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
    );
  }

  Widget _buildIconContainer(Color color) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        _getRideIcon(),
        color: color,
        size: 28,
      ),
    );
  }

  Widget _buildAvailabilityBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4),
          Text(
            '$availableDrivers nearby',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeEstimate() {
    final minutes = estimatedDuration.inMinutes;
    final timeText = minutes < 60
        ? '$minutes min'
        : '${minutes ~/ 60} hr ${minutes % 60 > 0 ? (minutes % 60) : ''} min'.trim();

    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 14,
          color: AppColors.textTertiary,
        ),
        SizedBox(width: 4),
        Text(
          'Est. $timeText',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  IconData _getRideIcon() {
    switch (rideType) {
      case RideType.economy:
        return Icons.local_taxi;
      case RideType.comfort:
        return Icons.emoji_transportation;
      case RideType.premium:
        return Icons.directions_car;
      case RideType.xl:
        return Icons.airport_shuttle;
    }
  }

  ({String name, String description, Color color}) _getRideInfo() {
    switch (rideType) {
      case RideType.economy:
        return (
          name: 'Economy',
          description: 'Affordable, everyday rides',
          color: AppColors.rideEconomy,
        );
      case RideType.comfort:
        return (
          name: 'Comfort',
          description: 'Newer cars, extra legroom',
          color: AppColors.rideComfort,
        );
      case RideType.premium:
        return (
          name: 'Premium',
          description: 'Luxury vehicles, top rated drivers',
          color: AppColors.ridePremium,
        );
      case RideType.xl:
        return (
          name: 'XL',
          description: 'Extra capacity, up to 6 seats',
          color: AppColors.rideXL,
        );
    }
  }

  String _formatDistance(double km) {
    if (km < 1) {
      return '${(km * 1000).toInt()} m';
    }
    return '${km.toStringAsFixed(1)} km';
  }
}