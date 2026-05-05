import 'package:flutter/material.dart';
import 'package:elite_eats_app/utils/colors.dart'; 

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, Color(0xFFFF8A5C)],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: AppColors.surface,
                        child: CircleAvatar(
                          radius: 42,
                          backgroundImage: const NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Alex Johnson',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'alex@example.com',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Quick Actions'),
                  const SizedBox(height: 12),
                  _buildQuickActionsGrid(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('My Addresses'),
                  const SizedBox(height: 12),
                  _buildAddressesCard(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Payment Methods'),
                  const SizedBox(height: 12),
                  _buildPaymentMethodsCard(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Settings'),
                  const SizedBox(height: 12),
                  _buildSettingsList(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildQuickActionCard(
          icon: Icons.receipt_long,
          title: 'Order History',
          color: AppColors.primary,
          onTap: () {},
        ),
        _buildQuickActionCard(
          icon: Icons.favorite,
          title: 'Favorites',
          color: AppColors.error,
          onTap: () {},
        ),
        _buildQuickActionCard(
          icon: Icons.local_offer,
          title: 'Promotions',
          color: AppColors.success,
          onTap: () {},
        ),
        _buildQuickActionCard(
          icon: Icons.support_agent,
          title: 'Support',
          color: AppColors.accent,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressesCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
      ),
      child: Column(
        children: [
          _buildAddressTile(
            icon: Icons.home,
            title: 'Home',
            subtitle: '123 Main Street, Apt 4B',
            isDefault: true,
          ),
          const Divider(height: 1, color: AppColors.divider),
          _buildAddressTile(
            icon: Icons.work,
            title: 'Office',
            subtitle: '456 Business Ave, Floor 12',
            isDefault: false,
          ),
          const Divider(height: 1, color: AppColors.divider),
          _buildAddressTile(
            icon: Icons.add_location_alt,
            title: 'Add New Address',
            subtitle: 'Add a new delivery address',
            isDefault: false,
            isAdd: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDefault,
    bool isAdd = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isAdd ? AppColors.primary.withValues(alpha: 0.1) : AppColors.accent.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isAdd ? AppColors.primary : AppColors.accent, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isAdd ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
      subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      trailing: isDefault
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Default', style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w500)),
            )
          : const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: () {},
    );
  }

  Widget _buildPaymentMethodsCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
      ),
      child: Column(
        children: [
          _buildPaymentTile(
            icon: Icons.credit_card,
            title: 'Visa •••• 4242',
            subtitle: 'Expires 12/25',
            isDefault: true,
          ),
          const Divider(height: 1, color: AppColors.divider),
          _buildPaymentTile(
            icon: Icons.credit_card,
            title: 'Mastercard •••• 8888',
            subtitle: 'Expires 06/26',
            isDefault: false,
          ),
          const Divider(height: 1, color: AppColors.divider),
          _buildPaymentTile(
            icon: Icons.add_card,
            title: 'Add New Card',
            subtitle: 'Add a payment method',
            isDefault: false,
            isAdd: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDefault,
    bool isAdd = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isAdd ? AppColors.primary.withValues(alpha: 0.1) : AppColors.accent.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isAdd ? AppColors.primary : AppColors.accent, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isAdd ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
      subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      trailing: isDefault
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Default', style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w500)),
            )
          : const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: () {},
    );
  }

  Widget _buildSettingsList() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
      ),
      child: Column(
        children: [
          _buildSettingsTile(Icons.notifications, 'Notifications'),
          const Divider(height: 1, color: AppColors.divider),
          _buildSettingsTile(Icons.security, 'Privacy & Security'),
          const Divider(height: 1, color: AppColors.divider),
          _buildSettingsTile(Icons.help, 'Help Center'),
          const Divider(height: 1, color: AppColors.divider),
          _buildSettingsTile(Icons.info, 'About'),
          const Divider(height: 1, color: AppColors.divider),
          _buildSettingsTile(Icons.logout, 'Log Out', color: AppColors.error),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, {Color color = AppColors.textPrimary}) {
    return ListTile(
      leading: Icon(icon, color: color == AppColors.error ? color : AppColors.accent),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: () {},
    );
  }
}