import 'package:flutter/material.dart';
import 'package:ridesync_app/utils/colors.dart'; 
import 'package:ridesync_app/widgets/vehicle_card.dart'; 
import 'package:ridesync_app/widgets/primary_button.dart'; 
import 'package:google_fonts/google_fonts.dart';

class RiderSelectVehicleScreen extends StatefulWidget {
  final String pickupLocation;
  final String dropoffLocation;
  final double distance;
  final int durationMinutes;
  final Function(VehicleType) onVehicleSelected;
  final VoidCallback onCancel;

  const RiderSelectVehicleScreen({
    super.key,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.distance,
    required this.durationMinutes,
    required this.onVehicleSelected,
    required this.onCancel,
  });

  @override
  State<RiderSelectVehicleScreen> createState() => _RiderSelectVehicleScreenState();
}

class _RiderSelectVehicleScreenState extends State<RiderSelectVehicleScreen> {
  VehicleType? _selectedVehicle;
  bool _showFareBreakdown = false;

  final Map<VehicleType, double> _prices = {
    VehicleType.economy: 12.50,
    VehicleType.comfort: 18.00,
    VehicleType.luxury: 35.00,
    VehicleType.xl: 22.00,
  };

  final Map<VehicleType, double> _originalPrices = {
    VehicleType.economy: 15.00,
    VehicleType.comfort: 22.00,
    VehicleType.luxury: 45.00,
    VehicleType.xl: 28.00,
  };

  final Map<VehicleType, String> _etas = {
    VehicleType.economy: '2 min',
    VehicleType.comfort: '4 min',
    VehicleType.luxury: '8 min',
    VehicleType.xl: '5 min',
  };

  final Map<VehicleType, double> _multipliers = {
    VehicleType.economy: 1.0,
    VehicleType.comfort: 1.4,
    VehicleType.luxury: 2.8,
    VehicleType.xl: 1.8,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildRouteSummary(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildVehicleList(),
                    if (_selectedVehicle != null) ...[
                      _buildFareBreakdown(),
                      _buildConfirmButton(),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withAlpha(51),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: widget.onCancel,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Select Vehicle',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              if (_selectedVehicle != null)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showFareBreakdown = !_showFareBreakdown;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withAlpha(26),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Fare details',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTimeEstimate(),
        ],
      ),
    );
  }

  Widget _buildTimeEstimate() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTimeEstimateItem(
            icon: Icons.access_time,
            label: 'Pickup in',
            value: '2 min',
            color: AppColors.success,
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.borderLight,
          ),
          _buildTimeEstimateItem(
            icon: Icons.directions_car,
            label: 'Drive time',
            value: '${widget.durationMinutes} min',
            color: AppColors.secondary,
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.borderLight,
          ),
          _buildTimeEstimateItem(
            icon: Icons.straighten,
            label: 'Distance',
            value: '${widget.distance.toStringAsFixed(1)} km',
            color: AppColors.accent,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeEstimateItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildRouteSummary() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withAlpha(51),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pickup',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      widget.pickupLocation,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 5),
            width: 2,
            height: 24,
            color: AppColors.grey300,
          ),
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dropoff',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      widget.dropoffLocation,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleList() {
    return Column(
      children: VehicleType.values.map((type) {
        final price = _prices[type] ?? 0.0;
        final originalPrice = _originalPrices[type];
        final eta = _etas[type] ?? '';
        
        return VehicleCard(
          type: type,
          price: price,
          originalPrice: originalPrice,
          eta: eta,
          distance: widget.distance * (_multipliers[type] ?? 1.0),
          isSelected: _selectedVehicle == type,
          isAvailable: true,
          onTap: () {
            setState(() {
              _selectedVehicle = type;
              _showFareBreakdown = true;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildFareBreakdown() {
    if (!_showFareBreakdown || _selectedVehicle == null) {
      return const SizedBox.shrink();
    }

    final baseFare = 3.00;
    final distanceFare = widget.distance * 1.50;
    final timeFare = widget.durationMinutes * 0.30;
    const serviceFee = 1.50;
    const discount = 2.00;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: FareBreakdownSummary(
        baseFare: baseFare,
        distanceFare: distanceFare,
        timeFare: timeFare,
        serviceFee: serviceFee,
        discount: discount,
        promoCode: 'RIDE20',
      ),
    );
  }

  Widget _buildConfirmButton() {
    if (_selectedVehicle == null) {
      return const SizedBox.shrink();
    }

    final price = _prices[_selectedVehicle] ?? 0.0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildPriceComparison(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            text: 'Confirm Ride - \$${price.toStringAsFixed(2)}',
            onPressed: () {
              widget.onVehicleSelected(_selectedVehicle!);
            },
            icon: Icons.check_circle,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceComparison() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price comparison',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: VehicleType.values.map((type) {
              final price = _prices[type] ?? 0.0;
              final isSelected = _selectedVehicle == type;
              
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedVehicle = type;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary.withAlpha(26) : AppColors.grey50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _getVehicleIcon(type),
                          size: 20,
                          color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${price.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? AppColors.primary : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  IconData _getVehicleIcon(VehicleType type) {
    switch (type) {
      case VehicleType.economy:
        return Icons.directions_car;
      case VehicleType.comfort:
        return Icons.airport_shuttle;
      case VehicleType.luxury:
        return Icons.diamond;
      case VehicleType.xl:
        return Icons.people;
    }
  }
}