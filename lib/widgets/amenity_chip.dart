import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:golden_stay_app/utils/colors.dart'; 

class AmenityChip extends StatelessWidget {
  final String amenity;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool showIcon;

  const AmenityChip({
    super.key,
    required this.amenity,
    this.isSelected = false,
    this.onTap,
    this.showIcon = true,
  });

  IconData _getIconForAmenity(String amenity) {
    final lowerAmenity = amenity.toLowerCase();
    switch (lowerAmenity) {
      case 'wifi':
        return Icons.wifi_rounded;
      case 'pool':
        return Icons.pool_rounded;
      case 'gym':
        return Icons.fitness_center_rounded;
      case 'spa':
        return Icons.spa_rounded;
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'parking':
        return Icons.local_parking_rounded;
      case 'ac':
      case 'air conditioning':
        return Icons.ac_unit_rounded;
      case 'bar':
        return Icons.bar_chart_rounded;
      case 'room service':
        return Icons.room_service_rounded;
      case 'laundry':
        return Icons.local_laundry_service_rounded;
      case 'concierge':
        return Icons.support_agent_rounded;
      case 'beach':
        return Icons.beach_access_rounded;
      case 'pet friendly':
        return Icons.pets_rounded;
      case 'airport shuttle':
        return Icons.airport_shuttle_rounded;
      case 'business center':
        return Icons.business_center_rounded;
      case 'elevator':
        return Icons.elevator_rounded;
      case 'cctv':
        return Icons.closed_caption_rounded;
      case 'security':
        return Icons.security_rounded;
      case 'breakfast':
        return Icons.free_breakfast_rounded;
      default:
        return Icons.check_circle_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.surfaceLight,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              Icon(
                _getIconForAmenity(amenity),
                size: 16,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              amenity,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}