import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ridenow_app/utils/colors.dart'; 
import 'package:ridenow_app/models/driver.dart'; 
import 'package:ridenow_app/models/ride.dart'; 

class DriverInfoCard extends StatelessWidget {
  final Driver driver;
  final RideStatus? rideStatus;
  final VoidCallback? onCallPressed;
  final VoidCallback? onMessagePressed;
  final bool isCompact;

  DriverInfoCard({
    super.key,
    required this.driver,
    this.rideStatus,
    this.onCallPressed,
    this.onMessagePressed,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _buildCompactCard();
    }
    return _buildFullCard();
  }

  Widget _buildCompactCard() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildDriverAvatar(size: 48),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  driver.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    _buildRatingBadge(),
                    SizedBox(width: 8),
                    Text(
                      '${driver.vehicleInfo.model} • ${driver.vehicleInfo.color}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (driver.phoneNumber != null) _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildFullCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildDriverAvatar(size: 72),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          driver.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (driver.isOnline) ...[
                          SizedBox(width: 8),
                          _buildOnlineIndicator(),
                        ],
                      ],
                    ),
                    SizedBox(height: 6),
                    _buildRatingWithCount(),
                    SizedBox(height: 8),
                    Text(
                      '${driver.vehicleInfo.model} • ${driver.vehicleInfo.color}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.confirmation_number_outlined,
                  size: 20,
                  color: AppColors.primary,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    driver.vehicleInfo.licensePlate,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (rideStatus != null) ...[
            SizedBox(height: 16),
            _buildStatusBadge(),
          ],
          SizedBox(height: 20),
          Row(
            children: [
              if (driver.phoneNumber != null)
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.phone,
                    label: 'Call',
                    onPressed: onCallPressed,
                    isPrimary: true,
                  ),
                ),
              if (driver.phoneNumber != null) SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: 'Message',
                  onPressed: onMessagePressed,
                  isPrimary: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDriverAvatar({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: driver.photoUrl != null
            ? CachedNetworkImage(
                imageUrl: driver.photoUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.primaryLight.withOpacity(0.2),
                  child: Icon(
                    Icons.person,
                    size: size * 0.5,
                    color: AppColors.primary,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.primaryLight.withOpacity(0.2),
                  child: Icon(
                    Icons.person,
                    size: size * 0.5,
                    color: AppColors.primary,
                  ),
                ),
              )
            : Container(
                color: AppColors.primaryLight.withOpacity(0.2),
                child: Icon(
                  Icons.person,
                  size: size * 0.5,
                  color: AppColors.primary,
                ),
              ),
      ),
    );
  }

  Widget _buildRatingBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: 12,
            color: AppColors.accent,
          ),
          SizedBox(width: 2),
          Text(
            driver.rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingWithCount() {
    return Row(
      children: [
        Icon(
          Icons.star,
          size: 18,
          color: AppColors.accent,
        ),
        SizedBox(width: 4),
        Text(
          driver.rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(width: 4),
        Text(
          'rating',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildOnlineIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4),
          Text(
            'Online',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    final statusInfo = _getStatusInfo();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: statusInfo.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusInfo.icon,
            size: 18,
            color: statusInfo.color,
          ),
          SizedBox(width: 8),
          Text(
            statusInfo.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: statusInfo.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (driver.phoneNumber != null)
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.phone, size: 20),
              color: AppColors.textOnPrimary,
              onPressed: onCallPressed,
              padding: EdgeInsets.all(8),
              constraints: BoxConstraints(),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required bool isPrimary,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? AppColors.primary : AppColors.background,
        foregroundColor: isPrimary ? AppColors.textOnPrimary : AppColors.textPrimary,
        elevation: isPrimary ? 0 : 0,
        padding: EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isPrimary
              ? BorderSide.none
              : BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  ({Color color, IconData icon, String label}) _getStatusInfo() {
    switch (rideStatus) {
      case RideStatus.pending:
        return (color: AppColors.warning, icon: Icons.search, label: 'Finding driver...');
      case RideStatus.accepted:
        return (color: AppColors.info, icon: Icons.check_circle_outline, label: 'Driver accepted');
      case RideStatus.arriving:
        return (color: AppColors.rideComfort, icon: Icons.directions_car, label: 'Driver arriving');
      case RideStatus.inProgress:
        return (color: AppColors.success, icon: Icons.directions, label: 'In progress');
      case RideStatus.completed:
        return (color: AppColors.success, icon: Icons.check_circle, label: 'Completed');
      case RideStatus.cancelled:
        return (color: AppColors.error, icon: Icons.cancel, label: 'Cancelled');
      default:
        return (color: AppColors.textSecondary, icon: Icons.info_outline, label: 'Unknown');
    }
  }
}