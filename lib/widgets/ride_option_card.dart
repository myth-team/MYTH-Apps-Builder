import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_now_app/utils/colors.dart'; 
import 'package:ride_now_app/utils/constants.dart'; 

class RideOptionCard extends StatelessWidget {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final double baseFare;
  final double? estimatedFare;
  final int capacity;
  final Color color;
  final bool isSelected;
  final VoidCallback? onTap;

  const RideOptionCard({
    super.key,
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.baseFare,
    this.estimatedFare,
    required this.capacity,
    required this.color,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.shortAnimation,
        padding: const EdgeInsets.all(AppConstants.spacingM),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(26) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? color.withAlpha(51)
                  : AppColors.primary.withAlpha(13),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withAlpha(26),
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingS),
            Text(
              name,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppConstants.spacingS),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 14,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$capacity',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                if (estimatedFare != null)
                  Text(
                    '\$${estimatedFare!.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? color : AppColors.textPrimary,
                    ),
                  )
                else
                  Text(
                    'From \$${baseFare.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
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
}

class RideOptionData {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final double baseFare;
  final double perKm;
  final double perMinute;
  final int capacity;
  final int colorValue;

  const RideOptionData({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.baseFare,
    required this.perKm,
    required this.perMinute,
    required this.capacity,
    required this.colorValue,
  });

  Color get color => Color(colorValue);

  IconData get icon {
    switch (iconName) {
      case 'directions_car':
        return Icons.directions_car;
      case 'airline_seat_recline_extra':
        return Icons.airline_seat_recline_extra;
      case 'star':
        return Icons.star;
      case 'diamond':
        return Icons.diamond;
      default:
        return Icons.directions_car;
    }
  }

  double calculateFare(double distanceKm, int durationMinutes) {
    return baseFare + (distanceKm * perKm) + (durationMinutes * perMinute);
  }

  factory RideOptionData.fromJson(Map<String, dynamic> json) {
    return RideOptionData(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconName: json['iconName'] as String,
      baseFare: (json['baseFare'] as num).toDouble(),
      perKm: (json['perKm'] as num).toDouble(),
      perMinute: (json['perMinute'] as num).toDouble(),
      capacity: json['capacity'] as int,
      colorValue: json['colorValue'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconName': iconName,
      'baseFare': baseFare,
      'perKm': perKm,
      'perMinute': perMinute,
      'capacity': capacity,
      'colorValue': colorValue,
    };
  }
}