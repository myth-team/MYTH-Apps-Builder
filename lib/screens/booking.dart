import 'package:flutter/material.dart';
import 'package:golden_stay_app/models/booking.dart'; 
import 'package:golden_stay_app/utils/colors.dart'; 
import 'package:golden_stay_app/utils/constants.dart'; 
import 'package:golden_stay_app/widgets/golden_button.dart'; 
import 'package:golden_stay_app/widgets/custom_text_field.dart'; 

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Booking> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadBookings();
  }

  void _loadBookings() {
    setState(() {
      _bookings = [
        Booking(
          id: 'BK001',
          userId: 'USR001',
          hotelId: 'HTL001',
          hotelName: 'Grand Palace Hotel',
          hotelImage: 'https://example.com/hotel1.jpg',
          roomId: 'RM001',
          roomType: 'Deluxe Suite',
          checkInDate: DateTime.now().add(const Duration(days: 5)),
          checkOutDate: DateTime.now().add(const Duration(days: 8)),
          numberOfGuests: 2,
          numberOfNights: 3,
          pricePerNight: 450.0,
          totalPrice: 1350.0,
          currency: 'USD',
          status: BookingStatus.confirmed,
          paymentStatus: PaymentStatus.paid,
          stringStatus: 'Confirmed',
        ),
        Booking(
          id: 'BK002',
          userId: 'USR001',
          hotelId: 'HTL002',
          hotelName: 'Azure Resort & Spa',
          hotelImage: 'https://example.com/hotel2.jpg',
          roomId: 'RM002',
          roomType: 'Ocean View Room',
          checkInDate: DateTime.now().add(const Duration(days: 15)),
          checkOutDate: DateTime.now().add(const Duration(days: 18)),
          numberOfGuests: 2,
          numberOfNights: 3,
          pricePerNight: 320.0,
          totalPrice: 960.0,
          currency: 'USD',
          status: BookingStatus.pending,
          paymentStatus: PaymentStatus.pending,
          stringStatus: 'Pending',
        ),
        Booking(
          id: 'BK003',
          userId: 'USR001',
          hotelId: 'HTL003',
          hotelName: 'Metropolitan Grand',
          hotelImage: 'https://example.com/hotel3.jpg',
          roomId: 'RM003',
          roomType: 'Presidential Suite',
          checkInDate: DateTime.now().subtract(const Duration(days: 10)),
          checkOutDate: DateTime.now().subtract(const Duration(days: 5)),
          numberOfGuests: 3,
          numberOfNights: 5,
          pricePerNight: 890.0,
          totalPrice: 4450.0,
          currency: 'USD',
          status: BookingStatus.completed,
          paymentStatus: PaymentStatus.paid,
          stringStatus: 'Completed',
        ),
        Booking(
          id: 'BK004',
          userId: 'USR001',
          hotelId: 'HTL004',
          hotelName: 'Golden Horizon Hotel',
          hotelImage: 'https://example.com/hotel4.jpg',
          roomId: 'RM004',
          roomType: 'Executive King',
          checkInDate: DateTime.now().subtract(const Duration(days: 30)),
          checkOutDate: DateTime.now().subtract(const Duration(days: 25)),
          numberGuests: 1,
          numberOfNights: 5,
          pricePerNight: 280.0,
          totalPrice: 1400.0,
          currency: 'USD',
          status: BookingStatus.completed,
          paymentStatus: PaymentStatus.paid,
          stringStatus: 'Completed',
        ),
        Booking(
          id: 'BK005',
          userId: 'USR001',
          hotelId: 'HTL005',
          hotelName: 'Royal Crown Hotel',
          hotelImage: 'https://example.com/hotel5.jpg',
          roomId: 'RM005',
          roomType: 'Royal Suite',
          checkInDate: DateTime.now().add(const Duration(days: 20)),
          checkOutDate: DateTime.now().add(const Duration(days: 23)),
          numberOfGuests: 2,
          numberOfNights: 3,
          pricePerNight: 650.0,
          totalPrice: 1950.0,
          currency: 'USD',
          status: BookingStatus.cancelled,
          paymentStatus: PaymentStatus.refunded,
          stringStatus: 'Cancelled',
        ),
      ];
      _isLoading = false;
    });
  }

  List<Booking> _getBookingsByStatus(BookingStatus? status) {
    if (status == null) {
      return _bookings;
    }
    return _bookings.where((b) => b.status == status).toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlack,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Bookings',
          style: TextStyle(
            color: AppColors.primaryGold,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryGold,
          indicatorWeight: 3,
          labelColor: AppColors.primaryGold,
          unselectedLabelColor: AppColors.mutedGold,
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          tabs: [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryGold,
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildBookingList(BookingStatus.confirmed),
                _buildBookingList(BookingStatus.completed),
                _buildBookingList(BookingStatus.cancelled),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showNewBookingDialog(context);
        },
        backgroundColor: AppColors.primaryGold,
        icon: Icon(Icons.add, color: AppColors.primaryBlack),
        label: Text(
          'New Booking',
          style: TextStyle(
            color: AppColors.primaryBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBookingList(BookingStatus status) {
    final bookings = _getBookingsByStatus(status);
    
    if (bookings.isEmpty) {
      return _buildEmptyState(status);
    }

    return RefreshIndicator(
      color: AppColors.primaryGold,
      backgroundColor: AppColors.lightBlack,
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 1000));
        _loadBookings();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return _buildBookingCard(bookings[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState(BookingStatus status) {
    String message;
    IconData icon;

    switch (status) {
      case BookingStatus.confirmed:
        message = 'No upcoming bookings';
        icon = Icons.event_available;
        break;
      case BookingStatus.completed:
        message = 'No past bookings';
        icon = Icons.history;
        break;
      case BookingStatus.cancelled:
        message = 'No cancelled bookings';
        icon = Icons.cancel_outlined;
        break;
      default:
        message = 'No bookings found';
        icon = Icons.calendar_today;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: AppColors.mutedGold,
          ),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: AppColors.pureWhite,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start planning your next luxury getaway',
            style: TextStyle(
              color: AppColors.mutedGold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return GestureDetector(
      onTap: () {
        _showBookingDetails(context, booking);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.lightBlack,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryGold.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGold.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.darkGold,
                    AppColors.primaryGold,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Container(
                        color: AppColors.lightBlack,
                        child: Icon(
                          Icons.hotel,
                          size: 60,
                          color: AppColors.mutedGold.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(booking.status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        booking.stringStatus,
                        style: TextStyle(
                          color: AppColors.pureWhite,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.hotelName,
                    style: TextStyle(
                      color: AppColors.pureWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    booking.roomType,
                    style: TextStyle(
                      color: AppColors.mutedGold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      _buildInfoChip(
                        Icons.calendar_today,
                        _formatDate(booking.checkInDate),
                      ),
                      SizedBox(width: 12),
                      _buildInfoChip(
                        Icons.nights_stay,
                        '${booking.numberOfNights} nights',
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Price',
                            style: TextStyle(
                              color: AppColors.mutedGold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${booking.currency} ${booking.totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: AppColors.primaryGold,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      if (booking.status == BookingStatus.confirmed)
                        Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.mutedGold,
                          size: 18,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.darkBlack,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.primaryGold,
          ),
          SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: AppColors.pureWhite,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return AppColors.darkGold;
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.completed:
        return Colors.green;
      case BookingStatus.cancelled:
        return Colors.red;
      default:
        return AppColors.mutedGold;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showBookingDetails(BuildContext context, Booking booking) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: AppColors.primaryBlack,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
            border: Border.all(
              color: AppColors.primaryGold.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.mutedGold,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Booking Details',
                          style: TextStyle(
                            color: AppColors.primaryGold,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      _buildDetailRow('Booking ID', booking.id),
                      _buildDetailRow('Hotel', booking.hotelName),
                      _buildDetailRow('Room Type', booking.roomType),
                      _buildDetailRow(
                        'Check-in',
                        _formatDate(booking.checkInDate),
                      ),
                      _buildDetailRow(
                        'Check-out',
                        _formatDate(booking.checkOutDate),
                      ),
                      _buildDetailRow(
                        'Guests',
                        '${booking.numberOfGuests}',
                      ),
                      _buildDetailRow(
                        'Nights',
                        '${booking.numberOfNights}',
                      ),
                      _buildDetailRow(
                        'Price per Night',
                        '${booking.currency} ${booking.pricePerNight.toStringAsFixed(2)}',
                      ),
                      Divider(
                        color: AppColors.lightBlack,
                        height: 32,
                      ),
                      _buildDetailRow(
                        'Total Price',
                        '${booking.currency} ${booking.totalPrice.toStringAsFixed(2)}',
                        isHighlighted: true,
                      ),
                      SizedBox(height: 32),
                      if (booking.status == BookingStatus.confirmed) ...[
                        Row(
                          children: [
                            Expanded(
                              child: GoldenButton(
                                text: 'Modify',
                                style: GoldenButtonStyle.outlined,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: GoldenButton(
                                text: 'Cancel',
                                style: GoldenButtonStyle.filled,
                                onPressed: () {
                                  Navigator.pop(context);
                                  _showCancelDialog(context, booking);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (booking.status == BookingStatus.completed)
                        GoldenButton(
                          text: 'Book Again',
                          style: GoldenButtonStyle.filled,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isHighlighted = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.mutedGold,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isHighlighted ? AppColors.primaryGold : AppColors.pureWhite,
              fontSize: 14,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, Booking booking) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.lightBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Cancel Booking',
            style: TextStyle(
              color: AppColors.primaryGold,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to cancel your booking at ${booking.hotelName}?',
            style: TextStyle(
              color: AppColors.pureWhite,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'No, Keep It',
                style: TextStyle(
                  color: AppColors.mutedGold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  final index = _bookings.indexWhere((b) => b.id == booking.id);
                  if (index != -1) {
                    _bookings[index] = Booking(
                      id: booking.id,
                      userId: booking.userId,
                      hotelId: booking.hotelId,
                      hotelName: booking.hotelName,
                      hotelImage: booking.hotelImage,
                      roomId: booking.roomId,
                      roomType: booking.roomType,
                      checkInDate: booking.checkInDate,
                      checkOutDate: booking.checkOutDate,
                      numberOfGuests: booking.numberOfGuests,
                      numberOfNights: booking.numberOfNights,
                      pricePerNight: booking.pricePerNight,
                      totalPrice: booking.totalPrice,
                      currency: booking.currency,
                      status: BookingStatus.cancelled,
                      paymentStatus: PaymentStatus.refunded,
                      stringStatus: 'Cancelled',
                    );
                  }
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Booking cancelled successfully'),
                    backgroundColor: AppColors.lightBlack,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text(
                'Yes, Cancel',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showNewBookingDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: AppColors.primaryBlack,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
            border: Border.all(
              color: AppColors.primaryGold.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.mutedGold,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Quick Booking',
                        style: TextStyle(
                          color: AppColors.primaryGold,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    CustomTextField(
                      labelText: 'Hotel Name',
                      hintText: 'Enter hotel name',
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      labelText: 'Check-in Date',
                      hintText: 'Select date',
                      keyboardType: TextInputType.datetime,
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      labelText: 'Number of Guests',
                      hintText: 'Enter number of guests',
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 24),
                    GoldenButton(
                      text: 'Search Hotels',
                      style: GoldenButtonStyle.filled,
                      width: double.infinity,
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Searching for available hotels...'),
                            backgroundColor: AppColors.lightBlack,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
</BookingScreen>
</_BookingScreenState>
</BookingScreen>