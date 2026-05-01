import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ridenow_go_app/models/driver.dart'; 
import 'package:ridenow_go_app/models/ride.dart'; 
import 'package:ridenow_go_app/services/ride_service.dart'; 
import 'package:ridenow_go_app/utils/colors.dart'; 
import 'package:ridenow_go_app/widgets/driver_info_tile.dart'; 

class DriverRatingScreen extends StatefulWidget {
  final Ride? ride;

  DriverRatingScreen({this.ride});

  @override
  _DriverRatingScreenState createState() => _DriverRatingScreenState();
}

class _DriverRatingScreenState extends State<DriverRatingScreen>
    with SingleTickerProviderStateMixin {
  final RideService _rideService = RideService.instance;

  Ride? _ride;
  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  final List<String> _selectedFeedback = [];
  double? _tipAmount;
  bool _isSubmitting = false;

  late AnimationController _sheetController;

  final List<Map<String, dynamic>> _feedbackOptions = [
    {'label': 'Clean vehicle', 'icon': Icons.cleaning_services_rounded},
    {'label': 'Great conversation', 'icon': Icons.chat_bubble_outline_rounded},
    {'label': 'Expert navigation', 'icon': Icons.navigation_rounded},
    {'label': 'Safe driving', 'icon': Icons.shield_rounded},
    {'label': 'On time', 'icon': Icons.schedule_rounded},
    {'label': 'Professional', 'icon': Icons.workspace_premium_rounded},
  ];

  final List<double> _tipOptions = [0, 2, 3, 5];

  @override
  void initState() {
    super.initState();
    _ride = widget.ride;

    _sheetController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    Future.delayed(Duration(milliseconds: 100), () {
      _sheetController.forward();
    });
  }

  Future<void> _submitRating() async {
    if (_rating == 0) return;

    setState(() {
      _isSubmitting = true;
    });

    final success = await _rideService.rateDriver(
      rideId: _ride?.id ?? '',
      rating: _rating,
      comment: _commentController.text.isNotEmpty ? _commentController.text : null,
      feedbackTags: _selectedFeedback.isNotEmpty ? _selectedFeedback : null,
      tipAmount: _tipAmount,
    );

    if (success && mounted) {
      _showSuccessAndDismiss();
    } else {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _showSuccessAndDismiss() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.buildGradient(AppColors.successGradient),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Thanks for rating!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your feedback helps improve our service',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: AppColors.buildGradient(AppColors.primaryGradient),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home',
                      (route) => false,
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _sheetController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scrim,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              // Don't dismiss on tap outside
            },
            child: Container(color: Colors.transparent),
          ),
          AnimatedBuilder(
            animation: _sheetController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  0,
                  MediaQuery.of(context).size.height *
                      (1 - _sheetController.value) *
                      0.3,
                ),
                child: child,
              );
            },
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSheetHandle(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildDriverInfo(),
                            SizedBox(height: 24),
                            _buildRatingSection(),
                            SizedBox(height: 24),
                            _buildFeedbackChips(),
                            SizedBox(height: 24),
                            _buildCommentField(),
                            SizedBox(height: 24),
                            _buildTipSection(),
                            SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSheetHandle() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 12, bottom: 16),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.neutral300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildDriverInfo() {
    if (_ride?.driver == null) {
      return _buildFallbackDriverInfo();
    }

    return DriverInfoTile(
      driver: _ride!.driver!,
      showEta: false,
      showPhoneAction: false,
      compact: true,
    );
  }

  Widget _buildFallbackDriverInfo() {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: AppColors.buildGradient(AppColors.primaryGradient),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
        SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your Driver',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'How was your ride?',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Column(
      children: [
        Text(
          'Rate your experience',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16),
        RatingBar.builder(
          initialRating: 0,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 48,
          unratedColor: AppColors.starEmpty,
          itemPadding: EdgeInsets.symmetric(horizontal: 6),
          itemBuilder: (context, index) {
            return Icon(
              Icons.star_rounded,
              color: AppColors.starFilled,
            );
          },
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
        ),
        SizedBox(height: 12),
        Text(
          _getRatingLabel(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _rating > 0 ? AppColors.primary : AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  String _getRatingLabel() {
    if (_rating == 0) return 'Tap a star to rate';
    if (_rating <= 1) return 'Terrible';
    if (_rating <= 2) return 'Poor';
    if (_rating <= 3) return 'Okay';
    if (_rating <= 4) return 'Good';
    return 'Excellent!';
  }

  Widget _buildFeedbackChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What went well?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _feedbackOptions.map((option) {
            final isSelected = _selectedFeedback.contains(option['label']);
            return InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedFeedback.remove(option['label']);
                  } else {
                    _selectedFeedback.add(option['label'] as String);
                  }
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? AppColors.buildGradient(AppColors.primaryGradient)
                      : null,
                  color: isSelected ? null : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      option['icon'] as IconData,
                      size: 16,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                    SizedBox(width: 6),
                    Text(
                      option['label'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCommentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional comments',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12),
        TextField(
          controller: _commentController,
          maxLines: 3,
          maxLength: 200,
          style: TextStyle(
            fontSize: 15,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'Tell us more about your experience...',
            hintStyle: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 15,
            ),
            filled: true,
            fillColor: AppColors.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: EdgeInsets.all(16),
            counterStyle: TextStyle(
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTipSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Tip your driver',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Spacer(),
            Switch(
              value: _tipAmount != null && _tipAmount! > 0,
              onChanged: (value) {
                setState(() {
                  _tipAmount = value ? _tipOptions[1] : 0;
                });
              },
              activeColor: AppColors.primary,
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: _tipOptions.map((tip) {
            final isSelected = _tipAmount == tip;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _tipAmount = tip;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? AppColors.buildGradient(AppColors.accentGradient)
                          : null,
                      color: isSelected ? null : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.secondary : AppColors.border,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        tip == 0 ? 'No Tip' : '\$${tip.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
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
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: _rating > 0
                ? AppColors.buildGradient(AppColors.primaryGradient)
                : AppColors.buildGradient([
                    AppColors.neutral300,
                    AppColors.neutral400,
                  ]),
            borderRadius: BorderRadius.circular(16),
            boxShadow: _rating > 0
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _rating > 0 && !_isSubmitting ? _submitRating : null,
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: _isSubmitting
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Submit Rating',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}