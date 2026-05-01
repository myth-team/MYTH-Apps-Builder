import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project_app/models/hotel.dart'; 
import 'package:new_project_app/models/room.dart'; 
import 'package:new_project_app/models/booking.dart'; 
import 'package:new_project_app/utils/colors.dart'; 
import 'package:new_project_app/screens/detail.dart'; 
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sample bookings data
  final List<Booking> _upcomingBookings = [
    Booking(
      id: '1',
      hotelId: '1',
      hotelName: 'The Grand Palace',
      hotelImageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
      roomId: '1',
      roomName: 'Deluxe Suite',
      hotel: Hotel(
        id: '1',
        name: 'The Grand Palace',
        location: 'Paris, France',
        rating: 4.9,
        reviewCount: 1250,
        pricePerNight: 450,
        imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
        gallery: [],
        description: 'Experience luxury at its finest',
        amenities: ['wifi', 'pool', 'spa'],
        rooms: [],
      ),
      room: Room(id: '1', hotelId: '1', name: 'Deluxe Suite', description: 'Luxury suite', pricePerNight: 450, capacity: 2, bedCount: 1, bedType: 'King', size: '45sqm', imageUrl: '', amenities: []),
      checkInDate: DateTime.now().add(Duration(days: 5)),
      checkOutDate: DateTime.now().add(Duration(days: 8)),
      guestCount: 2,
      guestName: 'John Doe',
      guestEmail: 'john@example.com',
      guestPhone: '+1234567890',
      totalPrice: 1485,
      roomPricePerNight: 450,
      nightsCount: 3,
      status: BookingStatus.confirmed,
      createdAt: DateTime.now().subtract(Duration(days: 2)),
    ),
    Booking(
      id: '2',
      hotelId: '2',
      hotelName: 'Azure Resort & Spa',
      hotelImageUrl: 'https://images.unsplash.com/photo-1573843981267-be1999ff37cd?w=800',
      roomId: '2',
      roomName: 'Beach Villa',
      hotel: Hotel(
        id: '2',
        name: 'Azure Resort & Spa',
        location: 'Maldives',
        rating: 4.8,
        reviewCount: 890,
        pricePerNight: 650,
        imageUrl: 'https://images.unsplash.com/photo-1573843981267-be1999ff37cd?w=800',
        gallery: [],
        description: 'Paradise awaits',
        amenities: ['wifi', 'pool', 'beach'],
        rooms: [],
      ),
      room: Room(id: '2', hotelId: '2', name: 'Beach Villa', description: 'Beach villa', pricePerNight: 650, capacity: 2, bedCount: 1, bedType: 'King', size: '80sqm', imageUrl: '', amenities: []),
      checkInDate: DateTime.now().add(Duration(days: 15)),
      checkOutDate: DateTime.now().add(Duration(days: 20)),
      guestCount: 2,
      guestName: 'John Doe',
      guestEmail: 'john@example.com',
      guestPhone: '+1234567890',
      totalPrice: 3575,
      roomPricePerNight: 650,
      nightsCount: 5,
      status: BookingStatus.confirmed,
      createdAt: DateTime.now().subtract(Duration(days: 5)),
    ),
  ];

  final List<Booking> _pastBookings = [
    Booking(
      id: '3',
      hotelId: '3',
      hotelName: 'Skyline Tower',
      hotelImageUrl: 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800',
      roomId: '3',
      roomName: 'City View Room',
      hotel: Hotel(
        id: '3',
        name: 'Skyline Tower',
        location: 'New York, USA',
        rating: 4.7,
        reviewCount: 2100,
        pricePerNight: 380,
        imageUrl: 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800',
        gallery: [],
        description: 'Modern luxury with city views',
        amenities: ['wifi', 'gym', 'restaurant'],
        rooms: [],
      ),
      room: Room(id: '3', hotelId: '3', name: 'City View Room', description: 'City view room', pricePerNight: 380, capacity: 2, bedCount: 1, bedType: 'Queen', size: '35sqm', imageUrl: '', amenities: []),
      checkInDate: DateTime.now().subtract(Duration(days: 10)),
      checkOutDate: DateTime.now().subtract(Duration(days: 7)),
      guestCount: 1,
      guestName: 'John Doe',
      guestEmail: 'john@example.com',
      guestPhone: '+1234567890',
      totalPrice: 1254,
      roomPricePerNight: 380,
      nightsCount: 3,
      status: BookingStatus.checkedOut,
      createdAt: DateTime.now().subtract(Duration(days: 20)),
    ),
    Booking(
      id: '4',
      hotelId: '4',
      hotelName: 'Royal Garden Hotel',
      hotelImageUrl: 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800',
      roomId: '4',
      roomName: 'Garden Room',
      hotel: Hotel(
        id: '4',
        name: 'Royal Garden Hotel',
        location: 'London, UK',
        rating: 4.6,
        reviewCount: 750,
        pricePerNight: 320,
        imageUrl: 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800',
        gallery: [],
        description: 'Classic elegance',
        amenities: ['wifi', 'pool', 'garden'],
        rooms: [],
      ),
      room: Room(id: '4', hotelId: '4', name: 'Garden Room', description: 'Garden view room', pricePerNight: 320, capacity: 2, bedCount: 1, bedType: 'King', size: '30sqm', imageUrl: '', amenities: []),
      checkInDate: DateTime.now().subtract(Duration(days: 30)),
      checkOutDate: DateTime.now().subtract(Duration(days: 27)),
      guestCount: 2,
      guestName: 'John Doe',
      guestEmail: 'john@example.com',
      guestPhone: '+1234567890',
      totalPrice: 1056,
      roomPricePerNight: 320,
      nightsCount: 3,
      status: BookingStatus.checkedOut,
      createdAt: DateTime.now().subtract(Duration(days: 35)),
    ),
    Booking(
      id: '5',
      hotelId: '1',
      hotelName: 'The Grand Palace',
      hotelImageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
      roomId: '1',
      roomName: 'Deluxe Suite',
      hotel: Hotel(
        id: '1',
        name: 'The Grand Palace',
        location: 'Paris, France',
        rating: 4.9,
        reviewCount: 1250,
        pricePerNight: 450,
        imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
        gallery: [],
        description: 'Experience luxury at its finest',
        amenities: ['wifi', 'pool', 'spa'],
        rooms: [],
      ),
      room: Room(id: '1', hotelId: '1', name: 'Deluxe Suite', description: 'Luxury suite', pricePerNight: 450, capacity: 2, bedCount: 1, bedType: 'King', size: '45sqm', imageUrl: '', amenities: []),
      checkInDate: DateTime.now().subtract(Duration(days: 60)),
      checkOutDate: DateTime.now().subtract(Duration(days: 55)),
      guestCount: 2,
      guestName: 'John Doe',
      guestEmail: 'john@example.com',
      guestPhone: '+1234567890',
      totalPrice: 2475,
      roomPricePerNight: 450,
      nightsCount: 5,
      status: BookingStatus.cancelled,
      createdAt: DateTime.now().subtract(Duration(days: 65)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          'My Bookings',
          style: GoogleFonts.poppins(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.cardBlack,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                gradient: AppColors.goldGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.all(4),
              labelColor: AppColors.primaryBlack,
              unselectedLabelColor: AppColors.grey500,
              labelStyle: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              tabs: [
                Tab(text: 'Upcoming (${_upcomingBookings.length})'),
                Tab(text: 'Past (${_pastBookings.length})'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingsList(_upcomingBookings, isUpcoming: true),
          _buildBookingsList(_pastBookings, isUpcoming: false),
        ],
      ),
    );
  }

  Widget _buildBookingsList(List<Booking> bookings, {required bool isUpcoming}) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              color: AppColors.grey700,
              size: 60,
            ),
            SizedBox(height: 16),
            Text(
              isUpcoming ? 'No upcoming bookings' : 'No past bookings',
              style: GoogleFonts.poppins(
                color: AppColors.grey500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _buildBookingCard(booking, isUpcoming: isUpcoming);
      },
    );
  }

  Widget _buildBookingCard(Booking booking, {required bool isUpcoming}) {
    final nights = booking.checkOutDate.difference(booking.checkInDate).inDays;
    final statusColor = _getStatusColor(booking.status);
    final statusText = _getStatusText(booking.status);

    // Get image URL from hotel object or fallback to hotelImageUrl
    final imageUrl = booking.hotel?.imageUrl ?? booking.hotelImageUrl;
    final hotelName = booking.hotel?.name ?? booking.hotelName;
    final hotelLocation = booking.hotel?.location ?? '';
    final roomName = booking.room?.name ?? booking.roomName;

    return GestureDetector(
      onTap: () {
        if (booking.hotel != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(hotel: booking.hotel!),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.cardBlack,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: booking.status == BookingStatus.cancelled 
                ? AppColors.error.withOpacity(0.3) 
                : AppColors.goldShadow,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.secondaryBlack,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryGold,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.secondaryBlack,
                      child: Icon(Icons.hotel, color: AppColors.grey700, size: 40),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusText,
                      style: GoogleFonts.poppins(
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hotelName,
                              style: GoogleFonts.poppins(
                                color: AppColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.location_on, color: AppColors.primaryGold, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  hotelLocation,
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${booking.totalPrice.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(
                              color: AppColors.primaryGold,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '$nights nights',
                            style: GoogleFonts.poppins(
                              color: AppColors.grey500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryBlack,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, color: AppColors.primaryGold, size: 18),
                              SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isUpcoming ? 'Check-in' : 'Stayed',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.grey500,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('MMM dd, yyyy').format(
                                      booking.checkInDate,
                                    ),
                                    style: GoogleFonts.poppins(
                                      color: AppColors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: AppColors.grey700,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calendar_today, color: AppColors.primaryGold, size: 18),
                              SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isUpcoming ? 'Check-out' : 'Check-out',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.grey500,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('MMM dd, yyyy').format(
                                      booking.checkOutDate,
                                    ),
                                    style: GoogleFonts.poppins(
                                      color: AppColors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: AppColors.grey700,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.person, color: AppColors.primaryGold, size: 18),
                              SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Guests',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.grey500,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    '${booking.guestCount}',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.room, color: AppColors.grey500, size: 14),
                      SizedBox(width: 6),
                      Text(
                        roomName,
                        style: GoogleFonts.poppins(
                          color: AppColors.grey500,
                          fontSize: 12,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Booking ID: #${booking.id}',
                        style: GoogleFonts.poppins(
                          color: AppColors.grey700,
                          fontSize: 10,
                        ),
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

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return AppColors.success;
      case BookingStatus.pending:
        return AppColors.warning;
      case BookingStatus.cancelled:
        return AppColors.error;
      case BookingStatus.checkedOut:
        return AppColors.info;
      case BookingStatus.checkedIn:
        return AppColors.success;
      default:
        return AppColors.grey500;
    }
  }

  String _getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.checkedOut:
        return 'Completed';
      case BookingStatus.checkedIn:
        return 'Checked In';
      default:
        return status.name;
    }
  }
}