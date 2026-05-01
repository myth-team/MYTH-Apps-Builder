import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project_app/models/hotel.dart'; 
import 'package:new_project_app/models/room.dart'; 
import 'package:new_project_app/models/booking.dart'; 
import 'package:new_project_app/utils/colors.dart'; 
import 'package:new_project_app/screens/my_bookings.dart'; 
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookingScreen extends StatefulWidget {
  final Hotel hotel;
  final Room room;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int guestCount;

  const BookingScreen({
    super.key,
    required this.hotel,
    required this.room,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guestCount,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _specialRequestsController = TextEditingController();

  String _selectedPaymentMethod = 'credit_card';
  bool _isProcessing = false;
  bool _isConfirmed = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'id': 'credit_card', 'name': 'Credit Card', 'icon': Icons.credit_card},
    {'id': 'paypal', 'name': 'PayPal', 'icon': Icons.payment},
    {'id': 'apple_pay', 'name': 'Apple Pay', 'icon': Icons.apple},
    {'id': 'google_pay', 'name': 'Google Pay', 'icon': Icons.g_mobiledata},
  ];

  int _getNightCount() {
    return widget.checkOutDate.difference(widget.checkInDate).inDays;
  }

  double get _totalPrice {
    final nights = _getNightCount();
    final subtotal = widget.room.pricePerNight * nights;
    return subtotal + (subtotal * 0.1);
  }

  @override
  Widget build(BuildContext context) {
    if (_isConfirmed) {
      return _buildConfirmationScreen();
    }

    return Scaffold(
      backgroundColor: AppColors.surfaceBlack,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceBlack,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.cardBlack,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back, color: AppColors.white),
          ),
        ),
        title: Text(
          'Complete Booking',
          style: GoogleFonts.poppins(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBookingSummary(),
              SizedBox(height: 24),
              _buildGuestDetails(),
              SizedBox(height: 24),
              _buildPaymentMethod(),
              SizedBox(height: 24),
              _buildSpecialRequests(),
              SizedBox(height: 32),
              _buildPriceBreakdown(),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomSheet: _buildBottomBar(),
    );
  }

  Widget _buildBookingSummary() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.goldShadow),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: widget.hotel.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: AppColors.secondaryBlack),
              errorWidget: (context, url, error) => Container(
                color: AppColors.secondaryBlack,
                child: Icon(Icons.hotel, color: AppColors.grey700),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.hotel.name,
                  style: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.room.name,
                  style: GoogleFonts.poppins(
                    color: AppColors.primaryGold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: AppColors.grey500, size: 14),
                    SizedBox(width: 6),
                    Text(
                      '${DateFormat('MMM dd').format(widget.checkInDate)} - ${DateFormat('MMM dd').format(widget.checkOutDate)}',
                      style: GoogleFonts.poppins(
                        color: AppColors.grey500,
                        fontSize: 12,
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

  Widget _buildGuestDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Guest Details',
          style: GoogleFonts.poppins(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _firstNameController,
                label: 'First Name',
                hint: 'John',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _lastNameController,
                label: 'Last Name',
                hint: 'Doe',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        _buildTextField(
          controller: _emailController,
          label: 'Email',
          hint: 'john.doe@example.com',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Required';
            }
            if (!value.contains('@')) {
              return 'Invalid email';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
        _buildTextField(
          controller: _phoneController,
          label: 'Phone',
          hint: '+1 234 567 8900',
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColors.grey500,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: GoogleFonts.poppins(color: AppColors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(color: AppColors.grey700),
            filled: true,
            fillColor: AppColors.cardBlack,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.grey700),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.grey700),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primaryGold),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: GoogleFonts.poppins(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16),
        ..._paymentMethods.map((method) {
          final isSelected = _selectedPaymentMethod == method['id'];
          return GestureDetector(
            onTap: () => setState(() => _selectedPaymentMethod = method['id']),
            child: Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBlack,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primaryGold : AppColors.grey700,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryBlack,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      method['icon'],
                      color: isSelected ? AppColors.primaryGold : AppColors.grey500,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      method['name'],
                      style: GoogleFonts.poppins(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? AppColors.primaryGold : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? AppColors.primaryGold : AppColors.grey700,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Icon(Icons.check, color: AppColors.primaryBlack, size: 16)
                        : null,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSpecialRequests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Special Requests',
          style: GoogleFonts.poppins(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _specialRequestsController,
          maxLines: 3,
          style: GoogleFonts.poppins(color: AppColors.white),
          decoration: InputDecoration(
            hintText: 'Any special requests or preferences...',
            hintStyle: GoogleFonts.poppins(color: AppColors.grey700),
            filled: true,
            fillColor: AppColors.cardBlack,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.grey700),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.grey700),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primaryGold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceBreakdown() {
    final nights = _getNightCount();
    final subtotal = widget.room.pricePerNight * nights;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.goldShadow),
      ),
      child: Column(
        children: [
          _buildPriceRow('Room Price', '\$${widget.room.pricePerNight} x $nights nights'),
          SizedBox(height: 12),
          _buildPriceRow('Subtotal', '\$$subtotal'),
          SizedBox(height: 12),
          _buildPriceRow('Taxes & Fees', '\$${(subtotal * 0.1).toStringAsFixed(0)}'),
          SizedBox(height: 16),
          Divider(color: AppColors.grey700),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: GoogleFonts.poppins(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '\$${_totalPrice.toStringAsFixed(0)}',
                style: GoogleFonts.poppins(
                  color: AppColors.primaryGold,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColors.grey500,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: AppColors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceBlack,
        border: Border(
          top: BorderSide(color: AppColors.grey700),
        ),
      ),
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: _isProcessing ? null : _processBooking,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.goldShadow,
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: _isProcessing
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.primaryBlack,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Confirm Booking',
                      style: GoogleFonts.poppins(
                        color: AppColors.primaryBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _processBooking() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isProcessing = true);

    // Simulate processing
    await Future.delayed(Duration(seconds: 2));

    final booking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      hotel: widget.hotel,
      room: widget.room,
      checkInDate: widget.checkInDate,
      checkOutDate: widget.checkOutDate,
      guestCount: widget.guestCount,
      guestName: '${_firstNameController.text} ${_lastNameController.text}',
      totalPrice: _totalPrice,
      status: 'confirmed',
      createdAt: DateTime.now(),
    );

    // Save booking (in real app, use Provider/State Management)
    // For demo, we'll just navigate to confirmation

    setState(() {
      _isProcessing = false;
      _isConfirmed = true;
    });
  }

  Widget _buildConfirmationScreen() {
    final nights = _getNightCount();

    return Scaffold(
      backgroundColor: AppColors.surfaceBlack,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldShadow,
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.check,
                  color: AppColors.primaryBlack,
                  size: 60,
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Booking Confirmed!',
                style: GoogleFonts.poppins(
                  color: AppColors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Your reservation has been successfully completed.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: AppColors.grey500,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 32),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBlack,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.goldShadow),
                ),
                child: Column(
                  children: [
                    _buildConfirmRow('Booking ID', '#${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}'),
                    Divider(color: AppColors.grey700, height: 24),
                    _buildConfirmRow('Hotel', widget.hotel.name),
                    Divider(color: AppColors.grey700, height: 24),
                    _buildConfirmRow('Room', widget.room.name),
                    Divider(color: AppColors.grey700, height: 24),
                    _buildConfirmRow('Check-in', DateFormat('MMM dd, yyyy').format(widget.checkInDate)),
                    Divider(color: AppColors.grey700, height: 24),
                    _buildConfirmRow('Check-out', DateFormat('MMM dd, yyyy').format(widget.checkOutDate)),
                    Divider(color: AppColors.grey700, height: 24),
                    _buildConfirmRow('Guests', '${widget.guestCount} adults'),
                    Divider(color: AppColors.grey700, height: 24),
                    _buildConfirmRow('Total Paid', '\$${_totalPrice.toStringAsFixed(0)}'),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MyBookingsScreen()),
                          (route) => false,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: AppColors.goldGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'View My Bookings',
                            style: GoogleFonts.poppins(
                              color: AppColors.primaryBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColors.grey500,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: AppColors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specialRequestsController.dispose();
    super.dispose();
  }
}