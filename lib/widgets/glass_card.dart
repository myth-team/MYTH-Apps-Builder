import 'package:flutter/material.dart';
import 'package:scan_fit_app/utils/colors.dart'; 

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;

  GlassCard({
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 20),
      padding: padding ?? EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.85),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.04),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}