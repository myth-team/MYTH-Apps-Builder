import 'package:flutter/material.dart';
import 'package:ride_now_app/utils/colors.dart'; 

class MapPlaceholder extends StatelessWidget {
  final double height;
  final String? label;

  MapPlaceholder({this.height = 200, this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.mapPlaceholder,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_outlined, size: 48, color: AppColors.primary),
            SizedBox(height: 8),
            Text(
              label ?? 'Map View',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}