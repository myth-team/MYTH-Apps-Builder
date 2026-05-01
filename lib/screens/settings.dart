import 'package:flutter/material.dart';
import 'package:golden_stay_app/utils/colors.dart'; 
import 'package:golden_stay_app/utils/constants.dart'; 
import 'package:golden_stay_app/widgets/golden_button.dart'; 

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotificationsEnabled = true;
  bool _smsNotificationsEnabled = false;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'USD';
  bool _darkModeEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlack,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryGold),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColors.primaryGold,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Account'),
            _buildSettingsTile(
              icon: Icons.person_outline,
              title: 'Personal Information',
              subtitle: 'Update your personal details',
              onTap: () => _showComingSoonDialog('Personal Information'),
            ),
            _buildSettingsTile(
              icon: Icons.lock_outline,
              title: 'Security',
              subtitle: 'Password and authentication',
              onTap: () => _showComingSoonDialog('Security'),
            ),
            _buildSettingsTile(
              icon: Icons.credit_card_outlined,
              title: 'Payment Methods',
              subtitle: 'Manage your payment options',
              onTap: () => _showComingSoonDialog('Payment Methods'),
            ),
            _buildSectionHeader('Preferences'),
            _buildSwitchTile(
              icon: Icons.notifications_outlined,
              title: 'Push Notifications',
              subtitle: 'Receive booking updates',
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            _buildSwitchTile(
              icon: Icons.email_outlined,
              title: 'Email Notifications',
              subtitle: 'Receive promotional emails',
              value: _emailNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _emailNotificationsEnabled = value;
                });
              },
            ),
            _buildSwitchTile(
              icon: Icons.sms_outlined,
              title: 'SMS Notifications',
              subtitle: 'Receive text messages',
              value: _smsNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _smsNotificationsEnabled = value;
                });
              },
            ),
            _buildDropdownTile(
              icon: Icons.language,
              title: 'Language',
              subtitle: _selectedLanguage,
              value: _selectedLanguage,
              items: const ['English', 'Spanish', 'French', 'German', 'Italian'],
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
            ),
            _buildDropdownTile(
              icon: Icons.attach_money,
              title: 'Currency',
              subtitle: _selectedCurrency,
              value: _selectedCurrency,
              items: const ['USD', 'EUR', 'GBP', 'JPY', 'AUD'],
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value!;
                });
              },
            ),
            _buildSectionHeader('Support'),
            _buildSettingsTile(
              icon: Icons.help_outline,
              title: 'Help Center',
              subtitle: 'Get help and support',
              onTap: () => _showComingSoonDialog('Help Center'),
            ),
            _buildSettingsTile(
              icon: Icons.chat_bubble_outline,
              title: 'Contact Us',
              subtitle: 'Reach out to our team',
              onTap: () => _showComingSoonDialog('Contact Us'),
            ),
            _buildSettingsTile(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              subtitle: 'Read our terms',
              onTap: () => _showComingSoonDialog('Terms of Service'),
            ),
            _buildSettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'How we handle your data',
              onTap: () => _showComingSoonDialog('Privacy Policy'),
            ),
            _buildSettingsTile(
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'App version ${AppConstants.appVersion}',
              onTap: () => _showAboutDialog(),
            ),
            _buildSectionHeader('Account Actions'),
            _buildSettingsTile(
              icon: Icons.logout,
              title: 'Log Out',
              subtitle: 'Sign out of your account',
              titleColor: AppColors.darkGold,
              onTap: () => _showLogoutDialog(),
              showArrow: false,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primaryGold,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? titleColor,
    bool showArrow = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(
            color: AppColors.lightBlack,
            border: Border(
              bottom: BorderSide(
                color: AppColors.darkBlack,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.darkBlack,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: titleColor ?? AppColors.primaryGold,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: titleColor ?? AppColors.pureWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.mutedGold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (showArrow)
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.mutedGold,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.lightBlack,
        border: Border(
          bottom: BorderSide(
            color: AppColors.darkBlack,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.darkBlack,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryGold,
              size: 22,
            ),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.mutedGold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryGold,
            activeTrackColor: AppColors.darkGold.withValues(alpha: 0.5),
            inactiveThumbColor: AppColors.mutedGold,
            inactiveTrackColor: AppColors.darkBlack,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.lightBlack,
        border: Border(
          bottom: BorderSide(
            color: AppColors.darkBlack,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.darkBlack,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryGold,
              size: 22,
            ),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.mutedGold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            initialValue: value,
            onSelected: onChanged,
            color: AppColors.lightBlack,
            icon: const Icon(
              Icons.chevron_right,
              color: AppColors.mutedGold,
            ),
            itemBuilder: (context) {
              return items.map((item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      color: item == value
                          ? AppColors.primaryGold
                          : AppColors.pureWhite,
                    ),
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.lightBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Coming Soon',
          style: TextStyle(
            color: AppColors.primaryGold,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          '$feature will be available in a future update.',
          style: const TextStyle(
            color: AppColors.pureWhite,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(
                color: AppColors.primaryGold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.lightBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.darkBlack,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryGold,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.hotel,
                color: AppColors.primaryGold,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Golden Stay',
              style: TextStyle(
                color: AppColors.primaryGold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Version ${AppConstants.appVersion}',
              style: const TextStyle(
                color: AppColors.pureWhite,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Luxury hotel booking app',
              style: TextStyle(
                color: AppColors.mutedGold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Experience luxury like never before. Book your perfect stay with Golden Stay.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.pureWhite,
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(
                color: AppColors.primaryGold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.lightBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Log Out',
          style: TextStyle(
            color: AppColors.darkGold,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(
            color: AppColors.pureWhite,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.mutedGold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Logged out successfully'),
                  backgroundColor: AppColors.lightBlack,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            child: const Text(
              'Log Out',
              style: TextStyle(
                color: AppColors.darkGold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}