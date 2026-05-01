import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ridenow_app/utils/colors.dart'; 
import 'package:ridenow_app/models/user.dart'; 
import 'package:ridenow_app/models/ride.dart'; 
import 'package:ridenow_app/services/ride_service.dart'; 

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mockUser = _createMockUser();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(mockUser),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildProfileHeader(mockUser),
                _buildStatsSection(),
                _buildPaymentMethodsSection(mockUser),
                _buildSettingsSection(),
                _buildSupportSection(),
                _buildLogoutButton(),
                SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(User user) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textOnPrimary,
          ),
        ),
        centerTitle: true,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.edit, color: AppColors.textOnPrimary),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.settings, color: AppColors.textOnPrimary),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildProfileHeader(User user) {
    return Container(
      transform: Matrix4.translationValues(0, -30, 0),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surface, width: 4),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: user.photoUrl != null
                  ? CachedNetworkImage(
                      imageUrl: user.photoUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _buildInitialsAvatar(user.initials),
                      errorWidget: (context, url, error) => _buildInitialsAvatar(user.initials),
                    )
                  : _buildInitialsAvatar(user.initials),
            ),
          ),
          SizedBox(height: 16),
          Text(
            user.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          if (user.phoneNumber != null) ...[
            SizedBox(height: 4),
            Text(
              user.phoneNumber!,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, size: 16, color: AppColors.accent),
                SizedBox(width: 4),
                Text(
                  '${user.rating.toStringAsFixed(1)} Rating',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialsAvatar(String initials) {
    return Container(
      color: AppColors.primaryLight,
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: AppColors.textOnPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Consumer<RideService>(
      builder: (context, rideService, child) {
        final history = rideService.rideHistory;
        final totalRides = history.where((r) => r.isCompleted).length;
        final totalSpent = history
            .where((r) => r.isCompleted && r.actualPrice != null)
            .fold<double>(0, (sum, r) => sum + r.actualPrice!);

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Total Rides', totalRides.toString(), Icons.directions_car),
              Container(
                width: 1,
                height: 40,
                color: AppColors.border,
              ),
              _buildStatItem('Total Spent', '\$${totalSpent.toStringAsFixed(0)}', Icons.payments),
              Container(
                width: 1,
                height: 40,
                color: AppColors.border,
              ),
              _buildStatItem('Member Since', '2024', Icons.calendar_today),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodsSection(User user) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
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
                'Payment Methods',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_circle, color: AppColors.primary),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 12),
          if (user.paymentMethods.isEmpty)
            _buildEmptyPaymentState()
          else
            ...user.paymentMethods.map((method) => _buildPaymentMethodTile(method)),
        ],
      ),
    );
  }

  Widget _buildEmptyPaymentState() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.credit_card, color: AppColors.textTertiary),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'No payment methods added',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(PaymentMethod method) {
    IconData icon;
    switch (method.type) {
      case PaymentMethodType.applePay:
        icon = Icons.apple;
        break;
      case PaymentMethodType.googlePay:
        icon = Icons.g_mobiledata;
        break;
      case PaymentMethodType.paypal:
        icon = Icons.paypal;
        break;
      default:
        icon = Icons.credit_card;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: method.isDefault
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.textPrimary),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method.displayName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (method.expiryDisplay.isNotEmpty)
                  Text(
                    'Expires ${method.expiryDisplay}',
                    style: TextStyle(
                      fontSize: 12,
                      color: method.isExpired ? AppColors.error : AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          if (method.isDefault)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Default',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          _buildSettingsTile(Icons.notifications, 'Notifications', 'On'),
          _buildSettingsTile(Icons.location_on, 'Location', 'Always'),
          _buildSettingsTile(Icons.dark_mode, 'Dark Mode', 'Off'),
          _buildSettingsTile(Icons.language, 'Language', 'English'),
          _buildSettingsTile(Icons.security, 'Privacy & Security', ''),
          _buildSettingsTile(Icons.emergency, 'Emergency Contact', ''),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, String trailing) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: trailing.isNotEmpty
          ? Text(
              trailing,
              style: TextStyle(color: AppColors.textSecondary),
            )
          : Icon(Icons.chevron_right, color: AppColors.textTertiary),
      onTap: () {},
    );
  }

  Widget _buildSupportSection() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Support',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          _buildSupportTile(Icons.help_outline, 'Help Center'),
          _buildSupportTile(Icons.description, 'Terms of Service'),
          _buildSupportTile(Icons.privacy_tip, 'Privacy Policy'),
          _buildSupportTile(Icons.info_outline, 'About'),
        ],
      ),
    );
  }

  Widget _buildSupportTile(IconData icon, String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: AppColors.textTertiary),
      onTap: () {},
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.logout, color: AppColors.error),
          label: Text(
            'Log Out',
            style: TextStyle(color: AppColors.error),
          ),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 14),
            side: BorderSide(color: AppColors.error),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  User _createMockUser() {
    return User(
      id: 'user_1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phoneNumber: '+1 (555) 123-4567',
      photoUrl: null,
      rating: 4.8,
      createdAt: DateTime(2024, 1, 15),
      isEmailVerified: true,
      isPhoneVerified: true,
      paymentMethods: [
        PaymentMethod(
          id: 'pm_1',
          type: PaymentMethodType.card,
          lastFourDigits: '4242',
          cardBrand: 'Visa',
          expiryMonth: 12,
          expiryYear: 2026,
          cardholderName: 'John Doe',
          isDefault: true,
        ),
        PaymentMethod(
          id: 'pm_2',
          type: PaymentMethodType.applePay,
          lastFourDigits: '',
          isDefault: false,
        ),
      ],
      defaultPaymentMethodId: 'pm_1',
    );
  }
}