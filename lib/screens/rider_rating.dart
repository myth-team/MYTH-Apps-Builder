import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:new_project_app/utils/colors.dart'; 
import 'package:new_project_app/providers/ride_provider.dart';
import 'package:new_project_app/widgets/ride_state_chip.dart'; 

class RiderRatingScreen extends StatefulWidget {
  const RiderRatingScreen({Key? key}) : super(key: key);

  @override
  State<RiderRatingScreen> createState() => _RiderRatingScreenState();
}

class _RiderRatingScreenState extends State<RiderRatingScreen>
    with TickerProviderStateMixin {
  int _selectedStars = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;
  bool _submitted = false;
  late AnimationController _successController;
  late Animation<double> _successScale;
  late AnimationController _starsController;
  late List<Animation<double>> _starAnimations;

  final List<String> _quickTags = [
    'Great driving',
    'Very polite',
    'On time',
    'Clean car',
    'Safe ride',
    'Good music',
  ];
  final Set<String> _selectedTags = {};

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _successScale = CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    );

    _starsController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _starAnimations = List.generate(5, (i) {
      return Tween<double>(begin: 1.0, end: 1.4).animate(
        CurvedAnimation(
          parent: _starsController,
          curve: Interval(
            i * 0.1,
            0.5 + i * 0.1,
            curve: Curves.elasticOut,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _successController.dispose();
    _starsController.dispose();
    super.dispose();
  }

  void _selectStar(int star) {
    setState(() => _selectedStars = star);
    _starsController.forward(from: 0);
  }

  Future<void> _submitRating() async {
    if (_selectedStars == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a star rating before submitting.',
            style: GoogleFonts.poppins(color: AppColors.white),
          ),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final rideProvider = context.read<RideProvider>();
    await rideProvider.submitRating(
      stars: _selectedStars,
      comment: _commentController.text.isNotEmpty
          ? _commentController.text
          : null,
    );

    setState(() {
      _isSubmitting = false;
      _submitted = true;
    });

    _successController.forward();

    await Future.delayed(Duration(milliseconds: 1800));
    if (mounted) {
      rideProvider.resetToIdle();
      Navigator.of(context)
          .popUntil((route) => route.settings.name == '/rider_home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final rideProvider = context.watch<RideProvider>();
    final trip =
        rideProvider.tripHistory.isNotEmpty ? rideProvider.tripHistory.first : null;

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: _submitted ? _buildSuccessView() : _buildRatingView(trip),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: ScaleTransition(
        scale: _successScale,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                gradient: AppColors.tealGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.tertiary.withOpacity(0.4),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(Icons.check_rounded, color: AppColors.white, size: 56),
            ),
            SizedBox(height: 24),
            Text(
              'Thanks for your feedback!',
              style: GoogleFonts.poppins(
                color: AppColors.grey900,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your rating helps improve the experience for everyone.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.grey500,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _selectedStars,
                (_) => Icon(Icons.star_rounded,
                    color: AppColors.starActive, size: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingView(TripRecord? trip) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeader()),
        if (trip != null)
          SliverToBoxAdapter(child: _buildTripSummaryCard(trip)),
        SliverToBoxAdapter(child: _buildDriverCard(trip)),
        SliverToBoxAdapter(child: _buildStarRating()),
        SliverToBoxAdapter(child: _buildQuickTags()),
        SliverToBoxAdapter(child: _buildCommentField()),
        SliverToBoxAdapter(child: _buildSubmitButton()),
        SliverToBoxAdapter(child: _buildSkipButton()),
        SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rate Your Ride',
                  style: GoogleFonts.poppins(
                    color: AppColors.grey900,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'How was your trip experience?',
                  style: GoogleFonts.poppins(
                    color: AppColors.grey500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.star_outline_rounded,
                color: AppColors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildTripSummaryCard(TripRecord trip) {
    final dateStr =
        DateFormat('MMM d, h:mm a').format(trip.dateTime);

    return Container(
      margin: EdgeInsets.fromLTRB(16, 4, 16, 12),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowNeutral,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trip Summary',
                style: GoogleFonts.poppins(
                  color: AppColors.grey800,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              RideStateChip(
                state: RideState.completed,
                compact: true,
                animated: false,
              ),
            ],
          ),
          SizedBox(height: 14),
          _buildTripRouteRow(trip),
          SizedBox(height: 14),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryDetail(
                    Icons.calendar_today_rounded, dateStr, 'Date'),
                _buildSummaryDivider(),
                _buildSummaryDetail(Icons.directions_car_rounded,
                    trip.vehicleType.name.toUpperCase(), 'Vehicle'),
                _buildSummaryDivider(),
                _buildSummaryDetail(
                  trip.paymentMethod == PaymentMethod.wallet
                      ? Icons.account_balance_wallet_rounded
                      : Icons.credit_card_rounded,
                  trip.paymentMethod == PaymentMethod.wallet
                      ? 'Wallet'
                      : 'Card',
                  'Payment',
                ),
                _buildSummaryDivider(),
                _buildSummaryDetail(
                  Icons.attach_money_rounded,
                  '\$${trip.fare.toStringAsFixed(2)}',
                  'Fare',
                  valueColor: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripRouteRow(TripRecord trip) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.mapPickup,
              ),
            ),
            Container(
              width: 2,
              height: 28,
              color: AppColors.grey300,
            ),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.mapDropoff,
              ),
            ),
          ],
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trip.pickupAddress,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: AppColors.grey700,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 16),
              Text(
                trip.dropoffAddress,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: AppColors.grey900,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryDetail(IconData icon, String value, String label,
      {Color? valueColor}) {
    return Column(
      children: [
        Icon(icon, color: AppColors.grey500, size: 16),
        SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: valueColor ?? AppColors.grey800,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColors.grey400,
            fontSize: 9,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryDivider() {
    return Container(
      height: 36,
      width: 1,
      color: AppColors.borderLight,
    );
  }

  Widget _buildDriverCard(TripRecord? trip) {
    if (trip?.driver == null) return SizedBox.shrink();
    final driver = trip!.driver!;

    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowNeutral,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.network(
                  driver.avatarUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 60,
                    height: 60,
                    color: AppColors.primarySurface,
                    child: Icon(Icons.person_rounded,
                        color: AppColors.primary, size: 30),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.success,
                    border:
                        Border.all(color: AppColors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driver.name,
                  style: GoogleFonts.poppins(
                    color: AppColors.grey900,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  '${driver.vehicleModel} • ${driver.vehiclePlate}',
                  style: GoogleFonts.poppins(
                    color: AppColors.grey500,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.star_rounded,
                        color: AppColors.starActive, size: 14),
                    SizedBox(width: 3),
                    Text(
                      '${driver.rating.toStringAsFixed(1)}',
                      style: GoogleFonts.poppins(
                        color: AppColors.grey700,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${driver.totalTrips} trips',
                      style: GoogleFonts.poppins(
                        color: AppColors.grey400,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating() {
    final List<String> labels = ['Terrible', 'Bad', 'Okay', 'Good', 'Amazing'];
    final String label = _selectedStars > 0 ? labels[_selectedStars - 1] : '';

    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowNeutral,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'How would you rate your driver?',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColors.grey800,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starNum = index + 1;
              final isSelected = _selectedStars >= starNum;

              return GestureDetector(
                onTap: () => _selectStar(starNum),
                child: AnimatedBuilder(
                  animation: _starsController,
                  builder: (context, child) {
                    final scale = isSelected
                        ? _starAnimations[index].value
                        : 1.0;
                    return Transform.scale(
                      scale: scale,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          isSelected
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: isSelected
                              ? AppColors.starActive
                              : AppColors.starInactive,
                          size: 44,
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _selectedStars > 0
                ? Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text(
                      label,
                      key: ValueKey(_selectedStars),
                      style: GoogleFonts.poppins(
                        color: _selectedStars >= 4
                            ? AppColors.success
                            : _selectedStars == 3
                                ? AppColors.warning
                                : AppColors.error,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                : SizedBox(height: 12, key: ValueKey(0)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTags() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowNeutral,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What went well? (optional)',
            style: GoogleFonts.poppins(
              color: AppColors.grey700,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickTags.map((tag) {
              final isSelected = _selectedTags.contains(tag);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedTags.remove(tag);
                    } else {
                      _selectedTags.add(tag);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding:
                      EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primarySurface
                        : AppColors.grey100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.borderLight,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Text(
                    tag,
                    style: GoogleFonts.poppins(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.grey600,
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
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

  Widget _buildCommentField() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 20),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowNeutral,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Leave a comment (optional)',
            style: GoogleFonts.poppins(
              color: AppColors.grey700,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          TextField(
            controller: _commentController,
            maxLines: 3,
            maxLength: 200,
            style: GoogleFonts.poppins(
              color: AppColors.grey900,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText:
                  'Tell us more about your experience...',
              hintStyle: GoogleFonts.poppins(
                color: AppColors.grey400,
                fontSize: 13,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: AppColors.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: AppColors.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    BorderSide(color: AppColors.primary, width: 1.5),
              ),
              filled: true,
              fillColor: AppColors.grey100,
              counterStyle: GoogleFonts.poppins(
                color: AppColors.grey400,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: _isSubmitting ? null : _submitRating,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            gradient:
                _selectedStars > 0 ? AppColors.primaryGradient : null,
            color:
                _selectedStars == 0 ? AppColors.grey200 : null,
            borderRadius: BorderRadius.circular(18),
            boxShadow: _selectedStars > 0
                ? [
                    BoxShadow(
                      color: AppColors.shadowPrimary,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: _isSubmitting
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.send_rounded,
                        color: _selectedStars > 0
                            ? AppColors.white
                            : AppColors.grey400,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Submit Rating',
                        style: GoogleFonts.poppins(
                          color: _selectedStars > 0
                              ? AppColors.white
                              : AppColors.grey400,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: GestureDetector(
        onTap: () {
          context.read<RideProvider>().resetToIdle();
          Navigator.of(context)
              .popUntil((route) => route.settings.name == '/rider_home');
        },
        child: Center(
          child: Text(
            'Skip for now',
            style: GoogleFonts.poppins(
              color: AppColors.grey500,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.grey400,
            ),
          ),
        ),
      ),
    );
  }
}