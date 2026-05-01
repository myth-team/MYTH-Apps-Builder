import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ridenow_go_app/models/driver.dart'; 
import 'package:ridenow_go_app/models/ride.dart'; 
import 'package:ridenow_go_app/services/ride_service.dart'; 
import 'package:ridenow_go_app/utils/colors.dart'; 
import 'package:ridenow_go_app/widgets/driver_info_tile.dart'; 

class RideRequestScreen extends StatefulWidget {
  final Ride? initialRide;

  RideRequestScreen({this.initialRide});

  @override
  _RideRequestScreenState createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends State<RideRequestScreen>
    with TickerProviderStateMixin {
  final RideService _rideService = RideService.instance;

  Ride? _ride;
  StreamSubscription? _rideSubscription;

  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _progressController;

  bool _isCancelling = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat();

    _slideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _ride = widget.initialRide;
    _setupRideStream();

    if (_ride?.status == RideStatus.searching) {
      _progressController.repeat();
    }
  }

  void _setupRideStream() {
    _rideSubscription = _rideService.rideStream.listen((ride) {
      if (ride != null && mounted) {
        setState(() {
          _ride = ride;
        });

        if (ride.status == RideStatus.driverAssigned ||
            ride.status == RideStatus.driverEnRoute) {
          _progressController.stop();
          _slideController.forward();
        }
      }
    });
  }

  Future<void> _cancelRide() async {
    setState(() {
      _isCancelling = true;
    });

    final success = await _rideService.cancelRide('User cancelled');

    if (success && mounted) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _isCancelling = false;
      });
    }
  }

  String get _statusTitle {
    switch (_ride?.status) {
      case RideStatus.searching:
        return 'Finding your ride...';
      case RideStatus.driverAssigned:
        return 'Driver assigned!';
      case RideStatus.driverEnRoute:
        return 'Driver on the way';
      case RideStatus.driverArrived:
        return 'Driver has arrived';
      default:
        return 'Processing...';
    }
  }

  String get _statusSubtitle {
    switch (_ride?.status) {
      case RideStatus.searching:
        return 'Connecting you with nearby drivers';
      case RideStatus.driverAssigned:
        return 'Your driver is heading to you';
      case RideStatus.driverEnRoute:
        return 'Arriving in ${_ride?.driver?.etaMinutes?.ceil() ?? '--'} minutes';
      case RideStatus.driverArrived:
        return 'Your driver is at the pickup location';
      default:
        return '';
    }
  }

  Color get _statusColor {
    switch (_ride?.status) {
      case RideStatus.searching:
        return AppColors.primary;
      case RideStatus.driverAssigned:
        return AppColors.success;
      case RideStatus.driverEnRoute:
        return AppColors.warning;
      case RideStatus.driverArrived:
        return AppColors.info;
      default:
        return AppColors.primary;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _progressController.dispose();
    _rideSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildContent(),
            ),
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (_ride?.status == RideStatus.searching) {
                _cancelRide();
              } else {
                Navigator.of(context).pop();
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: AppColors.textPrimary,
                size: 22,
              ),
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _statusColor,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  _ride?.status.name ?? 'searching',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _statusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_ride?.status == RideStatus.searching) {
      return _buildSearchingState();
    }

    return _buildDriverAssignedState();
  }

  Widget _buildSearchingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Transform.scale(
                    scale: 1.0 + _pulseController.value * 0.5,
                    child: Opacity(
                      opacity: 1.0 - _pulseController.value,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: 1.0 + _pulseController.value * 0.3,
                    child: Opacity(
                      opacity: 1.0 - _pulseController.value * 0.5,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppColors.buildGradient(AppColors.primaryGradient),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.local_taxi_rounded,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 40),
          Text(
            _statusTitle,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _statusSubtitle,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 40),
          SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              backgroundColor: AppColors.neutral200,
              minHeight: 4,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverAssignedState() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(height: 20),
          _buildDriverCard(),
          SizedBox(height: 24),
          _buildTripDetails(),
          SizedBox(height: 24),
          _buildEtaProgress(),
        ],
      ),
    );
  }

  Widget _buildDriverCard() {
    if (_ride?.driver == null) return SizedBox.shrink();

    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOut,
      )),
      child: FadeTransition(
        opacity: _slideController,
        child: DriverInfoTile(
          driver: _ride!.driver!,
          showEta: true,
          showPhoneAction: true,
          onPhoneTap: () {
            // Launch phone call
          },
        ),
      ),
    );
  }

  Widget _buildTripDetails() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildTripDetailRow(
            icon: Icons.location_on_rounded,
            iconColor: AppColors.primary,
            title: _ride?.pickup.shortDisplay ?? 'Pickup',
            subtitle: _ride?.pickup.address ?? '',
          ),
          Divider(height: 24, color: AppColors.divider),
          _buildTripDetailRow(
            icon: Icons.flag_rounded,
            iconColor: AppColors.destinationPin,
            title: _ride?.destination.shortDisplay ?? 'Destination',
            subtitle: _ride?.destination.address ?? '',
          ),
          Divider(height: 24, color: AppColors.divider),
          _buildTripDetailRow(
            icon: Icons.payments_rounded,
            iconColor: AppColors.success,
            title: _ride?.fareDisplay ?? '--',
            subtitle: 'Estimated fare · ${_ride?.typeDisplay ?? ''}',
          ),
        ],
      ),
    );
  }

  Widget _buildTripDetailRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 22,
          ),
        ),
        SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
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
                subtitle,
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
      ],
    );
  }

  Widget _buildEtaProgress() {
    final eta = _ride?.driver?.etaMinutes ?? 0;
    final maxEta = 15.0;
    final progress = (maxEta - eta) / maxEta;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.buildGradient(AppColors.primaryGradient),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Arriving in',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Text(
                '${eta.ceil()} min',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              backgroundColor: Colors.white.withOpacity(0.2),
              minHeight: 6,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Your driver is ${eta > 5 ? 'on the way' : 'almost there'}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong,
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_ride?.status == RideStatus.driverEnRoute ||
                _ride?.status == RideStatus.driverArrived) ...[
              _buildActionButton(
                icon: Icons.message_rounded,
                label: 'Message Driver',
                onTap: () {
                  // Open messaging
                },
              ),
              SizedBox(height: 12),
            ],
            _buildCancelButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return InkWell(
      onTap: _isCancelling ? null : _cancelRide,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.error.withOpacity(0.2)),
        ),
        child: _isCancelling
            ? Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.error),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel_rounded,
                    color: AppColors.error,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Cancel Ride',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}