import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_now_app/controllers/ride_controller.dart';
import 'package:ride_now_app/utils/colors.dart'; 
import 'package:ride_now_app/utils/constants.dart'; 
import 'package:ride_now_app/widgets/location_input.dart'; 
import 'package:ride_now_app/widgets/ride_option_card.dart'; 
import 'package:ride_now_app/widgets/recent_ride_card.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RideController(),
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatelessWidget {
  const _HomeScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<RideController>(
          builder: (context, controller, child) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _buildHeader(),
                ),
                SliverToBoxAdapter(
                  child: _buildMapPlaceholder(),
                ),
                SliverToBoxAdapter(
                  child: _buildLocationInputs(context, controller),
                ),
                SliverToBoxAdapter(
                  child: _buildRideOptions(context, controller),
                ),
                SliverToBoxAdapter(
                  child: _buildPromotionsBanner(controller),
                ),
                SliverToBoxAdapter(
                  child: _buildRecentRidesHeader(),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final ride = controller.recentRides[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingM,
                        ),
                        child: RecentRideCard(
                          id: ride.id,
                          pickupAddress: ride.pickupAddress,
                          destinationAddress: ride.destinationAddress,
                          rideType: ride.rideType,
                          fare: ride.fare,
                          dateTime: ride.dateTime,
                          driverName: ride.driverName,
                          driverImage: ride.driverImage,
                          onTap: () {
                            // Navigate to ride details
                          },
                          onRepeat: () {
                            controller.repeatRide(ride);
                          },
                        ),
                      );
                    },
                    childCount: controller.recentRides.length,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppConstants.spacingXXL),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good ${_getGreeting()}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Where to?',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radiusL),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(26),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textSecondary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingM),
      decoration: BoxDecoration(
        color: AppColors.mapBackground,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(26),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        child: Stack(
          children: [
            // Map placeholder with grid pattern
            CustomPaint(
              painter: _MapGridPainter(),
              size: const Size(double.infinity, 200),
            ),
            // Current location button
            Positioned(
              right: AppConstants.spacingM,
              bottom: AppConstants.spacingM,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(51),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.my_location,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
            ),
            // Center marker
            Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(230),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(102),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInputs(BuildContext context, RideController controller) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: LocationInput(
                  type: LocationInputType.pickup,
                  controller: _pickupController,
                  hintText: 'Pickup location',
                  initialValue: controller.pickupLocation?.address,
                  onTap: () {
                    _showLocationSearch(context, isPickup: true);
                  },
                  onChanged: (value) {
                    // Handle input change
                  },
                  onClear: () {
                    controller.clearPickupLocation();
                    _pickupController.clear();
                  },
                ),
              ),
              const SizedBox(width: AppConstants.spacingS),
              GestureDetector(
                onTap: controller.hasLocationsSet
                    ? () => controller.swapLocations()
                    : null,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: controller.hasLocationsSet
                        ? AppColors.primary
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    border: Border.all(
                      color: controller.hasLocationsSet
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                  ),
                  child: Icon(
                    Icons.swap_vert,
                    color: controller.hasLocationsSet
                        ? Colors.white
                        : AppColors.textTertiary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingS),
          LocationInput(
            type: LocationInputType.destination,
            controller: _destinationController,
            hintText: 'Where to?',
            initialValue: controller.destinationLocation?.address,
            onTap: () {
              _showLocationSearch(context, isPickup: false);
            },
            onChanged: (value) {
              // Handle input change
            },
            onClear: () {
              controller.clearDestinationLocation();
              _destinationController.clear();
            },
          ),
          if (controller.hasLocationsSet) ...[
            const SizedBox(height: AppConstants.spacingM),
            _buildFareEstimate(controller),
          ],
        ],
      ),
    );
  }

  Widget _buildFareEstimate(RideController controller) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: const Icon(
              Icons.analytics_outlined,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: AppConstants.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estimated ${controller.formattedDistance} • ${controller.formattedDuration}',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Fare: \$${controller.estimatedFare.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingM,
              vertical: AppConstants.spacingS,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: Text(
              'Request',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRideOptions(BuildContext context, RideController controller) {
    if (!controller.hasPickupSet) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingM),
          child: Text(
            'Select Ride',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: AppConstants.spacingM),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingM),
            itemCount: controller.availableRideTypes.length,
            itemBuilder: (context, index) {
              final rideType = controller.availableRideTypes[index];
              final isSelected = controller.selectedRideType?.id == rideType.id;
              return Padding(
                padding: EdgeInsets.only(
                  right: index < controller.availableRideTypes.length - 1
                      ? AppConstants.spacingS
                      : 0,
                ),
                child: SizedBox(
                  width: 160,
                  child: RideOptionCard(
                    id: rideType.id,
                    name: rideType.name,
                    description: rideType.description,
                    icon: _getIconForRideType(rideType.icon),
                    baseFare: rideType.baseFare,
                    estimatedFare: controller.hasLocationsSet
                        ? rideType.calculateFare(
                            controller.estimatedDistance,
                            controller.estimatedDurationMinutes,
                          )
                        : null,
                    capacity: rideType.capacity,
                    color: Color(rideType.color),
                    isSelected: isSelected,
                    onTap: () => controller.selectRideType(rideType),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getIconForRideType(String iconName) {
    switch (iconName) {
      case 'directions_car':
        return Icons.directions_car;
      case 'airline_seat_recline_extra':
        return Icons.airline_seat_recline_extra;
      case 'star':
        return Icons.star;
      case 'diamond':
        return Icons.diamond;
      default:
        return Icons.directions_car;
    }
  }

  Widget _buildPromotionsBanner(RideController controller) {
    if (controller.promotions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppConstants.spacingL),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingM),
          child: Text(
            'Promotions',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: AppConstants.spacingM),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingM),
            itemCount: controller.promotions.length,
            itemBuilder: (context, index) {
              final promo = controller.promotions[index];
              return Container(
                width: 280,
                margin: EdgeInsets.only(
                  right: index < controller.promotions.length - 1
                      ? AppConstants.spacingS
                      : 0,
                ),
                padding: const EdgeInsets.all(AppConstants.spacingM),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(77),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51),
                        borderRadius: BorderRadius.circular(AppConstants.radiusM),
                      ),
                      child: const Icon(
                        Icons.local_offer,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            promo.title,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            promo.subtitle,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withAlpha(204),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Code: ${promo.code}',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withAlpha(179),
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentRidesHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppConstants.spacingL,
        bottom: AppConstants.spacingM,
        left: AppConstants.spacingM,
        right: AppConstants.spacingM,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Recent Rides',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          TextButton(
            onPressed: () {
              // View all recent rides
            },
            child: Text(
              'See all',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLocationSearch(BuildContext context, {required bool isPickup}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LocationSearchSheet(
        isPickup: isPickup,
        onLocationSelected: (address) {
          final controller = context.read<RideController>();
          final location = LocationInputData(
            address: address,
            latitude: 40.7128,
            longitude: -74.0060,
          );
          if (isPickup) {
            controller.setPickupLocation(location);
            _pickupController.text = address;
          } else {
            controller.setDestinationLocation(location);
            _destinationController.text = address;
          }
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _LocationSearchSheet extends StatefulWidget {
  final bool isPickup;
  final Function(String) onLocationSelected;

  const _LocationSearchSheet({
    required this.isPickup,
    required this.onLocationSelected,
  });

  @override
  State<_LocationSearchSheet> createState() => _LocationSearchSheetState();
}

class _LocationSearchSheetState extends State<_LocationSearchSheet> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _suggestions = [
    '123 Main Street, Downtown',
    '456 Oak Avenue, Midtown',
    '789 Pine Road, Uptown',
    'Airport Terminal 4',
    'Times Square, Manhattan',
    'Central Park, New York',
    'Grand Central Station',
    'Penn Station, Manhattan',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusXL),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: AppConstants.spacingS),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isPickup ? 'Pickup Location' : 'Destination',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingM),
                TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search for a location...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textTertiary,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.textTertiary,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingM,
              ),
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = _suggestions[index];
                return ListTile(
                  onTap: () {
                    widget.onLocationSelected(suggestion);
                  },
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.isPickup
                          ? AppColors.primary.withAlpha(26)
                          : AppColors.accent.withAlpha(26),
                      borderRadius: BorderRadius.circular(AppConstants.radiusS),
                    ),
                    child: Icon(
                      widget.isPickup
                          ? Icons.trip_origin
                          : Icons.location_on_outlined,
                      color: widget.isPickup
                          ? AppColors.primary
                          : AppColors.accent,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    suggestion,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingS,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.mapOverlay
      ..strokeWidth = 0.5;

    const spacing = 30.0;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}