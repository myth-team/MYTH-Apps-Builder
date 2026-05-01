import 'package:flutter/material.dart';
import 'package:ridenow_go_app/models/driver.dart'; 
import 'package:ridenow_go_app/utils/colors.dart'; 

/// A reusable tile displaying driver information with avatar,
/// name, rating, vehicle details, and status indicator.
/// Used across ride_request, trip_active, and driver_rating screens.
class DriverInfoTile extends StatelessWidget {
  final Driver driver;
  final bool showEta;
  final bool showPhoneAction;
  final bool compact;
  final VoidCallback? onPhoneTap;
  final VoidCallback? onTap;

  DriverInfoTile({
    required this.driver,
    this.showEta = true,
    this.showPhoneAction = false,
    this.compact = false,
    this.onPhoneTap,
    this.onTap,
  });

  Color get _statusColor {
    switch (driver.status) {
      case DriverStatus.available:
        return AppColors.driverAvailable;
      case DriverStatus.enRoute:
        return AppColors.driverEnRoute;
      case DriverStatus.arrived:
        return AppColors.driverArrived;
      case DriverStatus.inTrip:
        return AppColors.driverBusy;
      case DriverStatus.offline:
        return AppColors.neutral400;
    }
  }

  String get _statusText {
    switch (driver.status) {
      case DriverStatus.available:
        return 'Available';
      case DriverStatus.enRoute:
        return 'En route';
      case DriverStatus.arrived:
        return 'Arrived';
      case DriverStatus.inTrip:
        return 'In trip';
      case DriverStatus.offline:
        return 'Offline';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompactTile();
    }
    return _buildFullTile();
  }

  Widget _buildCompactTile() {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          _buildAvatar(size: 48),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  driver.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Text(
                  driver.vehicleDisplay,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (showEta && driver.etaMinutes != null) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${driver.etaMinutes!.ceil()} min',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFullTile() {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildAvatar(size: 56),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver.name,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: AppColors.starFilled,
                          ),
                          SizedBox(width: 4),
                          Text(
                            driver.ratingDisplay,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '(${driver.totalTrips} trips)',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (showPhoneAction)
                  _buildActionButton(
                    icon: Icons.phone_outlined,
                    onTap: onPhoneTap,
                  ),
              ],
            ),
            SizedBox(height: 14),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildVehicleInfo(),
                  ),
                  Container(
                    width: 1,
                    height: 32,
                    color: AppColors.divider,
                    margin: EdgeInsets.symmetric(horizontal: 14),
                  ),
                  Expanded(
                    child: _buildStatusInfo(),
                  ),
                ],
              ),
            ),
            if (showEta && driver.etaMinutes != null) ...[
              SizedBox(height: 12),
              _buildEtaBar(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar({required double size}) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.buildGradient(AppColors.primaryGradient),
          ),
          child: ClipOval(
            child: driver.photoUrl != null
                ? Image.network(
                    driver.photoUrl!,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildFallbackAvatar(size);
                    },
                  )
                : _buildFallbackAvatar(size),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: size * 0.3,
            height: size * 0.3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _statusColor,
              border: Border.all(
                color: AppColors.surface,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackAvatar(double size) {
    return Container(
      width: size,
      height: size,
      color: AppColors.primary,
      child: Center(
        child: Text(
          driver.name.isNotEmpty ? driver.name[0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 22,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildVehicleInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textTertiary,
          ),
        ),
        SizedBox(height: 2),
        Text(
          driver.vehicleDisplay,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          driver.licensePlate,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textTertiary,
          ),
        ),
        SizedBox(height: 2),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _statusColor,
              ),
            ),
            SizedBox(width: 6),
            Text(
              _statusText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _statusColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEtaBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: AppColors.buildGradient(AppColors.primaryGradient),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 18,
            color: Colors.white,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Arriving in ${driver.etaMinutes!.ceil()} minutes',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Your driver is on the way',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}