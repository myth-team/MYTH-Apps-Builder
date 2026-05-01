import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_now_app/utils/colors.dart'; 
import 'package:ride_now_app/utils/constants.dart'; 
import 'package:intl/intl.dart';

class RecentRideCard extends StatelessWidget {
  final String id;
  final String pickupAddress;
  final String destinationAddress;
  final String rideType;
  final double fare;
  final DateTime dateTime;
  final String? driverName;
  final String? driverImage;
  final VoidCallback? onTap;
  final VoidCallback? onRepeat;

  const RecentRideCard({
    super.key,
    required this.id,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.rideType,
    required this.fare,
    required this.dateTime,
    this.driverName,
    this.driverImage,
    this.onTap,
    this.onRepeat,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, h:mm a');
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppConstants.spacingM),
        padding: const EdgeInsets.all(AppConstants.spacingM),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(13),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingS,
                    vertical: AppConstants.spacingXS,
                  ),
                  decoration: BoxDecoration(
                    color: _getRideTypeColor(rideType).withAlpha(26),
                    borderRadius: BorderRadius.circular(AppConstants.radiusS),
                  ),
                  child: Text(
                    rideType,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _getRideTypeColor(rideType),
                    ),
                  ),
                ),
                Text(
                  currencyFormat.format(fare),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingS),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingS),
                Expanded(
                  child: Text(
                    pickupAddress,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 3),
              child: Container(
                width: 2,
                height: 16,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingS),
                Expanded(
                  child: Text(
                    destinationAddress,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingM),
            const Divider(height: 1, color: AppColors.divider),
            const SizedBox(height: AppConstants.spacingS),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (driverImage != null)
                      CircleAvatar(
                        radius: 14,
                        backgroundImage: NetworkImage(driverImage!),
                        backgroundColor: AppColors.primaryLight,
                      )
                    else
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.primaryLight,
                        child: Icon(
                          Icons.person,
                          size: 16,
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                    const SizedBox(width: AppConstants.spacingS),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (driverName != null)
                          Text(
                            driverName!,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        Text(
                          dateFormat.format(dateTime),
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (onRepeat != null)
                  GestureDetector(
                    onTap: onRepeat,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingS,
                        vertical: AppConstants.spacingXS,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(26),
                        borderRadius: BorderRadius.circular(AppConstants.radiusS),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.replay,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Repeat',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getRideTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'economy':
        return AppColors.economy;
      case 'comfort':
        return AppColors.comfort;
      case 'premium':
        return AppColors.premium;
      case 'luxury':
        return AppColors.luxury;
      default:
        return AppColors.primary;
    }
  }
}

class RecentRideData {
  final String id;
  final String pickupAddress;
  final String destinationAddress;
  final String rideType;
  final double fare;
  final DateTime dateTime;
  final double? pickupLat;
  final double? pickupLng;
  final double? destLat;
  final double? destLng;
  final String? driverName;
  final String? driverImage;
  final String? driverPhone;

  const RecentRideData({
    required this.id,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.rideType,
    required this.fare,
    required this.dateTime,
    this.pickupLat,
    this.pickupLng,
    this.destLat,
    this.destLng,
    this.driverName,
    this.driverImage,
    this.driverPhone,
  });

  factory RecentRideData.fromJson(Map<String, dynamic> json) {
    return RecentRideData(
      id: json['id'] as String,
      pickupAddress: json['pickupAddress'] as String,
      destinationAddress: json['destinationAddress'] as String,
      rideType: json['rideType'] as String,
      fare: (json['fare'] as num).toDouble(),
      dateTime: DateTime.parse(json['dateTime'] as String),
      pickupLat: (json['pickupLat'] as num?)?.toDouble(),
      pickupLng: (json['pickupLng'] as num?)?.toDouble(),
      destLat: (json['destLat'] as num?)?.toDouble(),
      destLng: (json['destLng'] as num?)?.toDouble(),
      driverName: json['driverName'] as String?,
      driverImage: json['driverImage'] as String?,
      driverPhone: json['driverPhone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pickupAddress': pickupAddress,
      'destinationAddress': destinationAddress,
      'rideType': rideType,
      'fare': fare,
      'dateTime': dateTime.toIso8601String(),
      'pickupLat': pickupLat,
      'pickupLng': pickupLng,
      'destLat': destLat,
      'destLng': destLng,
      'driverName': driverName,
      'driverImage': driverImage,
      'driverPhone': driverPhone,
    };
  }
}