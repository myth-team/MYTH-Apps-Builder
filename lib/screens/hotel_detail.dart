import 'package:flutter/material.dart';
import 'package:golden_stay_app/models/hotel.dart'; 
import 'package:golden_stay_app/models/room.dart'; 
import 'package:golden_stay_app/utils/colors.dart'; 
import 'package:golden_stay_app/utils/constants.dart'; 
import 'package:golden_stay_app/widgets/golden_button.dart'; 
import 'package:golden_stay_app/widgets/custom_text_field.dart'; 

class HotelDetailScreen extends StatefulWidget {
  final Hotel hotel;

  const HotelDetailScreen({
    super.key,
    required this.hotel,
  });

  @override
  State<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  final PageController _imagePageController = PageController();
  int _currentImageIndex = 0;
  int _selectedRoomIndex = 0;
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _guestCount = 1;

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  void _showDatePicker(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? DateTime.now() : (_checkInDate ?? DateTime.now()),
      firstDate: isCheckIn ? DateTime.now() : (_checkInDate ?? DateTime.now()),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryGold,
              surface: AppColors.primaryBlack,
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
            _checkOutDate = null;
          }
        } else {
          _checkOutDate = picked;
        }
      });
    }
  }

  void _showGuestPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.primaryBlack,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.lightBlack,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Select Guests',
                style: TextStyle(
                  color: AppColors.pureWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGuestCounterButton(
                    icon: Icons.remove,
                    onTap: _guestCount > 1 ? () => setState(() => _guestCount--) : null,
                  ),
                  const SizedBox(width: 32),
                  Text(
                    '$_guestCount',
                    style: const TextStyle(
                      color: AppColors.primaryGold,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 32),
                  _buildGuestCounterButton(
                    icon: Icons.add,
                    onTap: _guestCount < 10 ? () => setState(() => _guestCount++) : null,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: GoldenButton(
                  text: 'Confirm',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGuestCounterButton({required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: onTap != null ? AppColors.lightBlack : AppColors.lightBlack.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: onTap != null ? AppColors.primaryGold : AppColors.mutedGold,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: onTap != null ? AppColors.primaryGold : AppColors.mutedGold,
          size: 24,
        ),
      ),
    );
  }

  void _bookRoom(Room room) {
    if (_checkInDate == null || _checkOutDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select check-in and check-out dates'),
          backgroundColor: AppColors.darkGold,
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.primaryGold, width: 1),
        ),
        title: const Text(
          'Confirm Booking',
          style: TextStyle(color: AppColors.primaryGold, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.hotel.name,
              style: const TextStyle(
                color: AppColors.pureWhite,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              room.roomType,
              style: const TextStyle(color: AppColors.mutedGold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildBookingDetailRow('Check-in', '${_checkInDate!.day}/${_checkInDate!.month}/${_checkInDate!.year}'),
            _buildBookingDetailRow('Check-out', '${_checkOutDate!.day}/${_checkOutDate!.month}/${_checkOutDate!.year}'),
            _buildBookingDetailRow('Guests', '$_guestCount'),
            const Divider(color: AppColors.lightBlack),
            _buildBookingDetailRow('Price/night', '\$${room.pricePerNight.toStringAsFixed(2)}'),
            _buildBookingDetailRow(
              'Total',
              '\$${(room.pricePerNight * _checkOutDate!.difference(_checkInDate!).inDays).toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.mutedGold),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking confirmed!'),
                  backgroundColor: AppColors.primaryGold,
                ),
              );
            },
            child: const Text(
              'Confirm',
              style: TextStyle(color: AppColors.primaryGold, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? AppColors.pureWhite : AppColors.mutedGold,
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isTotal ? AppColors.primaryGold : AppColors.pureWhite,
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Room> mockRooms = _generateMockRooms();

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primaryBlack,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlack.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: AppColors.primaryGold),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlack.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.favorite_border, color: AppColors.primaryGold),
                  onPressed: () {},
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlack.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.share, color: AppColors.primaryGold),
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    controller: _imagePageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemCount: widget.hotel.images.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        widget.hotel.images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.lightBlack,
                            child: const Center(
                              child: Icon(
                                Icons.hotel,
                                size: 80,
                                color: AppColors.mutedGold,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.hotel.images.length,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentImageIndex == index
                                ? AppColors.primaryGold
                                : AppColors.pureWhite.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.hotel.name,
                              style: const TextStyle(
                                color: AppColors.pureWhite,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: AppColors.primaryGold,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.hotel.city}, ${widget.hotel.country}',
                                  style: const TextStyle(
                                    color: AppColors.mutedGold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.lightBlack,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.primaryGold, width: 1),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: AppColors.primaryGold, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              widget.hotel.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: AppColors.primaryGold,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _buildInfoChip(Icons.king_bed, '${widget.hotel.totalRooms} Rooms'),
                      const SizedBox(width: 12),
                      _buildInfoChip(Icons.people, '${widget.hotel.availableRooms} Available'),
                      const SizedBox(width: 12),
                      _buildInfoChip(Icons.wifi, 'Free WiFi'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'About',
                    style: TextStyle(
                      color: AppColors.primaryGold,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.hotel.description,
                    style: const TextStyle(
                      color: AppColors.pureWhite,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Amenities',
                    style: TextStyle(
                      color: AppColors.primaryGold,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: widget.hotel.amenities.map((amenity) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.lightBlack,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.mutedGold, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getAmenityIcon(amenity),
                              color: AppColors.primaryGold,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              amenity,
                              style: const TextStyle(
                                color: AppColors.pureWhite,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Select Dates',
                    style: TextStyle(
                      color: AppColors.primaryGold,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateSelector(
                          label: 'Check-in',
                          date: _checkInDate,
                          onTap: () => _showDatePicker(context, true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDateSelector(
                          label: 'Check-out',
                          date: _checkOutDate,
                          onTap: () => _showDatePicker(context, false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => _showGuestPicker(context),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.lightBlack,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.mutedGold, width: 1),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.people, color: AppColors.primaryGold),
                          const SizedBox(width: 12),
                          Text(
                            '$_guestCount Guest${_guestCount > 1 ? 's' : ''}',
                            style: const TextStyle(
                              color: AppColors.pureWhite,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_drop_down, color: AppColors.mutedGold),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Available Rooms',
                    style: TextStyle(
                      color: AppColors.primaryGold,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: mockRooms.length,
                    itemBuilder: (context, index) {
                      final room = mockRooms[index];
                      final isSelected = _selectedRoomIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedRoomIndex = index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.lightBlack,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? AppColors.primaryGold : AppColors.mutedGold,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      room.images.isNotEmpty ? room.images[0] : '',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 100,
                                          height: 100,
                                          color: AppColors.primaryBlack,
                                          child: const Icon(
                                            Icons.bed,
                                            color: AppColors.mutedGold,
                                            size: 40,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          room.roomType,
                                          style: const TextStyle(
                                            color: AppColors.pureWhite,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          room.viewType,
                                          style: const TextStyle(
                                            color: AppColors.mutedGold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.square_foot, color: AppColors.primaryGold, size: 16),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${room.sizeInSqMeters.toStringAsFixed(0)} m²',
                                              style: const TextStyle(
                                                color: AppColors.pureWhite,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            const Icon(Icons.person, color: AppColors.primaryGold, size: 16),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${room.capacity} guests',
                                              style: const TextStyle(
                                                color: AppColors.pureWhite,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.star, color: AppColors.primaryGold, size: 16),
                                            const SizedBox(width: 4),
                                            Text(
                                              room.rating.toStringAsFixed(1),
                                              style: const TextStyle(
                                                color: AppColors.pureWhite,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: room.amenities.take(4).map((amenity) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryBlack,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      amenity,
                                      style: const TextStyle(
                                        color: AppColors.mutedGold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '\$${room.pricePerNight.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: AppColors.primaryGold,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        'per night',
                                        style: TextStyle(
                                          color: AppColors.mutedGold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (isSelected)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryGold,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'Selected',
                                        style: TextStyle(
                                          color: AppColors.primaryBlack,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  else
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryBlack,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: AppColors.primaryGold, width: 1),
                                      ),
                                      child: const Text(
                                        'Select',
                                        style: TextStyle(
                                          color: AppColors.primaryGold,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Location',
                    style: TextStyle(
                      color: AppColors.primaryGold,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.lightBlack,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.mutedGold, width: 1),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map, color: AppColors.primaryGold, size: 40),
                          SizedBox(height: 8),
                          Text(
                            'View on Map',
                            style: TextStyle(
                              color: AppColors.primaryGold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Tap to see location details',
                            style: TextStyle(
                              color: AppColors.mutedGold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Reviews',
                    style: TextStyle(
                      color: AppColors.primaryGold,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlack,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.mutedGold, width: 1),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.hotel.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: AppColors.primaryGold,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(5, (index) {
                                return Row(
                                  children: [
                                    Icon(
                                      index < widget.hotel.rating.floor()
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: AppColors.primaryGold,
                                      size: 16,
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${widget.hotel.reviewCount} reviews',
                          style: const TextStyle(
                            color: AppColors.mutedGold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '"Absolutely stunning hotel with impeccable service. The golden luxury theme throughout the property is breathtaking. Will definitely return!"',
                          style: TextStyle(
                            color: AppColors.pureWhite,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '- John D.',
                          style: TextStyle(
                            color: AppColors.primaryGold,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkBlack,
          border: const Border(
            top: BorderSide(color: AppColors.primaryGold, width: 1),
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${widget.hotel.pricePerNight.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.primaryGold,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'per night',
                      style: TextStyle(
                        color: AppColors.mutedGold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: GoldenButton(
                  text: 'Book Now',
                  onPressed: () => _bookRoom(mockRooms[_selectedRoomIndex]),
                  icon: Icons.arrow_forward,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightBlack,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.mutedGold, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primaryGold, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.pureWhite,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.lightBlack,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.mutedGold, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.mutedGold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: AppColors.primaryGold, size: 16),
                const SizedBox(width: 8),
                Text(
                  date != null ? '${date.day}/${date.month}/${date.year}' : 'Select date',
                  style: const TextStyle(
                    color: AppColors.pureWhite,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getAmenityIcon(String amenity) {
    final lowerAmenity = amenity.toLowerCase();
    if (lowerAmenity.contains('wifi')) return Icons.wifi;
    if (lowerAmenity.contains('pool')) return Icons.pool;
    if (lowerAmenity.contains('gym') || lowerAmenity.contains('fitness')) return Icons.fitness_center;
    if (lowerAmenity.contains('spa')) return Icons.spa;
    if (lowerAmenity.contains('restaurant')) return Icons.restaurant;
    if (lowerAmenity.contains('parking')) return Icons.local_parking;
    if (lowerAmenity.contains('room service')) return Icons.room_service;
    if (lowerAmenity.contains('bar')) return Icons.local_bar;
    if (lowerAmenity.contains('ac') || lowerAmenity.contains('air conditioning')) return Icons.ac_unit;
    if (lowerAmenity.contains('laundry')) return Icons.local_laundry_service;
    if (lowerAmenity.contains('concierge')) return Icons.support_agent;
    if (lowerAmenity.contains('pet')) return Icons.pets;
    if (lowerAmenity.contains('beach')) return Icons.beach_access;
    if (lowerAmenity.contains('airport')) return Icons.flight;
    return Icons.check_circle_outline;
  }

  List<Room> _generateMockRooms() {
    return [
      Room(
        id: '1',
        hotelId: widget.hotel.id,
        roomType: 'Deluxe Room',
        description: 'Elegant room with city views and premium amenities.',
        pricePerNight: widget.hotel.pricePerNight,
        currency: widget.hotel.currency,
        capacity: 2,
        images: widget.hotel.images.isNotEmpty ? [widget.hotel.images[0]] : [],
        amenities: ['King Bed', 'City View', 'Mini Bar', 'Safe'],
        isAvailable: true,
        sizeInSqMeters: 35,
        bedType: 'King',
        numberOfRooms: 10,
        availableRooms: 5,
        rating: 4.5,
        isFeatured: true,
        viewType: 'City View',
      ),
      Room(
        id: '2',
        hotelId: widget.hotel.id,
        roomType: 'Suite',
        description: 'Spacious suite with separate living area and panoramic views.',
        pricePerNight: widget.hotel.pricePerNight * 1.8,
        currency: widget.hotel.currency,
        capacity: 3,
        images: widget.hotel.images.length > 1 ? [widget.hotel.images[1]] : [],
        amenities: ['King Bed', 'Living Room', 'Panoramic View', 'Butler Service'],
        isAvailable: true,
        sizeInSqMeters: 65,
        bedType: 'King',
        numberOfRooms: 5,
        availableRooms: 2,
        rating: 4.8,
        isFeatured: true,
        viewType: 'Panoramic View',
      ),
      Room(
        id: '3',
        hotelId: widget.hotel.id,
        roomType: 'Presidential Suite',
        description: 'The ultimate luxury experience with private terrace.',
        pricePerNight: widget.hotel.pricePerNight * 3.5,
        currency: widget.hotel.currency,
        capacity: 4,
        images: widget.hotel.images.length > 2 ? [widget.hotel.images[2]] : [],
        amenities: ['Private Terrace', 'Jacuzzi', 'Private Chef', 'Cinema Room'],
        isAvailable: true,
        sizeInSqMeters: 150,
        bedType: 'King',
        numberOfRooms: 2,
        availableRooms: 1,
        rating: 5.0,
        isFeatured: true,
        viewType: 'Ocean View',
      ),
    ];
  }
}