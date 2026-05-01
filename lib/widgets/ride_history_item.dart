import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ridenow_app/utils/colors.dart'; 
import 'package:ridenow_app/models/ride.dart'; 

class RideHistoryItem extends StatelessWidget {
  final Ride ride;
  final VoidCallback? onTap;

  RideHistoryItem({
    super.key,
    required this.ride,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 12),
            _buildRouteInfo(),
            SizedBox(height: 12),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _buildRideTypeIcon(),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ride.rideTypeDisplayName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 2),
              Text(
                _formatDate(ride.createdAt),
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildRideTypeIcon() {
    IconData icon;
    Color color;

    switch (ride.rideType) {
      case RideType.economy:
        icon = Icons.local_taxi;
        color = AppColors.rideEconomy;
        break;
      case RideType.comfort:
        icon = Icons.emoji_transportation;
        color = AppColors.rideComfort;
        break;
      case RideType.premium:
        icon = Icons.directions_car;
        color = AppColors.ridePremium;
        break;
      case RideType.xl:
        icon = Icons.airport_shuttle;
        color = AppColors.rideXL;
        break;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }

  Widget _buildStatusBadge() {
    final statusInfo = _getStatusInfo();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: statusInfo.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        statusInfo.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: statusInfo.color,
        ),
      ),
    );
  }

  Widget _buildRouteInfo() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildLocationRow(
            icon: Icons.circle,
            iconColor: AppColors.success,
            label: ride.pickupLocation.shortAddress,
            isFirst: true,
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            height: 16,
            width: 2,
            color: AppColors.border,
          ),
          _buildLocationRow(
            icon: Icons.location_on,
            iconColor: AppColors.error,
            label: ride.destinationLocation.shortAddress,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: isFirst ? 12 : 20,
          color: iconColor,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              fontWeight: isFirst || isLast ? FontWeight.w500 : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        _buildInfoChip(
          icon: Icons.straighten,
          label: ride.formattedDistance,
        ),
        SizedBox(width: 12),
        _buildInfoChip(
          icon: Icons.access_time,
          label: ride.formattedDuration,
        ),
        Spacer(),
        Text(
          ride.isCompleted ? ride.formattedActualPrice : ride.formattedPrice,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.textSecondary,
          ),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final rideDate = DateTime(date.year, date.month, date.day);

    if (rideDate == today) {
      return 'Today, ${DateFormat.jm().format(date)}';
    } else if (rideDate == yesterday) {
      return 'Yesterday, ${DateFormat.jm().format(date)}';
    } else if (now.difference(date).inDays < 7) {
      return DateFormat('EEEE, h:mm a').format(date);
    } else {
      return DateFormat('MMM d, yyyy • h:mm a').format(date);
    }
  }

  ({Color color, String label}) _getStatusInfo() {
    switch (ride.status) {
      case RideStatus.completed:
        return (color: AppColors.success, label: 'Completed');
      case RideStatus.cancelled:
        return (color: AppColors.error, label: 'Cancelled');
      default:
        return (color: AppColors.textSecondary, label: ride.statusDisplayName);
    }
  }
}