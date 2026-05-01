import 'package:flutter/material.dart';
import 'package:ride_now_app/utils/colors.dart'; 

class RideTypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final String? price;

  RideTypeChip({
    required this.label,
    required this.icon,
    this.selected = false,
    required this.onTap,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
            width: 2,
          ),
          boxShadow: selected
              ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: Offset(0, 2))]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : AppColors.textSecondary,
              size: 28,
            ),
            SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            if (price != null) ...[
              SizedBox(height: 4),
              Text(
                price!,
                style: TextStyle(
                  color: selected ? Colors.white70 : AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}