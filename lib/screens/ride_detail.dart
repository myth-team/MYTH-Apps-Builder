import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ridenow_app/utils/colors.dart'; 
import 'package:ridenow_app/models/ride.dart'; 
import 'package:ridenow_app/widgets/map_widget.dart'; 
import 'package:ridenow_app/widgets/driver_info_card.dart'; 
import 'package:ridenow_app/services/ride_service.dart'; 
import 'package:intl/intl.dart';

class RideDetailScreen extends StatefulWidget {
  const RideDetailScreen({super.key});

  @override
  State<RideDetailScreen> createState() => _RideDetailScreenState();
}

class _RideDetailScreenState extends State<RideDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listenToRideUpdates();
    });
  }

  void _listenToRideUpdates() {
    final rideService = context.read<RideService>();
    rideService.rideUpdates?.listen((ride) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _cancelRide() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Ride?'),
        content: Text('Are you sure you want to cancel this ride?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final rideService = context.read<RideService>();
      final success = await rideService.cancelRide();
      if (success && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RideService>(
      builder: (context, rideService, child) {
        final ride = rideService.activeRide;

        if (ride == null) {
          return _buildNoActiveRide();
        }

        return Scaffold(
          body: Stack(
            children: [
              _buildMap(ride),
              _buildContent(ride),
              _buildStatusBanner(ride),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoActiveRide() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Details'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car_outlined,
              size: 80,
              color: AppColors.textTertiary,
            ),
            SizedBox(height: 20),
            Text(
              'No Active Ride',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'You don\'t have an active ride',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text('Book a Ride'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap(Ride ride) {
    return Positioned.fill(
      child: MapWidget(
        currentLocation: ride.pickupLocation,
        pickupLocation: ride.pickupLocation,
        destinationLocation: ride.destinationLocation,
        driverLocation: ride.driverLocation,
        routePoints: ride.routePoints ?? [],
        isTrackingDriver: ride.isActive,
        initialZoom: 14.0,
      ),
    );
  }

  Widget _buildContent(Ride ride) {
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.25,
      maxChildSize: 0.75,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 20,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDragHandle(),
                SizedBox(height: 20),
                if (ride.driver != null) _buildDriverSection(ride),
                SizedBox(height: 20),
                _buildRouteInfo(ride),
                SizedBox(height: 20),
                _buildPriceInfo(ride),
                if (ride.isActive) ...[
                  SizedBox(height: 24),
                  _buildCancelButton(),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildDriverSection(Ride ride) {
    return DriverInfoCard(
      driver: ride.driver!,
      rideStatus: ride.status,
      onCallPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Calling ${ride.driver!.name}...')),
        );
      },
      onMessagePressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Messaging ${ride.driver!.name}...')),
        );
      },
    );
  }

  Widget _buildRouteInfo(Ride ride) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildLocationRow(
            icon: Icons.circle,
            iconColor: AppColors.success,
            label: 'Pickup',
            address: ride.pickupLocation.shortAddress,
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            height: 24,
            width: 2,
            color: AppColors.border,
          ),
          _buildLocationRow(
            icon: Icons.location_on,
            iconColor: AppColors.error,
            label: 'Destination',
            address: ride.destinationLocation.shortAddress,
          ),
          Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoItem(
                icon: Icons.straighten,
                label: 'Distance',
                value: ride.formattedDistance,
              ),
              _buildInfoItem(
                icon: Icons.access_time,
                label: 'Duration',
                value: ride.formattedDuration,
              ),
              if (ride.eta != null)
                _buildInfoItem(
                  icon: Icons.schedule,
                  label: 'ETA',
                  value: DateFormat.jm().format(ride.eta!),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String address,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                address,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceInfo(Ride ride) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Estimated Fare',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                ride.formattedPrice,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _getStatusColor(ride.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getStatusIcon(ride.status),
                  size: 18,
                  color: _getStatusColor(ride.status),
                ),
                SizedBox(width: 6),
                Text(
                  ride.statusDisplayName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(ride.status),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _cancelRide,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          padding: EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(color: AppColors.error),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Cancel Ride',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBanner(Ride ride) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: _getStatusColor(ride.status),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _getStatusColor(ride.status).withOpacity(0.3),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                _getStatusIcon(ride.status),
                color: AppColors.textOnPrimary,
                size: 22,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  ride.statusDisplayName,
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (ride.isActive)
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(RideStatus status) {
    switch (status) {
      case RideStatus.pending:
        return AppColors.statusPending;
      case RideStatus.accepted:
        return AppColors.statusAccepted;
      case RideStatus.arriving:
        return AppColors.statusArriving;
      case RideStatus.inProgress:
        return AppColors.statusInProgress;
      case RideStatus.completed:
        return AppColors.statusCompleted;
      case RideStatus.cancelled:
        return AppColors.statusCancelled;
    }
  }

  IconData _getStatusIcon(RideStatus status) {
    switch (status) {
      case RideStatus.pending:
        return Icons.search;
      case RideStatus.accepted:
        return Icons.check_circle_outline;
      case RideStatus.arriving:
        return Icons.directions_car;
      case RideStatus.inProgress:
        return Icons.directions;
      case RideStatus.completed:
        return Icons.check_circle;
      case RideStatus.cancelled:
        return Icons.cancel;
    }
  }
}