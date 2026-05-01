import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:new_project_app/utils/colors.dart'; 
import 'package:new_project_app/providers/ride_provider.dart';
import 'package:new_project_app/providers/auth_provider.dart';
import 'package:new_project_app/widgets/ride_state_chip.dart'; 

class RiderVehicleSelectScreen extends StatefulWidget {
  const RiderVehicleSelectScreen({Key? key}) : super(key: key);

  @override
  State<RiderVehicleSelectScreen> createState() =>
      _RiderVehicleSelectScreenState();
}

class _RiderVehicleSelectScreenState extends State<RiderVehicleSelectScreen>
    with TickerProviderStateMixin {
  late AnimationController _confirmButtonController;
  late AnimationController _fareController;
  late AnimationController _headerController;
  late Animation<double> _confirmScaleAnim;
  late Animation<double> _confirmGlowAnim;
  late Animation<double> _fareSlideAnim;
  late Animation<double> _headerSlideAnim;
  late Animation<double> _headerFadeAnim;

  bool _isBooking = false;
  int _selectedIndex = 0;
  PageController _pageController = PageController(viewportFraction: 0.82);

  @override
  void initState() {
    super.initState();

    _confirmButtonController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1600),
    );

    _fareController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );

    _headerController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _confirmScaleAnim = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(
        parent: _confirmButtonController,
        curve: Curves.easeInOut,
      ),
    );

    _confirmGlowAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _confirmButtonController,
        curve: Curves.easeInOut,
      ),
    );

    _fareSlideAnim = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fareController,
        curve: Curves.easeOutCubic,
      ),
    );

    _headerSlideAnim = Tween<double>(begin: -30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: Curves.easeOutCubic,
      ),
    );

    _headerFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: Curves.easeOut,
      ),
    );

    _confirmButtonController.repeat(reverse: true);
    _headerController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVehicles();
    });
  }

  Future<void> _loadVehicles() async {
    final rideProvider = Provider.of<RideProvider>(context, listen: false);
    await rideProvider.loadVehicleOptions();
    if (mounted) {
      _fareController.forward();
    }
  }

  @override
  void dispose() {
    _confirmButtonController.dispose();
    _fareController.dispose();
    _headerController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onConfirmBooking() async {
    if (_isBooking) return;
    setState(() => _isBooking = true);

    final rideProvider = Provider.of<RideProvider>(context, listen: false);
    await rideProvider.confirmBooking();

    if (mounted) {
      setState(() => _isBooking = false);
      Navigator.pushNamed(context, '/rider_tracking');
    }
  }

  void _onVehicleSelected(int index, RideProvider rideProvider) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);

    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );

    _fareController.reset();
    rideProvider.selectVehicle(rideProvider.availableVehicles[index]);
    _fareController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<RideProvider, AuthProvider>(
      builder: (context, rideProvider, authProvider, _) {
        final vehicles = rideProvider.availableVehicles;
        final fareEstimate = rideProvider.fareEstimate;
        final selectedVehicle = rideProvider.selectedVehicle;
        final isReady = rideProvider.isReadyToBook;

        return Scaffold(
          backgroundColor: AppColors.offWhite,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(rideProvider),
                _buildRouteInfo(rideProvider),
                SizedBox(height: 16),
                _buildVehicleSelector(vehicles, rideProvider),
                SizedBox(height: 8),
                _buildVehicleTabRow(vehicles, rideProvider),
                SizedBox(height: 16),
                _buildFareEstimateCard(fareEstimate, selectedVehicle, rideProvider),
                Spacer(),
                _buildPaymentRow(authProvider, rideProvider),
                SizedBox(height: 12),
                _buildConfirmButton(isReady, selectedVehicle, fareEstimate),
                SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(RideProvider rideProvider) {
    return AnimatedBuilder(
      animation: _headerController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _headerSlideAnim.value),
          child: Opacity(
            opacity: _headerFadeAnim.value,
            child: child,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowNeutral,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.borderLight,
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.grey800,
                  size: 18,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose Your Ride',
                    style: TextStyle(
                      color: AppColors.grey900,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Select a vehicle type for your trip',
                    style: TextStyle(
                      color: AppColors.grey500,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            RideStateChip(
              state: RideState.idle,
              compact: true,
              animated: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteInfo(RideProvider rideProvider) {
    final pickup = rideProvider.pickupPlace?.primaryText ?? 'Select pickup';
    final dropoff = rideProvider.dropoffPlace?.primaryText ?? 'Select destination';

    return Container(
      margin: EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowNeutral,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _RoutePoint(
            icon: Icons.radio_button_checked_rounded,
            iconColor: AppColors.mapPickup,
            label: 'From',
            address: pickup,
          ),
          Padding(
            padding: EdgeInsets.only(left: 11),
            child: Row(
              children: [
                Container(
                  width: 2,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
          _RoutePoint(
            icon: Icons.location_on_rounded,
            iconColor: AppColors.mapDropoff,
            label: 'To',
            address: dropoff,
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleSelector(
      List<VehicleOption> vehicles, RideProvider rideProvider) {
    if (vehicles.isEmpty) {
      return Container(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      );
    }

    return SizedBox(
      height: 210,
      child: PageView.builder(
        controller: _pageController,
        itemCount: vehicles.length,
        onPageChanged: (index) {
          _onVehicleSelected(index, rideProvider);
        },
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          final isSelected = index == _selectedIndex;
          return GestureDetector(
            onTap: () => _onVehicleSelected(index, rideProvider),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              margin: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: isSelected ? 0 : 12,
              ),
              child: _VehicleCard(
                vehicle: vehicle,
                isSelected: isSelected,
                fareEstimate: isSelected ? rideProvider.fareEstimate : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVehicleTabRow(
      List<VehicleOption> vehicles, RideProvider rideProvider) {
    if (vehicles.isEmpty) return SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(vehicles.length, (index) {
        final isSelected = index == _selectedIndex;
        final vehicle = vehicles[index];
        return GestureDetector(
          onTap: () => _onVehicleSelected(index, rideProvider),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 4),
            padding: EdgeInsets.symmetric(
              horizontal: isSelected ? 16 : 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: isSelected ? vehicle.accentColor : AppColors.grey200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  Icon(
                    _vehicleIcon(vehicle.type),
                    color: AppColors.white,
                    size: 14,
                  ),
                  SizedBox(width: 4),
                ],
                Text(
                  vehicle.label,
                  style: TextStyle(
                    color: isSelected ? AppColors.white : AppColors.grey500,
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFareEstimateCard(
    FareEstimate? fareEstimate,
    VehicleOption? selectedVehicle,
    RideProvider rideProvider,
  ) {
    return AnimatedBuilder(
      animation: _fareController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _fareSlideAnim.value),
          child: Opacity(
            opacity: _fareController.value,
            child: child,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowPrimary,
              blurRadius: 20,
              offset: Offset(0, 8),
              spreadRadius: -2,
            ),
          ],
        ),
        child: fareEstimate == null
            ? _FareLoadingState()
            : _FareEstimateContent(
                fareEstimate: fareEstimate,
                selectedVehicle: selectedVehicle,
                rideProvider: rideProvider,
              ),
      ),
    );
  }

  Widget _buildPaymentRow(
      AuthProvider authProvider, RideProvider rideProvider) {
    final method = rideProvider.selectedPaymentMethod;
    final walletBalance = authProvider.walletBalance;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: AppColors.walletGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              method == PaymentMethod.wallet
                  ? Icons.account_balance_wallet_rounded
                  : Icons.credit_card_rounded,
              color: AppColors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method == PaymentMethod.wallet ? 'Wallet' : 'Credit Card',
                  style: TextStyle(
                    color: AppColors.grey800,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  method == PaymentMethod.wallet
                      ? 'Balance: \$${walletBalance.toStringAsFixed(2)}'
                      : 'Tap to change payment method',
                  style: TextStyle(
                    color: AppColors.grey500,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              rideProvider.setPaymentMethod(
                method == PaymentMethod.wallet
                    ? PaymentMethod.card
                    : PaymentMethod.wallet,
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Change',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(
    bool isReady,
    VehicleOption? selectedVehicle,
    FareEstimate? fareEstimate,
  ) {
    final fareText = fareEstimate != null
        ? fareEstimate.displayRange
        : selectedVehicle != null
            ? '\$${selectedVehicle.baseFare.toStringAsFixed(2)}'
            : 'Estimating...';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedBuilder(
        animation: _confirmButtonController,
        builder: (context, child) {
          return Transform.scale(
            scale: isReady && !_isBooking ? _confirmScaleAnim.value : 1.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: isReady
                    ? [
                        BoxShadow(
                          color: AppColors.shadowPrimary.withOpacity(
                            0.3 + _confirmGlowAnim.value * 0.3,
                          ),
                          blurRadius: 20 + _confirmGlowAnim.value * 12,
                          offset: Offset(0, 6),
                          spreadRadius: _confirmGlowAnim.value * 2,
                        ),
                      ]
                    : [],
              ),
              child: ElevatedButton(
                onPressed: isReady && !_isBooking ? _onConfirmBooking : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  disabledBackgroundColor: AppColors.grey300,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: Size(double.infinity, 58),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: isReady
                        ? AppColors.primaryGradient
                        : LinearGradient(
                            colors: [AppColors.grey300, AppColors.grey300],
                          ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 58,
                    alignment: Alignment.center,
                    child: _isBooking
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                  strokeWidth: 2.5,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Finding your driver...',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bolt_rounded,
                                color: isReady
                                    ? AppColors.white
                                    : AppColors.grey500,
                                size: 22,
                              ),
                              SizedBox(width: 8),
                              Text(
                                isReady
                                    ? 'Confirm Booking — $fareText'
                                    : 'Select pickup & destination',
                                style: TextStyle(
                                  color: isReady
                                      ? AppColors.white
                                      : AppColors.grey500,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _vehicleIcon(VehicleType type) {
    switch (type) {
      case VehicleType.economy:
        return Icons.directions_car_rounded;
      case VehicleType.luxury:
        return Icons.star_rounded;
      case VehicleType.xl:
        return Icons.airport_shuttle_rounded;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _VehicleCard
// ─────────────────────────────────────────────────────────────────────────────

class _VehicleCard extends StatelessWidget {
  final VehicleOption vehicle;
  final bool isSelected;
  final FareEstimate? fareEstimate;

  const _VehicleCard({
    Key? key,
    required this.vehicle,
    required this.isSelected,
    this.fareEstimate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color accent = vehicle.accentColor;

    return AnimatedContainer(
      duration: Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.white : AppColors.grey100,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? accent : AppColors.borderLight,
          width: isSelected ? 2.5 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: accent.withOpacity(0.18),
                  blurRadius: 24,
                  offset: Offset(0, 8),
                  spreadRadius: -2,
                ),
                BoxShadow(
                  color: AppColors.shadowNeutral,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: AppColors.shadowNeutral,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: isSelected
                      ? accent.withOpacity(0.12)
                      : AppColors.grey200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _vehicleIcon(vehicle.type),
                  color: isSelected ? accent : AppColors.grey500,
                  size: 30,
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          vehicle.label,
                          style: TextStyle(
                            color: isSelected ? AppColors.grey900 : AppColors.grey700,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(width: 8),
                        if (isSelected)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: accent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Selected',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 3),
                    Text(
                      vehicle.description,
                      style: TextStyle(
                        color: AppColors.grey500,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _InfoPill(
                icon: Icons.access_time_rounded,
                label: '${vehicle.eta} min',
                color: accent,
                isActive: isSelected,
              ),
              SizedBox(width: 8),
              _InfoPill(
                icon: Icons.people_rounded,
                label: '${vehicle.capacity} seats',
                color: accent,
                isActive: isSelected,
              ),
              Spacer(),
              Text(
                fareEstimate != null
                    ? fareEstimate!.displayRange
                    : '\$${vehicle.baseFare.toStringAsFixed(2)}+',
                style: TextStyle(
                  color: isSelected ? accent : AppColors.grey600,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _vehicleIcon(VehicleType type) {
    switch (type) {
      case VehicleType.economy:
        return Icons.directions_car_filled_rounded;
      case VehicleType.luxury:
        return Icons.directions_car_rounded;
      case VehicleType.xl:
        return Icons.airport_shuttle_rounded;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _InfoPill
// ─────────────────────────────────────────────────────────────────────────────

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isActive;

  const _InfoPill({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.1) : AppColors.grey200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: isActive ? color : AppColors.grey500,
          ),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? color : AppColors.grey500,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _RoutePoint
// ─────────────────────────────────────────────────────────────────────────────

class _RoutePoint extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String address;

  const _RoutePoint({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 22),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.grey500,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 2),
              Text(
                address,
                style: TextStyle(
                  color: AppColors.grey800,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
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
}

// ─────────────────────────────────────────────────────────────────────────────
// _FareEstimateContent
// ─────────────────────────────────────────────────────────────────────────────

class _FareEstimateContent extends StatelessWidget {
  final FareEstimate fareEstimate;
  final VehicleOption? selectedVehicle;
  final RideProvider rideProvider;

  const _FareEstimateContent({
    Key? key,
    required this.fareEstimate,
    required this.selectedVehicle,
    required this.rideProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.receipt_long_rounded,
              color: AppColors.white.withOpacity(0.85),
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              'Fare Estimate',
              style: TextStyle(
                color: AppColors.white.withOpacity(0.85),
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            Spacer(),
            if (fareEstimate.isSurge)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.warning.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.bolt_rounded,
                      color: AppColors.warningLight,
                      size: 13,
                    ),
                    SizedBox(width: 3),
                    Text(
                      '${fareEstimate.surgeMultiplier.toStringAsFixed(1)}x Surge',
                      style: TextStyle(
                        color: AppColors.warningLight,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              fareEstimate.displayRange,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(width: 8),
            Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text(
                'est.',
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.65),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 14),
        Row(
          children: [
            _FareStat(
              icon: Icons.route_rounded,
              label: rideProvider.formatDistance(fareEstimate.distance),
              sublabel: 'Distance',
            ),
            _VerticalDivider(),
            _FareStat(
              icon: Icons.timer_rounded,
              label: rideProvider.formatEta(fareEstimate.duration),
              sublabel: 'Duration',
            ),
            _VerticalDivider(),
            _FareStat(
              icon: Icons.people_rounded,
              label: selectedVehicle != null
                  ? '${selectedVehicle!.capacity} seats'
                  : '4 seats',
              sublabel: 'Capacity',
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _FareStat
// ─────────────────────────────────────────────────────────────────────────────

class _FareStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;

  const _FareStat({
    Key? key,
    required this.icon,
    required this.label,
    required this.sublabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColors.white.withOpacity(0.75),
            size: 16,
          ),
          SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                sublabel,
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.6),
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _VerticalDivider
// ─────────────────────────────────────────────────────────────────────────────

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: AppColors.white.withOpacity(0.2),
      margin: EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _FareLoadingState
// ─────────────────────────────────────────────────────────────────────────────

class _FareLoadingState extends StatelessWidget {
  const _FareLoadingState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                color: AppColors.white.withOpacity(0.7),
                strokeWidth: 2,
              ),
            ),
            SizedBox(width: 10),
            Text(
              'Calculating fare...',
              style: TextStyle(
                color: AppColors.white.withOpacity(0.85),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 14),
        Container(
          width: 160,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        SizedBox(height: 12),
        Container(
          width: 240,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ],
    );
  }
}