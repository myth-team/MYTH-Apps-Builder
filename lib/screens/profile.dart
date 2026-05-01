import 'package:flutter/material.dart';
import 'package:golden_stay_app/models/user.dart'; 
import 'package:golden_stay_app/models/booking.dart'; 
import 'package:golden_stay_app/utils/colors.dart'; 
import 'package:golden_stay_app/utils/constants.dart'; 
import 'package:golden_stay_app/widgets/golden_button.dart'; 
import 'package:golden_stay_app/widgets/custom_text_field.dart'; 

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User _currentUser = User(
    id: 'user_001',
    email: 'john.doe@email.com',
    firstName: 'John',
    lastName: 'Doe',
    phoneNumber: '+1 234 567 8900',
    profileImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    dateOfBirth: DateTime(1990, 5, 15),
    address: UserAddress(
      street: '123 Luxury Avenue',
      city: 'New York',
      state: 'NY',
      zipCode: '10001',
      country: 'USA',
    ),
    nationality: 'American',
    passportNumber: 'AB1234567',
    bookingIds: ['booking_001', 'booking_002'],
    favoriteHotelIds: ['hotel_001', 'hotel_002', 'hotel_003'],
    loyaltyPoints: 15420,
    loyaltyTier: LoyaltyTier.platinum,
    preferredCurrency: 'USD',
    isVerified: true,
    createdAt: DateTime(2022, 1, 15),
  );

  List<Booking> _recentBookings = [
    Booking(
      id: 'booking_001',
      userId: 'user_001',
      hotelId: 'hotel_001',
      hotelName: 'The Grand Palace',
      hotelImage: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
      roomId: 'room_001',
      roomType: 'Deluxe Suite',
      checkInDate: DateTime.now().add(const Duration(days: 5)),
      checkOutDate: DateTime.now().add(const Duration(days: 8)),
      numberOfGuests: 2,
      numberOfNights: 3,
      pricePerNight: 450.00,
      totalPrice: 1350.00,
      currency: 'USD',
      status: BookingStatus.confirmed,
      paymentStatus: PaymentStatus.paid,
      specialRequests: 'Late check-in, high floor',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Booking(
      id: 'booking_002',
      userId: 'user_001',
      hotelId: 'hotel_002',
      hotelName: 'Oceanview Resort',
      hotelImage: 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400',
      roomId: 'room_002',
      roomType: 'Presidential Suite',
      checkInDate: DateTime.now().subtract(const Duration(days: 10)),
      checkOutDate: DateTime.now().subtract(const Duration(days: 5)),
      numberOfGuests: 2,
      numberOfNights: 5,
      pricePerNight: 850.00,
      totalPrice: 4250.00,
      currency: 'USD',
      status: BookingStatus.completed,
      paymentStatus: PaymentStatus.paid,
      specialRequests: 'Champagne on arrival',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primaryBlack,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.darkGold.withOpacity(0.3),
                      AppColors.primaryBlack,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      _buildProfileImage(),
                      const SizedBox(height: 16),
                      _buildUserName(),
                      const SizedBox(height: 8),
                      _buildUserEmail(),
                      const SizedBox(height: 12),
                      _buildLoyaltyBadge(),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: AppColors.primaryGold),
                onPressed: () => _showSettingsSheet(context),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLoyaltyPointsSection(),
                  const SizedBox(height: 24),
                  _buildAccountInfoSection(),
                  const SizedBox(height: 24),
                  _buildRecentBookingsSection(),
                  const SizedBox(height: 24),
                  _buildQuickActionsSection(),
                  const SizedBox(height: 24),
                  _buildVerificationStatus(),
                  const SizedBox(height: 40),
                  _buildLogoutButton(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryGold,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGold.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 55,
        backgroundColor: AppColors.lightBlack,
        backgroundImage: NetworkImage(_currentUser.profileImage),
      ),
    );
  }

  Widget _buildUserName() {
    return Text(
      '${_currentUser.firstName} ${_currentUser.lastName}',
      style: const TextStyle(
        color: AppColors.pureWhite,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildUserEmail() {
    return Text(
      _currentUser.email,
      style: const TextStyle(
        color: AppColors.mutedGold,
        fontSize: 14,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildLoyaltyBadge() {
    Color badgeColor;
    String tierName;
    IconData tierIcon;

    switch (_currentUser.loyaltyTier) {
      case LoyaltyTier.platinum:
        badgeColor = AppColors.lightGold;
        tierName = 'Platinum Member';
        tierIcon = Icons.diamond_outlined;
        break;
      case LoyaltyTier.gold:
        badgeColor = AppColors.darkGold;
        tierName = 'Gold Member';
        tierIcon = Icons.workspace_premium_outlined;
        break;
      case LoyaltyTier.silver:
        badgeColor = AppColors.mutedGold;
        tierName = 'Silver Member';
        tierIcon = Icons.star_outline;
        break;
      case LoyaltyTier.bronze:
        badgeColor = Colors.brown.shade400;
        tierName = 'Bronze Member';
        tierIcon = Icons.star_half_outlined;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(tierIcon, color: badgeColor, size: 18),
          const SizedBox(width: 6),
          Text(
            tierName,
            style: TextStyle(
              color: badgeColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoyaltyPointsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lightBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryGold.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Loyalty Points',
                style: TextStyle(
                  color: AppColors.pureWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Level Up!',
                  style: TextStyle(
                    color: AppColors.primaryGold,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${_currentUser.loyaltyPoints}',
                style: const TextStyle(
                  color: AppColors.lightGold,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(
                  'points',
                  style: TextStyle(
                    color: AppColors.mutedGold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.72,
              backgroundColor: AppColors.darkBlack,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGold),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '2,580 points to next Platinum tier',
            style: TextStyle(
              color: AppColors.mutedGold.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account Information',
          style: TextStyle(
            color: AppColors.pureWhite,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightBlack,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildInfoTile(
                icon: Icons.phone_outlined,
                title: 'Phone Number',
                value: _currentUser.phoneNumber,
                onTap: () => _showEditFieldDialog(context, 'Phone', _currentUser.phoneNumber),
              ),
              _buildDivider(),
              _buildInfoTile(
                icon: Icons.location_on_outlined,
                title: 'Address',
                value: _currentUser.address != null 
                    ? '${_currentUser.address!.city}, ${_currentUser.address!.country}'
                    : 'Not set',
                onTap: () => _showEditAddressDialog(context),
              ),
              _buildDivider(),
              _buildInfoTile(
                icon: Icons.cake_outlined,
                title: 'Date of Birth',
                value: '${_currentUser.dateOfBirth.day}/${_currentUser.dateOfBirth.month}/${_currentUser.dateOfBirth.year}',
                onTap: () => _showEditFieldDialog(context, 'Date of Birth', '15/05/1990'),
              ),
              _buildDivider(),
              _buildInfoTile(
                icon: Icons.public_outlined,
                title: 'Nationality',
                value: _currentUser.nationality,
                onTap: () => _showEditFieldDialog(context, 'Nationality', _currentUser.nationality),
              ),
              _buildDivider(),
              _buildInfoTile(
                icon: Icons.badge_outlined,
                title: 'Passport Number',
                value: _currentUser.passportNumber ?? 'Not set',
                onTap: () => _showEditFieldDialog(context, 'Passport', _currentUser.passportNumber ?? ''),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primaryGold, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.mutedGold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      color: AppColors.pureWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.mutedGold,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: AppColors.darkBlack.withOpacity(0.5),
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _buildRecentBookingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Bookings',
              style: TextStyle(
                color: AppColors.pureWhite,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'View All',
                style: TextStyle(
                  color: AppColors.primaryGold,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _recentBookings.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final booking = _recentBookings[index];
              return _buildBookingCard(booking);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBookingCard(Booking booking) {
    Color statusColor;
    String statusText;

    switch (booking.status) {
      case BookingStatus.confirmed:
        statusColor = Colors.green;
        statusText = 'Confirmed';
        break;
      case BookingStatus.completed:
        statusColor = AppColors.primaryGold;
        statusText = 'Completed';
        break;
      case BookingStatus.cancelled:
        statusColor = Colors.red;
        statusText = 'Cancelled';
        break;
      case BookingStatus.pending:
        statusColor = Colors.orange;
        statusText = 'Pending';
        break;
    }

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: AppColors.lightBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryGold.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              booking.hotelImage,
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.hotelName,
                  style: const TextStyle(
                    color: AppColors.pureWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  booking.roomType,
                  style: const TextStyle(
                    color: AppColors.mutedGold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '${booking.currency} ${booking.totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppColors.primaryGold,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
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

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            color: AppColors.pureWhite,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightBlack,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildActionTile(
                icon: Icons.favorite_outline,
                title: 'Favorite Hotels',
                subtitle: '${_currentUser.favoriteHotelIds.length} hotels saved',
                onTap: () {},
              ),
              _buildDivider(),
              _buildActionTile(
                icon: Icons.history,
                title: 'Booking History',
                subtitle: 'View all past bookings',
                onTap: () {},
              ),
              _buildDivider(),
              _buildActionTile(
                icon: Icons.payment_outlined,
                title: 'Payment Methods',
                subtitle: 'Manage your cards',
                onTap: () {},
              ),
              _buildDivider(),
              _buildActionTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Manage preferences',
                onTap: () {},
              ),
              _buildDivider(),
              _buildActionTile(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Get assistance',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primaryGold, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.pureWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.mutedGold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.mutedGold,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryGold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryGold.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.verified_outlined, color: Colors.green, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Account Verified',
                  style: TextStyle(
                    color: AppColors.pureWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Your identity has been verified',
                  style: TextStyle(
                    color: AppColors.mutedGold.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: Colors.green, size: 24),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: GoldenButton(
        text: 'Log Out',
        style: GoldenButtonStyle.outlined,
        icon: Icons.logout,
        onPressed: () => _showLogoutDialog(context),
      ),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.primaryBlack,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.mutedGold.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Settings',
              style: TextStyle(
                color: AppColors.pureWhite,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildSettingsTile(Icons.language, 'Language', 'English'),
            _buildSettingsTile(Icons.attach_money, 'Currency', 'USD'),
            _buildSettingsTile(Icons.dark_mode_outlined, 'Theme', 'Dark'),
            _buildSettingsTile(Icons.lock_outline, 'Privacy', ''),
            _buildSettingsTile(Icons.description_outlined, 'Terms', ''),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryGold, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.pureWhite,
                fontSize: 16,
              ),
            ),
          ),
          if (value.isNotEmpty)
            Text(
              value,
              style: const TextStyle(
                color: AppColors.mutedGold,
                fontSize: 14,
              ),
            ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: AppColors.mutedGold),
        ],
      ),
    );
  }

  void _showEditFieldDialog(BuildContext context, String fieldName, String currentValue) {
    final controller = TextEditingController(text: currentValue);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.lightBlack,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Edit $fieldName',
          style: const TextStyle(color: AppColors.pureWhite),
        ),
        content: CustomTextField(
          controller: controller,
          hintText: 'Enter $fieldName',
          style: CustomTextFieldStyle.filled,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.mutedGold),
            ),
          ),
          GoldenButton(
            text: 'Save',
            style: GoldenButtonStyle.filled,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showEditAddressDialog(BuildContext context) {
    final streetController = TextEditingController(text: _currentUser.address?.street ?? '');
    final cityController = TextEditingController(text: _currentUser.address?.city ?? '');
    final stateController = TextEditingController(text: _currentUser.address?.state ?? '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.lightBlack,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Edit Address',
          style: TextStyle(color: AppColors.pureWhite),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: streetController,
                labelText: 'Street Address',
                style: CustomTextFieldStyle.filled,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: cityController,
                labelText: 'City',
                style: CustomTextFieldStyle.filled,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: stateController,
                labelText: 'State',
                style: CustomTextFieldStyle.filled,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.mutedGold),
            ),
          ),
          GoldenButton(
            text: 'Save',
            style: GoldenButtonStyle.filled,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.lightBlack,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Log Out',
          style: TextStyle(color: AppColors.pureWhite),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: AppColors.mutedGold),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.mutedGold),
            ),
          ),
          GoldenButton(
            text: 'Log Out',
            style: GoldenButtonStyle.filled,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}