import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:golden_stay_app/utils/colors.dart'; 
import 'package:golden_stay_app/models/hotel.dart'; 

class HotelCard extends StatefulWidget {
  final Hotel hotel;
  final VoidCallback? onTap;
  final bool isCompact;

  const HotelCard({
    super.key,
    required this.hotel,
    this.onTap,
    this.isCompact = false,
  });

  @override
  State<HotelCard> createState() => _HotelCardState();
}

class _HotelCardState extends State<HotelCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isCompact) {
      return _buildCompactCard();
    }
    return _buildFullCard();
  }

  Widget _buildFullCard() {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _isPressed
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.3),
              blurRadius: _isPressed ? 10 : 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleRow(),
                  const SizedBox(height: 8),
                  _buildLocationRow(),
                  const SizedBox(height: 12),
                  _buildAmenitiesRow(),
                  const SizedBox(height: 12),
                  _buildPriceRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactCard() {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(height: 140),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleRow(fontSize: 16),
                  const SizedBox(height: 4),
                  _buildLocationRow(fontSize: 12),
                  const SizedBox(height: 8),
                  _buildPriceRow(fontSize: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection({double? height}) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: widget.hotel.thumbnailUrl,
            height: height ?? 180,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              height: height ?? 180,
              color: AppColors.surfaceLight,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              height: height ?? 180,
              color: AppColors.surfaceLight,
              child: const Icon(
                Icons.hotel_rounded,
                color: AppColors.textMuted,
                size: 48,
              ),
            ),
          ),
          if (widget.hotel.isFeatured)
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'FEATURED',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.background,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.hotel.formattedRating,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleRow({double? fontSize}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.hotel.name,
            style: GoogleFonts.inter(
              fontSize: fontSize ?? 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationRow({double? fontSize}) {
    return Row(
      children: [
        const Icon(
          Icons.location_on_rounded,
          size: 14,
          color: AppColors.primary,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            '${widget.hotel.city}, ${widget.hotel.address}',
            style: GoogleFonts.inter(
              fontSize: fontSize ?? 13,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildAmenitiesRow() {
    final displayAmenities = widget.hotel.amenities.take(4).toList();
    return Row(
      children: [
        ...displayAmenities.map((amenity) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIconForAmenity(amenity),
                  size: 14,
                  color: AppColors.primary,
                ),
              ),
            )),
        if (widget.hotel.amenities.length > 4)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '+${widget.hotel.amenities.length - 4}',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPriceRow({double? fontSize}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              widget.hotel.formattedPrice,
              style: GoogleFonts.inter(
                fontSize: (fontSize ?? 22),
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            Text(
              ' / night',
              style: GoogleFonts.inter(
                fontSize: (fontSize ?? 22) * 0.55,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${widget.hotel.reviewCount} reviews',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

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
      default:
        return Icons.check_circle_rounded;
    }
  }
}