import 'package:flutter/material.dart';
import 'package:new_project_app/utils/colors.dart'; 

class AmenityChip extends StatelessWidget {
  final String amenity;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool showIcon;

  AmenityChip({
    required this.amenity,
    this.isSelected = false,
    this.onTap,
    this.showIcon = true,
  });

  IconData _getIconForAmenity(String amenity) {
    final lowerAmenity = amenity.toLowerCase();
    if (lowerAmenity.contains('wifi')) return Icons.wifi;
    if (lowerAmenity.contains('pool')) return Icons.pool;
    if (lowerAmenity.contains('gym') || lowerAmenity.contains('fitness')) return Icons.fitness_center;
    if (lowerAmenity.contains('spa')) return Icons.spa;
    if (lowerAmenity.contains('restaurant') || lowerAmenity.contains('dining')) return Icons.restaurant;
    if (lowerAmenity.contains('parking')) return Icons.local_parking;
    if (lowerAmenity.contains('ac') || lowerAmenity.contains('air')) return Icons.ac_unit;
    if (lowerAmenity.contains('tv') || lowerAmenity.contains('cable')) return Icons.tv;
    if (lowerAmenity.contains('room service')) return Icons.room_service;
    if (lowerAmenity.contains('bar')) return Icons.local_bar;
    if (lowerAmenity.contains('laundry')) return Icons.local_laundry_service;
    if (lowerAmenity.contains('pet')) return Icons.pets;
    if (lowerAmenity.contains('beach')) return Icons.beach_access;
    if (lowerAmenity.contains('shuttle') || lowerAmenity.contains('transfer')) return Icons.transfer_within_a_station;
    if (lowerAmenity.contains('concierge')) return Icons.support_agent;
    if (lowerAmenity.contains('business')) return Icons.business_center;
    return Icons.check_circle_outline;
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
              ? AppColors.primaryGold.withOpacity(0.2)
              : AppColors.cardBlack,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryGold : AppColors.grey700,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              Icon(
                _getIconForAmenity(amenity),
                size: 16,
                color: isSelected ? AppColors.primaryGold : AppColors.grey300,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              amenity,
              style: TextStyle(
                color: isSelected ? AppColors.primaryGold : AppColors.grey300,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AmenityChipList extends StatelessWidget {
  final List<String> amenities;
  final int maxDisplay;
  final bool wrap;

  AmenityChipList({
    required this.amenities,
    this.maxDisplay = 5,
    this.wrap = true,
  });

  @override
  Widget build(BuildContext context) {
    final displayAmenities = amenities.take(maxDisplay).toList();
    final remainingCount = amenities.length - maxDisplay;

    if (wrap) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ...displayAmenities.map((amenity) => AmenityChip(
                amenity: amenity,
                showIcon: true,
              )),
          if (remainingCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.secondaryBlack,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '+$remainingCount more',
                style: const TextStyle(
                  color: AppColors.grey500,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...displayAmenities.map((amenity) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: AmenityChip(
                  amenity: amenity,
                  showIcon: true,
                ),
              )),
          if (remainingCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.secondaryBlack,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '+$remainingCount more',
                style: const TextStyle(
                  color: AppColors.grey500,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}