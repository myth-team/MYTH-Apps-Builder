import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project_app/utils/colors.dart'; 

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context)),
        title: Text('Profile', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildUserHeader(),
            const SizedBox(height: 24),
            _buildPaymentMethodsSection(),
            const SizedBox(height: 24),
            _buildSettingsList(),
            const SizedBox(height: 24),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider), boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8)]),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(36)),
            child: Icon(Icons.person, size: 40, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('John Doe', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text('john.doe@email.com', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text('Verified', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.success)),
                ),
              ],
            ),
          ),
          IconButton(icon: Icon(Icons.edit, color: AppColors.textSecondary), onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text('Payment Methods', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ),
        Container(
          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider), boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8)]),
          child: Column(
            children: [
              _buildPaymentMethodItem(Icons.credit_card, 'Visa •••• 4242', 'Default'),
              Divider(height: 1, color: AppColors.divider),
              _buildPaymentMethodItem(Icons.credit_card, 'Mastercard •••• 8888', null),
              Divider(height: 1, color: AppColors.divider),
              _buildAddPaymentButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodItem(IconData icon, String label, String? badge) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 20, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary))),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
              child: Text(badge, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.accent)),
            ),
        ],
      ),
    );
  }

  Widget _buildAddPaymentButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.add, size: 20, color: AppColors.accent),
          ),
          const SizedBox(width: 12),
          Text('Add Payment Method', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.accent)),
        ],
      ),
    );
  }

  Widget _buildSettingsList() {
    final settings = [
      {'icon': Icons.notifications_outlined, 'title': 'Notifications', 'trail': 'On'},
      {'icon': Icons.language, 'title': 'Language', 'trail': 'English'},
      {'icon': Icons.privacy_tip_outlined, 'title': 'Privacy', 'trail': null},
      {'icon': Icons.help_outline, 'title': 'Help & Support', 'trail': null},
      {'icon': Icons.info_outline, 'title': 'About', 'trail': null},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text('Settings', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ),
        Container(
          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider), boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8)]),
          child: Column(
            children: settings.asMap().entries.map((entry) {
              final setting = entry.value;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
                          child: Icon(setting['icon'] as IconData, size: 20, color: AppColors.textPrimary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(setting['title'] as String, style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary))),
                        if (setting['trail'] != null)
                          Text(setting['trail'] as String, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                        if (setting['trail'] == null) Icon(Icons.chevron_right, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                  if (entry.key < settings.length - 1) Divider(height: 1, color: AppColors.divider),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: () => _showLogoutDialog(context),
        style: OutlinedButton.styleFrom(side: BorderSide(color: AppColors.error), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: AppColors.error, size: 20),
            const SizedBox(width: 8),
            Text('Log Out', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.error)),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Log Out?', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text('Are you sure you want to log out?', style: GoogleFonts.poppins()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textSecondary))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/home');
            },
            child: Text('Log Out', style: GoogleFonts.poppins(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}