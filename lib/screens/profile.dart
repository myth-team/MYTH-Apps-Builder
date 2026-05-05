import 'package:flutter/material.dart';
import 'package:ruby_rose_jewels_app/utils/colors.dart'; 

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _ProfileHeader(),
            const SizedBox(height: 24),
            _OrderHistorySection(),
            const SizedBox(height: 24),
            _SettingsSection(),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      color: AppColors.surface,
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primaryLight,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text('Ruby Rose Customer', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text('ruby.rose@email.com', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _OrderHistorySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          ..._sampleOrders.map((order) => _OrderCard(order: order)).toList(),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> get _sampleOrders => [
    {'id': 'ORD-001', 'date': '2024-01-15', 'status': 'Delivered', 'total': 299.99},
    {'id': 'ORD-002', 'date': '2024-01-10', 'status': 'Shipped', 'total': 149.99},
  ];
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final statusColor = order['status'] == 'Delivered' ? AppColors.success : AppColors.gold;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order #${order['id']}', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(order['date'], style: TextStyle(fontSize: 12, color: AppColors.textLight)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('\$${(order['total'] as double).toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                  child: Text(order['status'], style: TextStyle(fontSize: 12, color: statusColor, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _SettingsTile(icon: Icons.location_on_outlined, title: 'Shipping Addresses', onTap: () {}),
                Divider(height: 1, color: AppColors.divider),
                _SettingsTile(icon: Icons.payment_outlined, title: 'Payment Methods', onTap: () {}),
                Divider(height: 1, color: AppColors.divider),
                _SettingsTile(icon: Icons.notifications_outlined, title: 'Notifications', onTap: () {}),
                Divider(height: 1, color: AppColors.divider),
                _SettingsTile(icon: Icons.help_outline, title: 'Help & Support', onTap: () {}),
                Divider(height: 1, color: AppColors.divider),
                _SettingsTile(icon: Icons.logout, title: 'Sign Out', onTap: () {}, textColor: AppColors.error),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;

  const _SettingsTile({required this.icon, required this.title, required this.onTap, this.textColor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppColors.textSecondary),
      title: Text(title, style: TextStyle(color: textColor ?? AppColors.textPrimary)),
      trailing: Icon(Icons.chevron_right, color: AppColors.textLight),
      onTap: onTap,
    );
  }
}