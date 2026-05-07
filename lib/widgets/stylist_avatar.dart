import 'package:flutter/material.dart';
import 'package:stylebook_salon_app/utils/colors.dart'; 

class StylistAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double size;
  final bool showRating;
  final double? rating;
  final VoidCallback? onTap;

  const StylistAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = 64,
    this.showRating = false,
    this.rating,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final initials = name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join();

    Widget avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryLight,
        border: Border.all(color: AppColors.primary, width: 2),
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: imageUrl == null
          ? Center(
              child: Text(
                initials,
                style: TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: size * 0.35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );

    if (onTap != null) {
      avatar = InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: avatar,
      );
    }

    if (!showRating || rating == null) {
      return avatar;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        avatar,
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star,
                size: 12,
                color: AppColors.textPrimary,
              ),
              const SizedBox(width: 2),
              Text(
                rating!.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}