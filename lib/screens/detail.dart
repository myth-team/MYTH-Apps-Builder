import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project_app/models/hotel.dart'; 
import 'package:new_project_app/models/room.dart'; 
import 'package:new_project_app/utils/colors.dart'; 
import 'package:new_project_app/widgets/amenity_chip.dart'; 
import 'package:new_project_app/screens/booking.dart'; 
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatefulWidget {
  final Hotel hotel;

  const DetailScreen({super.key, required this.hotel});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _currentImageIndex = 0;
  Room? _selectedRoom;
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _guestCount = 1;

  @override
  void initState() {
    super.initState();
    if (widget.hotel.rooms.isNotEmpty) {
      _selectedRoom = widget.hotel.rooms.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBlack,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildImageGallery()),
              SliverToBoxAdapter(child: _buildHotelInfo()),
              SliverToBoxAdapter(child: _buildRoomSelection()),
              SliverToBoxAdapter(child: _buildAmenities()),
              SliverToBoxAdapter(child: _buildDateSelection()),
              SliverToBoxAdapter(child: _buildGuestSelection()),
              SliverToBoxAdapter(child: _buildFooter()),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildStickyBookNow(),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    final gallery = widget.hotel.gallery.isNotEmpty
        ? widget.hotel.gallery
        : [widget.hotel.imageUrl];

    return Stack(
      children: [
        SizedBox(
          height: 350,
          child: PageView.builder(
            itemCount: gallery.length,
            onPageChanged: (index) {
              setState(() => _currentImageIndex = index);
            },
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: gallery[index],
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
                  child: Icon(Icons.hotel, color: AppColors.grey700, size: 60),
                ),
              );
            },
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 20,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cardBlack.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                color: AppColors.white,
                size: 20,
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          right: 20,
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardBlack.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border,
              color: AppColors.primaryGold,
              size: 20,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              gallery.length,
              (index) => Container(
                width: _currentImageIndex == index ? 24 : 8,
                height: 8,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: _currentImageIndex == index
                      ? AppColors.primaryGold
                      : AppColors.grey700,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHotelInfo() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.hotel.name,
                  style: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, color: AppColors.primaryBlack, size: 16),
                    SizedBox(width: 4),
                    Text(
                      widget.hotel.rating.toString(),
                      style: GoogleFonts.poppins(
                        color: AppColors.primaryBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, color: AppColors.primaryGold, size: 18),
              SizedBox(width: 6),
              Text(
                widget.hotel.location,
                style: GoogleFonts.poppins(
                  color: AppColors.grey500,
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 16),
              Icon(Icons.reviews, color: AppColors.grey500, size: 18),
              SizedBox(width: 6),
              Text(
                '${widget.hotel.reviewCount} reviews',
                style: GoogleFonts.poppins(
                  color: AppColors.grey500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            widget.hotel.description,
            style: GoogleFonts.poppins(
              color: AppColors.grey300,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomSelection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Room',
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          ...widget.hotel.rooms.map((room) => _buildRoomCard(room)),
        ],
      ),
    );
  }

  Widget _buildRoomCard(Room room) {
    final isSelected = _selectedRoom?.id == room.id;
    return GestureDetector(
      onTap: () => setState(() => _selectedRoom = room),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBlack,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryGold : AppColors.grey700,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: room.imageUrl,
                width: 100,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.secondaryBlack,
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.secondaryBlack,
                  child: Icon(Icons.room, color: AppColors.grey700),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.name,
                    style: GoogleFonts.poppins(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.person, color: AppColors.grey500, size: 14),
                      SizedBox(width: 4),
                      Text(
                        '${room.maxGuests} guests',
                        style: GoogleFonts.poppins(
                          color: AppColors.grey500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: room.amenities.take(3).map((amenity) {
                      return Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(
                          _getAmenityIcon(amenity),
                          color: AppColors.primaryGold,
                          size: 14,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${room.pricePerNight}',
                  style: GoogleFonts.poppins(
                    color: AppColors.primaryGold,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'per night',
                  style: GoogleFonts.poppins(
                    color: AppColors.grey500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            if (isSelected) ...[
              SizedBox(width: 12),
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: AppColors.primaryBlack,
                  size: 16,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAmenities() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amenities',
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: widget.hotel.amenities.map((amenity) {
              return AmenityChip(amenity: amenity);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Dates',
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildDatePicker('Check-in', _checkInDate, true)),
              SizedBox(width: 16),
              Expanded(child: _buildDatePicker('Check-out', _checkOutDate, false)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime? date, bool isCheckIn) {
    return GestureDetector(
      onTap: () => _selectDate(isCheckIn),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBlack,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey700),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                color: AppColors.grey500,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, color: AppColors.primaryGold, size: 18),
                SizedBox(width: 8),
                Text(
                  date != null ? DateFormat('MMM dd, yyyy').format(date) : 'Select date',
                  style: GoogleFonts.poppins(
                    color: date != null ? AppColors.white : AppColors.grey500,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn
          ? (_checkInDate ?? DateTime.now())
          : (_checkOutDate ?? DateTime.now().add(Duration(days: 1))),
      firstDate: isCheckIn ? DateTime.now() : (_checkInDate ?? DateTime.now()),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primaryGold,
              onPrimary: AppColors.primaryBlack,
              surface: AppColors.cardBlack,
              onSurface: AppColors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
          if (_checkOutDate != null && _checkOutDate!.isBefore(picked)) {
            _checkOutDate = picked.add(Duration(days: 1));
          }
        } else {
          _checkOutDate = picked;
        }
      });
    }
  }

  Widget _buildGuestSelection() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Guests',
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBlack,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grey700),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, color: AppColors.primaryGold),
                    SizedBox(width: 12),
                    Text(
                      'Adults',
                      style: GoogleFonts.poppins(
                        color: AppColors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_guestCount > 1) {
                          setState(() => _guestCount--);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _guestCount > 1 ? AppColors.secondaryBlack : AppColors.grey900,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.remove,
                          color: _guestCount > 1 ? AppColors.white : AppColors.grey700,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      '$_guestCount',
                      style: GoogleFonts.poppins(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        if (_guestCount < (_selectedRoom?.maxGuests ?? 4)) {
                          setState(() => _guestCount++);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryBlack,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.add,
                          color: AppColors.white,
                          size: 20,
                        ),
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

  Widget _buildFooter() {
    final nights = _checkInDate != null && _checkOutDate != null
        ? _checkOutDate!.difference(_checkInDate!).inDays
        : 1;
    final total = (_selectedRoom?.pricePerNight ?? 0) * nights;

    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBlack,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.goldShadow),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price Details',
                  style: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${_selectedRoom?.pricePerNight ?? 0} x $nights nights',
                  style: GoogleFonts.poppins(
                    color: AppColors.grey500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '\$$total',
                  style: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Taxes & Fees',
                  style: GoogleFonts.poppins(
                    color: AppColors.grey500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '\$${(total * 0.1).toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Divider(color: AppColors.grey700),
            SizedBox(height: 12),
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
                  '\$${(total * 1.1).toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    color: AppColors.primaryGold,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyBookNow() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.surfaceBlack,
            AppColors.surfaceBlack.withOpacity(0.95),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: _selectedRoom != null
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreen(
                        hotel: widget.hotel,
                        room: _selectedRoom!,
                        checkInDate: _checkInDate ?? DateTime.now(),
                        checkOutDate: _checkOutDate ?? DateTime.now().add(Duration(days: 1)),
                        guestCount: _guestCount,
                      ),
                    ),
                  );
                }
              : null,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: _selectedRoom != null ? AppColors.goldGradient : null,
              color: _selectedRoom == null ? AppColors.grey700 : null,
              borderRadius: BorderRadius.circular(16),
              boxShadow: _selectedRoom != null
                  ? [
                      BoxShadow(
                        color: AppColors.goldShadow,
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                _selectedRoom != null ? 'Book Now' : 'Select a Room',
                style: GoogleFonts.poppins(
                  color: _selectedRoom != null ? AppColors.primaryBlack : AppColors.grey500,
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

  IconData _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'wifi':
        return Icons.wifi;
      case 'pool':
        return Icons.pool;
      case 'spa':
        return Icons.spa;
      case 'restaurant':
        return Icons.restaurant;
      case 'gym':
        return Icons.fitness_center;
      case 'parking':
        return Icons.local_parking;
      case 'beach':
        return Icons.beach_access;
      case 'garden':
        return Icons.park;
      case 'ac':
        return Icons.ac_unit;
      case 'balcony':
        return Icons.balcony;
      default:
        return Icons.check_circle;
    }
  }
}